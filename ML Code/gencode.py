import numpy as np
import pandas as pd
import random

# ================================
# PARAMETERS
# ================================
total_points = 2000
good_percentage = 0.97
anomalous_percentage = 0.03          # 3% anomalies → 60 points
anomalous_sensor1_ratio = 0.995     # 98.3% of anomalies affect Heartrate

# Calculate counts
good_count = int(total_points * good_percentage)
anomalous_count = total_points - good_count
anomalous_heartrate_count = int(anomalous_count * anomalous_sensor1_ratio)
anomalous_hrv_count = anomalous_count - anomalous_heartrate_count

# ================================
# 1. GENERATE HEALTHY HEARTRATE (BPM)
# ================================
def generate_healthy_heartrate(total_points):
    hr = np.zeros(total_points)
    state = 'resting'
    current_hr = random.uniform(60, 80)
    t = 0

    while t < total_points:
        if state == 'resting':
            duration = random.randint(200, 500)
            for _ in range(duration):
                if t >= total_points: break
                change = random.uniform(-2, 2)
                current_hr = np.clip(current_hr + change, 50, 100)
                hr[t] = round(current_hr, 2)
                t += 1
            state = random.choice(['ascending', 'slightly_elevated'])

        elif state == 'ascending':
            duration = random.randint(100, 300)
            target_hr = random.uniform(110, 128)
            step = (target_hr - current_hr) / duration
            for i in range(duration):
                if t >= total_points: break
                current_hr += step + random.uniform(-1, 1)
                current_hr = np.clip(current_hr, 100, 128)
                hr[t] = round(current_hr, 2)
                t += 1
            state = 'elevated'

        elif state == 'elevated':
            duration = random.randint(200, 400)
            for _ in range(duration):
                if t >= total_points: break
                change = random.uniform(-3, 3)
                current_hr = np.clip(current_hr + change, 110, 128)
                hr[t] = round(current_hr, 2)
                t += 1
            state = 'descending'

        elif state == 'descending':
            duration = random.randint(100, 300)
            target_hr = random.uniform(60, 80)
            step = (target_hr - current_hr) / duration
            for i in range(duration):
                if t >= total_points: break
                current_hr += step + random.uniform(-1, 1)
                current_hr = np.clip(current_hr, 60, 100)
                hr[t] = round(current_hr, 2)
                t += 1
            state = 'resting'

        elif state == 'slightly_elevated':
            duration = random.randint(150, 350)
            target_hr = random.uniform(90, 110)
            step = (target_hr - current_hr) / (duration // 2)
            for i in range(duration // 2):
                if t >= total_points: break
                current_hr += step + random.uniform(-1, 1)
                current_hr = np.clip(current_hr, 80, 110)
                hr[t] = round(current_hr, 2)
                t += 1
            for _ in range(duration // 2):
                if t >= total_points: break
                change = random.uniform(-2, 2)
                current_hr = np.clip(current_hr + change, 90, 110)
                hr[t] = round(current_hr, 2)
                t += 1
            state = 'descending'

    return hr

# ================================
# 2. GENERATE SpO₂ (HRV) – CORRELATED WITH HEARTRATE
# ================================
def generate_healthy_hrv(heartrate):
    hrv = np.zeros(len(heartrate))
    base_o2 = random.uniform(97, 98)  # Mean 97–98%
    alpha = 0.05  # EMA smoothing
    current_o2 = base_o2

    for t in range(len(heartrate)):
        # Higher HR → slight drop in SpO₂
        target_o2 = base_o2 - 0.03 * max(0, heartrate[t] - 90)
        current_o2 = alpha * target_o2 + (1 - alpha) * current_o2
        noise = random.uniform(-.2, .2)  # Std 1–2%
        hrv[t] = np.clip(current_o2 + noise, 90.0, 100.0)
        hrv[t] = round(hrv[t], 2)

    return hrv

# ================================
# 3. GENERATE DATA
# ================================
Heartrate = generate_healthy_heartrate(total_points)
HRV = generate_healthy_hrv(Heartrate)

# ================================
# 4. INJECT ANOMALIES
# ================================
anomalous_indices = random.sample(range(total_points), anomalous_count)
heartrate_anom_indices = random.sample(anomalous_indices, anomalous_heartrate_count)
hrv_anom_indices = [i for i in anomalous_indices if i not in heartrate_anom_indices]

# Anomalies in Heartrate (±10–20 BPM spike)
for idx in heartrate_anom_indices:
    prev = Heartrate[idx-1] if idx > 0 else Heartrate[idx]
    spike = random.choice([-1, 1]) * random.uniform(10, 20)
    Heartrate[idx] = np.clip(prev + spike, 40, 180)
    Heartrate[idx] = round(Heartrate[idx], 2)

# Anomalies in HRV (±1–2% drop, rare)
for idx in hrv_anom_indices:
    prev = HRV[idx-1] if idx > 0 else HRV[idx]
    drop = random.uniform(1.0, 2.0)  # Only downward for realism
    HRV[idx] = np.clip(prev - drop, 85.0, 99.0)
    HRV[idx] = round(HRV[idx], 2)

# ================================
# 5. TIME COLUMN
# ================================
times = []
for i in range(total_points):
    hours = i // 3600
    minutes = (i % 3600) // 60
    seconds = i % 60
    times.append(f"{hours:01d}:{minutes:02d}:{seconds:02d}")

# ================================
# 6. CREATE DATAFRAME & SAVE
# ================================
df = pd.DataFrame({
    'Time': times,
    'Heartrate': Heartrate,
    'HRV': HRV
})

df.to_csv('training.csv', index=False)
print(f"Generated HeartRate.csv with {total_points} points.")
print(f"   • {anomalous_count} anomalies ({anomalous_heartrate_count} in Heartrate, {anomalous_hrv_count} in HRV)")
print(f"   • Heartrate: mean ~{Heartrate.mean():.2f} BPM, std ~{Heartrate.std():.2f}")
print(f"   • HRV (SpO₂): mean ~{HRV.mean():.2f}%, std ~{HRV.std():.2f}%")