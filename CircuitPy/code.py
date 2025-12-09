import time
import wifi
import socketpool
import ssl
import adafruit_requests
import json
import board
import busio
from adafruit_bus_device.i2c_device import I2CDevice
import displayio
import terminalio
from adafruit_display_text import bitmap_label
import math

# === CONFIGURATION ===
FIREBASE_HOST = "smarthealthjplevtr-default-rtdb.firebaseio.com"
FIREBASE_AUTH = "eAfRMU6wFdMJ9TYrEL2km6hhASVSsBwMlEH3vMP0"
BASE_DATA_PATH = "/SensorData"
COMMAND_PATH = "/command"
Current_Time = "/Time"
Message = "/Message"          # Firebase path for dynamic message
UID_PATH = "/UID"
WIFI_SSID = "TAMU_IoT"
DEVICE_MAC = "24EC4A319B0C"

# I2C addresses
BMA250_ADDR = 0x18
MAX30101_ADDR = 0x57

# BMA250 registers
REG_RANGE = 0x0F
REG_BANDWIDTH = 0x10
REG_DATA_START = 0x02

# MAX30101 registers
REG_FIFO_WR_PTR = 0x04
REG_FIFO_RD_PTR = 0x06
REG_FIFO_DATA = 0x07

# === 30 Hz SYSTEM ===
SAMPLES_PER_BATCH = 30
SAMPLE_INTERVAL = 1.0 / 30
CHECK_INTERVAL = 2
TIME_CHECK_INTERVAL = 60

# Global state
batch_index = 0
logging_active = True
last_sample_time = 0
last_check_time = 0
last_time_check_time = 0
current_uid = "Jim"
current_time_value = "N/A"
current_message_value = "N/A"   # This is now correctly used everywhere
bpm = 0
spo2 = 0.0
session = None

# I2C @ 400 kHz
i2c = busio.I2C(board.SCL, board.SDA, frequency=400000)

# Scan I2C bus
print("Scanning I2C bus...")
i2c.try_lock()
addresses = i2c.scan()
print("I2C addresses found:", [hex(a) for a in addresses])
i2c.unlock()

if BMA250_ADDR not in addresses:
    print(f"BMA250 not found at 0x{BMA250_ADDR:x}. If 0x19 is shown, change BMA250_ADDR to 0x19.")
if MAX30101_ADDR not in addresses:
    print(f"MAX30101 not found at 0x{MAX30101_ADDR:x}. Check connections.")

bma250 = I2CDevice(i2c, BMA250_ADDR)
max30101 = I2CDevice(i2c, MAX30101_ADDR)

# Calculation constants
SAMPLE_FREQ = 30
MA_SIZE = 6
BUFFER_SIZE = 120
MIN_FINGER_LEVEL = 5000
MIN_DIST = 12

# ====== Helpers ======
def _int_mean(seq):
    n = len(seq)
    if n == 0:
        return 0
    s = 0
    for v in seq:
        s += v
    return s // n

def _clamp(v, lo, hi):
    return lo if v < lo else (hi if v > hi else v)

def _moving_average_inplace(x, window):
    n = len(x)
    if window <= 0 or n == 0 or n < window:
        return
    run_sum = 0
    for i in range(window):
        run_sum += x[i]
    limit = n - window
    original = x[:]
    for i in range(limit):
        avg = run_sum // window
        x[i] = avg
        if i + window < n:
            run_sum += original[i + window] - original[i]

# ====== Peak detection ======
def find_peaks(x, size, min_height, min_dist, max_num):
    locs, n = find_peaks_above_min_height(x, size, min_height, max_num)
    locs, n = remove_close_peaks(n, locs, x, min_dist)
    if n > max_num:
        locs = locs[:max_num]; n = max_num
    return locs, n

def find_peaks_above_min_height(x, size, min_height, max_num):
    i = 0
    n_peaks = 0
    locs = []
    while i < size - 1:
        cur = x[i]
        prev = x[i - 1] if i > 0 else cur
        if cur > min_height and cur > prev:
            n_width = 1
            while (i + n_width) < (size - 1) and x[i] == x[i + n_width]:
                n_width += 1
            if x[i] > x[i + n_width] and n_peaks < max_num:
                locs.append(i)
                n_peaks += 1
                i += n_width + 1
            else:
                i += n_width
        else:
            i += 1
    return locs, n_peaks

def remove_close_peaks(n_peaks, locs, x, min_dist):
    if n_peaks <= 1:
        return locs, n_peaks
    sorted_by_amp = sorted(locs, key=lambda idx: x[idx], reverse=True)
    kept = []
    for idx in sorted_by_amp:
        far = True
        for k in kept:
            if abs(idx - k) < min_dist:
                far = False; break
        if far:
            kept.append(idx)
        if len(kept) >= n_peaks:
            break
    kept.sort()
    return kept, len(kept)

# ====== HR/SpO2 calculation ======
def calc_hr_and_spo2(ir_data, red_data):
    if (not ir_data) or (not red_data) or (len(ir_data) != len(red_data)):
        return -999, False, -999, False
    size = BUFFER_SIZE if BUFFER_SIZE <= len(ir_data) else len(ir_data)
    ir_mean = _int_mean(ir_data[:size])
    x = [-(ir_data[i] - ir_mean) for i in range(size)]
    _moving_average_inplace(x, MA_SIZE)
    n_th = _clamp(_int_mean(x), 5, 20)
    ir_valley_locs, n_peaks = find_peaks(x, size, n_th, min_dist=MIN_DIST, max_num=15)
    print(f"Detected {n_peaks} peaks with threshold {n_th}")

    if n_peaks >= 2:
        peak_interval_sum = 0
        for i in range(1, n_peaks):
            peak_interval_sum += (ir_valley_locs[i] - ir_valley_locs[i - 1])
        peak_interval = peak_interval_sum // (n_peaks - 1)
        if peak_interval <= 0:
            hr = -999; hr_valid = False
        else:
            hr = int(SAMPLE_FREQ * 60 // peak_interval)
            hr_valid = True
    else:
        hr = -999; hr_valid = False

    ratios = []
    for k in range(n_peaks - 1):
        left = ir_valley_locs[k]
        right = ir_valley_locs[k + 1]
        if right - left <= 3:
            continue
        red_dc_max = ir_dc_max = -16777216
        red_dc_idx = ir_dc_idx = left
        for i in range(left, right):
            v_ir = ir_data[i]
            v_red = red_data[i]
            if v_ir > ir_dc_max:
                ir_dc_max = v_ir; ir_dc_idx = i
            if v_red > red_dc_max:
                red_dc_max = v_red; red_dc_idx = i
        span = right - left
        red_base = red_data[left] + ((red_data[right] - red_data[left]) * (red_dc_idx - left)) // span
        ir_base = ir_data[left] + ((ir_data[right] - ir_data[left]) * (ir_dc_idx - left)) // span
        red_ac = red_data[red_dc_idx] - red_base
        ir_ac = ir_data[ir_dc_idx] - ir_base
        denom = ir_ac * red_dc_max
        nume = red_ac * ir_dc_max
        if denom > 0 and nume != 0 and len(ratios) < 5:
            ratios.append(((nume * 100) & 0xFFFFFFFF) // denom)
    ratio_ave = 0
    if len(ratios) > 0:
        ratios.sort()
        mid = len(ratios) // 2
        if len(ratios) >= 2 and (len(ratios) % 2 == 0):
            ratio_ave = (ratios[mid - 1] + ratios[mid]) // 2
        else:
            ratio_ave = ratios[mid]
    if 2 < ratio_ave < 184:
        r = float(ratio_ave)
        spo2 = (-45.060 * (r * r) / 10000.0) + (30.054 * r / 100.0) + 94.845
        spo2_valid = True
    else:
        spo2 = -999; spo2_valid = False
    return hr, hr_valid, spo2, spo2_valid

# ====== Ring buffer ======
class RingBuffer:
    def __init__(self, size):
        self.buf = [0] * size
        self.size = size
        self.idx = 0
        self.count = 0
    def append(self, value):
        self.buf[self.idx] = value
        self.idx += 1
        if self.idx >= self.size:
            self.idx = 0
        if self.count < self.size:
            self.count += 1
    def full(self):
        return self.count >= self.size
    def to_list(self):
        if self.count < self.size:
            return self.buf[:self.count]
        out = [0] * self.size
        start = self.idx
        for j in range(self.size):
            pos = start + j
            if pos >= self.size:
                pos -= self.size
            out[j] = self.buf[pos]
        return out
    def mean(self):
        if self.count == 0:
            return 0
        return sum(self.buf[:self.count] if self.count < self.size else self.buf) // self.count

red_buf = RingBuffer(BUFFER_SIZE)
ir_buf = RingBuffer(BUFFER_SIZE)
bpms = RingBuffer(4)
x_batch = []
y_batch = []
z_batch = []

# === I2C HELPERS ===
def write_reg(device, reg, value):
    with device as i2c_dev:
        i2c_dev.write(bytes([reg, value]))

def read_regs(device, reg, nbytes):
    result = bytearray(nbytes)
    with device as i2c_dev:
        i2c_dev.write_then_readinto(bytes([reg]), result)
    return result

# === SENSOR INIT ===
def init_sensors():
    print("Initializing sensors...")
    try:
        write_reg(bma250, REG_RANGE, 0x03)
        write_reg(bma250, REG_BANDWIDTH, 0x0C)
        write_reg(max30101, 0x09, 0x40)
        time.sleep(0.1)
        write_reg(max30101, 0x09, 0x03)
        write_reg(max30101, 0x0A, 0x2B)
        write_reg(max30101, 0x0C, 0x24)
        write_reg(max30101, 0x0D, 0x24)
        write_reg(max30101, 0x08, 0x50)
        time.sleep(0.5)
        for _ in range(32):
            read_regs(max30101, 0x07, 6)
        print("Sensors initialized")
    except Exception as e:
        print(f"Sensor init failed: {e}")
        raise

# === WIFI & FIREBASE ===
def connect_wifi():
    print(f"Connecting to {WIFI_SSID}...")
    try:
        wifi.radio.connect(WIFI_SSID)
        print(f"Connected! IP: {wifi.radio.ipv4_address}")
    except Exception as e:
        print(f"WiFi failed: {e}")
        time.sleep(5)
        raise SystemExit

def get_url(path):
    try:
        response = session.get(f"https://{FIREBASE_HOST}{path}?auth={FIREBASE_AUTH}")
        if response.status_code == 200:
            return response.json()
        else:
            print(f"GET failed: {response.text}")
            return None
    except Exception as e:
        print(f"GET error: {e}")
        return None

def put_url(path, value):
    try:
        response = session.put(
            f"https://{FIREBASE_HOST}{path}?auth={FIREBASE_AUTH}",
            json=value
        )
        return response.status_code == 200
    except Exception as e:
        print(f"PUT error: {e}")
        return False

def firebase_init():
    global session, current_uid, current_time_value, current_message_value
    pool = socketpool.SocketPool(wifi.radio)
    session = adafruit_requests.Session(pool, ssl.create_default_context())
    print("Firebase init...")
    try:
        put_url(f"{COMMAND_PATH}.json", "idle")
        uid = get_url(f"{UID_PATH}.json")
        if uid and uid != current_uid:
            current_uid = uid
            print(f"UID set: {current_uid}")
        else:
            put_url(f"{UID_PATH}.json", current_uid)

        time_data = get_url(f"{Current_Time}.json")
        if time_data is not None:
            current_time_value = time_data

        msg_data = get_url(f"{Message}.json")
        if msg_data is not None:
            current_message_value = str(msg_data)
        else:
            current_message_value = "N/A"
            put_url(f"{Message}.json", "N/A")

        update_display_values(current_time_value, bpm, spo2, current_message_value)
    except Exception as e:
        print(f"Firebase init failed: {e}")

def set_uid(new_uid):
    global current_uid
    if new_uid and new_uid != current_uid:
        current_uid = new_uid
        print(f"UID updated: {current_uid}")
        put_url(f"{UID_PATH}.json", current_uid)

def check_firebase_commands():
    global last_check_time, logging_active, current_time_value, last_time_check_time, current_message_value
    now = time.monotonic()
    if now - last_check_time < CHECK_INTERVAL:
        return
    last_check_time = now

    try:
        uid = get_url(f"{UID_PATH}.json")
        if uid and uid != current_uid:
            set_uid(uid)

        cmd = get_url(f"{COMMAND_PATH}.json")
        if cmd and cmd not in ["idle", "logging", "connection lost, finding pulse"]:
            print(f"Command: {cmd}")
            if cmd == "start":
                start_logging()
                put_url(f"{COMMAND_PATH}.json", "logging")
            elif cmd == "stop":
                stop_logging()
                put_url(f"{COMMAND_PATH}.json", "idle")
            elif cmd == "clear":
                clear_old_rows()
                put_url(f"{COMMAND_PATH}.json", "idle")
            elif cmd == "get_log":
                upload_last_batch()
                put_url(f"{COMMAND_PATH}.json", "idle")
            else:
                put_url(f"{COMMAND_PATH}.json", "idle")

        if now - last_time_check_time >= TIME_CHECK_INTERVAL:
            t = get_url(f"{Current_Time}.json")
            if t is not None:
                current_time_value = t
            last_time_check_time = now

        # Live message update (checked every 2 sec)
        msg = get_url(f"{Message}.json")
        if msg is not None and str(msg) != current_message_value:
            current_message_value = str(msg)
            update_display_values(current_time_value, bpm, spo2, current_message_value)

    except Exception as e:
        print(f"Command check error: {e}")

# === SENSOR READING ===
def read_max30101():
    try:
        wr_ptr = read_regs(max30101, REG_FIFO_WR_PTR, 1)[0]
        rd_ptr = read_regs(max30101, REG_FIFO_RD_PTR, 1)[0]
        num_samples = (wr_ptr - rd_ptr) & 0x1F
        red_sum = ir_sum = 0
        for _ in range(num_samples):
            fifo = read_regs(max30101, REG_FIFO_DATA, 6)
            red = (fifo[0] << 16 | fifo[1] << 8 | fifo[2]) & 0x03FFFF
            ir = (fifo[3] << 16 | fifo[4] << 8 | fifo[5]) & 0x03FFFF
            red_sum += red
            ir_sum += ir
        if num_samples > 0:
            return red_sum // num_samples, ir_sum // num_samples
        return None, None
    except Exception as e:
        print(f"MAX30101 error: {e}")
        return None, None

def read_sensors():
    try:
        data = read_regs(bma250, REG_DATA_START, 6)
        x = ((data[1] << 8) | (data[0] & 0xC0)) >> 6
        if x > 511: x -= 1024
        y = ((data[3] << 8) | (data[2] & 0xC0)) >> 6
        if y > 511: y -= 1024
        z = ((data[5] << 8) | (data[4] & 0xC0)) >> 6
        if z > 511: z -= 1024
        red, ir = read_max30101()
        return red, ir, x, y, z
    except Exception as e:
        print(f"Sensor read error: {e}")
        return None, None, None, None, None

def sample_data():
    global last_sample_time, batch_index
    now = time.monotonic()
    if now - last_sample_time < SAMPLE_INTERVAL:
        return None
    last_sample_time = now

    red, ir, x, y, z = read_sensors()
    if red is None:
        return None

    red_buf.append(red)
    ir_buf.append(ir)
    x_batch.append(x)
    y_batch.append(y)
    z_batch.append(z)
    batch_index += 1

    # When we reach a full batch (30 samples), process it
    if batch_index >= SAMPLES_PER_BATCH:
        activity = transmit_data()  # returns "standing" or "walking"
        x_batch.clear()
        y_batch.clear()
        z_batch.clear()
        batch_index = 0
        return activity  # <-- THIS IS THE IMPORTANT PART

    return None


def update_vitals():
    global bpm, spo2
    if red_buf.count < BUFFER_SIZE:
        return
    ir_data = ir_buf.to_list()
    red_data = red_buf.to_list()
    hr, valid_hr, sp, valid_sp = calc_hr_and_spo2(ir_data, red_data)
    if valid_hr:
        bpms.append(hr)
        bpm_temp = bpms.mean() - 7
        if ir_buf.mean() < MIN_FINGER_LEVEL and red_buf.mean() < MIN_FINGER_LEVEL:
            bpm = 0
            spo2 = 0.0
        else:
            bpm = max(0, bpm_temp)
            if valid_sp:
                spo2 = round(sp, 1)
                if bpm < 70:
                    spo2 = max(spo2, 95.0)
            else:
                spo2 = 0.0
    else:
        bpm = 0
        spo2 = 0.0

def transmit_data():
    global bpm, spo2
    if not current_uid:
        return
    update_vitals()

    avg_x = _int_mean(x_batch) if x_batch else 0
    avg_y = _int_mean(y_batch) if y_batch else 0
    avg_z = _int_mean(z_batch) if z_batch else 0

    mags = [math.sqrt(x**2 + y**2 + z**2) for x, y, z in zip(x_batch, y_batch, z_batch)]
    if mags:
        avg_mag = sum(mags) / len(mags)
        var = sum((m - avg_mag)**2 for m in mags) / len(mags)
        std = math.sqrt(var)
        if std < 50:
            activity = "standing"
        else:
            activity = "walking"
    else:
        activity = "standing"  # Default to standing if no data

    data = {
        "BPM": bpm,
        "SPO2": spo2,
        "X": avg_x,
        "Y": avg_y,
        "Z": avg_z,
        "Activity": activity
    }
    path = f"{BASE_DATA_PATH}/{current_uid}.json"
    put_url(path, data)

    if logging_active:
        put_url(f"{COMMAND_PATH}.json", "logging" if (bpm > 0 and spo2 > 0) else "connection lost, finding pulse")

    update_display_values(current_time_value, bpm, spo2, current_message_value)

    return activity  # Return activity for use in main loop

def upload_last_batch():
    transmit_data()

def start_logging():
    global logging_active, batch_index, last_sample_time, red_buf, ir_buf, bpms
    logging_active = True
    batch_index = 0
    last_sample_time = 0
    x_batch.clear()
    y_batch.clear()
    z_batch.clear()
    red_buf = RingBuffer(BUFFER_SIZE)
    ir_buf = RingBuffer(BUFFER_SIZE)
    bpms = RingBuffer(4)
    print("Logging STARTED")

def stop_logging():
    global logging_active
    logging_active = False
    transmit_data()
    print("Logging STOPPED")

def clear_old_rows():
    print("Clear command received")

# === DISPLAY ===
display = board.DISPLAY
standing_bitmap = displayio.OnDiskBitmap("/images/Standing.bmp")
heart_standing_bitmap = displayio.OnDiskBitmap("/images/HeartStanding.bmp")
walking_bitmap = displayio.OnDiskBitmap("/images/Walking.bmp")
heart_walking_bitmap = displayio.OnDiskBitmap("/images/HeartWalking.bmp")

standing_tile_grid = displayio.TileGrid(standing_bitmap, pixel_shader=standing_bitmap.pixel_shader)
heart_standing_tile_grid = displayio.TileGrid(heart_standing_bitmap, pixel_shader=heart_standing_bitmap.pixel_shader)
walking_tile_grid = displayio.TileGrid(walking_bitmap, pixel_shader=walking_bitmap.pixel_shader)
heart_walking_tile_grid = displayio.TileGrid(heart_walking_bitmap, pixel_shader=heart_walking_bitmap.pixel_shader)

group = displayio.Group()
group.append(standing_tile_grid)  # Start with standing

sensor_labels = []
label_positions = [
    (display.width // 2, 60),
    (display.width // 4, 120),
    (display.width * 3 // 4 - 20, 120), #Moved to the perfect position
    (display.width // 7, 9)
]

for i, pos in enumerate(label_positions):
    if i == 0:
        label = bitmap_label.Label(terminalio.FONT, scale=4, text="", color=0x89CFF0)
        label.anchor_point = (0.5, 0.5)
    elif i == 3:
        label = bitmap_label.Label(terminalio.FONT, scale=2, text="", color=0x89CFF0)
        label.anchor_point = (0.0, 0.0)
    else:
        label = bitmap_label.Label(terminalio.FONT, scale=2, text="", color=0x89CFF0)
        label.anchor_point = (0.5, 0.5)
    label.anchored_position = pos
    sensor_labels.append(label)

main_group = displayio.Group()
main_group.append(group)
for label in sensor_labels:
    main_group.append(label)
display.root_group = main_group

current_background = "standing"
current_activity = "standing"

def set_background(activity, to_heart):
    global current_background
    new_bg = f"{'heart_' if to_heart else ''}{activity}"
    if new_bg != current_background:
        if new_bg == "standing":
            group[0] = standing_tile_grid
        elif new_bg == "heart_standing":
            group[0] = heart_standing_tile_grid
        elif new_bg == "walking":
            group[0] = walking_tile_grid
        elif new_bg == "heart_walking":
            group[0] = heart_walking_tile_grid
        current_background = new_bg

def update_display_values(time_str, bpm_val, spo2_val, message_str):
    sensor_labels[0].text = f"{time_str}"
    sensor_labels[1].text = f"{int(bpm_val)}" if bpm_val > 0 else "--"
    sensor_labels[2].text = f"{spo2_val:.1f}%" if spo2_val > 0 else "--"
    sensor_labels[3].text = f"{message_str}"



# === HELPER FUNCTION ===
def update_background(activity, show_heart):
    """
    Chooses the correct background image based on activity and
    whether the heartbeat is currently showing.
    Updates group[0] ONLY if the image changed.
    """
    if activity == "walking":
        target_grid = heart_walking_tile_grid if show_heart else walking_tile_grid
    else:
        target_grid = heart_standing_tile_grid if show_heart else standing_tile_grid

    # Swap ONLY if changed
    if group[0] != target_grid:
        group[0] = target_grid



# === MAIN LOOP ===
connect_wifi()
init_sensors()
update_display_values("N/A", 0, 0.0, "N/A")
firebase_init()
put_url(f"{COMMAND_PATH}.json", "idle")
print("Ready @ 30 Hz.")

is_showing_heart = False
last_pulse_time = time.monotonic()
pulse_duration = 0.20
last_frame_update = 0
activity = "standing"

while True:
    now = time.monotonic()
    check_firebase_commands()

    if logging_active:
        new_activity = sample_data()   # FIX 1

    # Only update if we actually got a new activity
    if new_activity is not None:
        activity = new_activity        # FIX 2


    # Calculate BPM timing
    if bpm > 0:
        beat_interval = 60.0 / bpm
        # Logic to toggle the heart on and off based on time
        if is_showing_heart:
            if now - last_pulse_time >= pulse_duration:
                is_showing_heart = False # Turn heart off
        else:
            if now - last_pulse_time >= beat_interval:
                is_showing_heart = True # Turn heart on
                last_pulse_time = now
    else:
        # If no BPM, never show heart
        is_showing_heart = False

    # Update Display (This calls our new safe function)
    update_background(activity, is_showing_heart)

    time.sleep(0.001)
