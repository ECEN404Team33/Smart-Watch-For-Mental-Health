import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SensorDataRecord extends FirestoreRecord {
  SensorDataRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uid" field.
  DocumentReference? _uid;
  DocumentReference? get uid => _uid;
  bool hasUid() => _uid != null;

  // "Test" field.
  bool? _test;
  bool get test => _test ?? false;
  bool hasTest() => _test != null;

  // "StepsMonth" field.
  List<int>? _stepsMonth;
  List<int> get stepsMonth => _stepsMonth ?? const [];
  bool hasStepsMonth() => _stepsMonth != null;

  // "HRV1" field.
  List<int>? _hrv1;
  List<int> get hrv1 => _hrv1 ?? const [];
  bool hasHrv1() => _hrv1 != null;

  // "HRV2" field.
  List<int>? _hrv2;
  List<int> get hrv2 => _hrv2 ?? const [];
  bool hasHrv2() => _hrv2 != null;

  // "HRV3" field.
  List<int>? _hrv3;
  List<int> get hrv3 => _hrv3 ?? const [];
  bool hasHrv3() => _hrv3 != null;

  // "HRV4" field.
  List<int>? _hrv4;
  List<int> get hrv4 => _hrv4 ?? const [];
  bool hasHrv4() => _hrv4 != null;

  // "HRV5" field.
  List<int>? _hrv5;
  List<int> get hrv5 => _hrv5 ?? const [];
  bool hasHrv5() => _hrv5 != null;

  // "HRV6" field.
  List<int>? _hrv6;
  List<int> get hrv6 => _hrv6 ?? const [];
  bool hasHrv6() => _hrv6 != null;

  // "HRV7" field.
  List<int>? _hrv7;
  List<int> get hrv7 => _hrv7 ?? const [];
  bool hasHrv7() => _hrv7 != null;

  // "HRV8" field.
  List<int>? _hrv8;
  List<int> get hrv8 => _hrv8 ?? const [];
  bool hasHrv8() => _hrv8 != null;

  // "HRV9" field.
  List<int>? _hrv9;
  List<int> get hrv9 => _hrv9 ?? const [];
  bool hasHrv9() => _hrv9 != null;

  // "HRV10" field.
  List<int>? _hrv10;
  List<int> get hrv10 => _hrv10 ?? const [];
  bool hasHrv10() => _hrv10 != null;

  // "HeartRate1" field.
  List<int>? _heartRate1;
  List<int> get heartRate1 => _heartRate1 ?? const [];
  bool hasHeartRate1() => _heartRate1 != null;

  // "HeartRate2" field.
  List<int>? _heartRate2;
  List<int> get heartRate2 => _heartRate2 ?? const [];
  bool hasHeartRate2() => _heartRate2 != null;

  // "HeartRate3" field.
  List<int>? _heartRate3;
  List<int> get heartRate3 => _heartRate3 ?? const [];
  bool hasHeartRate3() => _heartRate3 != null;

  // "HeartRate4" field.
  List<int>? _heartRate4;
  List<int> get heartRate4 => _heartRate4 ?? const [];
  bool hasHeartRate4() => _heartRate4 != null;

  // "HeartRate5" field.
  List<int>? _heartRate5;
  List<int> get heartRate5 => _heartRate5 ?? const [];
  bool hasHeartRate5() => _heartRate5 != null;

  // "HeartRate6" field.
  List<int>? _heartRate6;
  List<int> get heartRate6 => _heartRate6 ?? const [];
  bool hasHeartRate6() => _heartRate6 != null;

  // "HeartRate7" field.
  List<int>? _heartRate7;
  List<int> get heartRate7 => _heartRate7 ?? const [];
  bool hasHeartRate7() => _heartRate7 != null;

  // "HeartRate8" field.
  List<int>? _heartRate8;
  List<int> get heartRate8 => _heartRate8 ?? const [];
  bool hasHeartRate8() => _heartRate8 != null;

  // "HeartRate9" field.
  List<int>? _heartRate9;
  List<int> get heartRate9 => _heartRate9 ?? const [];
  bool hasHeartRate9() => _heartRate9 != null;

  // "HeartRate10" field.
  List<int>? _heartRate10;
  List<int> get heartRate10 => _heartRate10 ?? const [];
  bool hasHeartRate10() => _heartRate10 != null;

  // "Time1" field.
  List<int>? _time1;
  List<int> get time1 => _time1 ?? const [];
  bool hasTime1() => _time1 != null;

  // "Time2" field.
  List<int>? _time2;
  List<int> get time2 => _time2 ?? const [];
  bool hasTime2() => _time2 != null;

  // "Time3" field.
  List<int>? _time3;
  List<int> get time3 => _time3 ?? const [];
  bool hasTime3() => _time3 != null;

  // "Time4" field.
  List<int>? _time4;
  List<int> get time4 => _time4 ?? const [];
  bool hasTime4() => _time4 != null;

  // "Time5" field.
  List<int>? _time5;
  List<int> get time5 => _time5 ?? const [];
  bool hasTime5() => _time5 != null;

  // "Time6" field.
  List<int>? _time6;
  List<int> get time6 => _time6 ?? const [];
  bool hasTime6() => _time6 != null;

  // "Time7" field.
  List<int>? _time7;
  List<int> get time7 => _time7 ?? const [];
  bool hasTime7() => _time7 != null;

  // "Time8" field.
  List<int>? _time8;
  List<int> get time8 => _time8 ?? const [];
  bool hasTime8() => _time8 != null;

  // "Time9" field.
  List<int>? _time9;
  List<int> get time9 => _time9 ?? const [];
  bool hasTime9() => _time9 != null;

  // "Time10" field.
  List<int>? _time10;
  List<int> get time10 => _time10 ?? const [];
  bool hasTime10() => _time10 != null;

  // "Stress" field.
  List<String>? _stress;
  List<String> get stress => _stress ?? const [];
  bool hasStress() => _stress != null;

  // "PeakHeartrate" field.
  List<String>? _peakHeartrate;
  List<String> get peakHeartrate => _peakHeartrate ?? const [];
  bool hasPeakHeartrate() => _peakHeartrate != null;

  // "CurrentHeartRate" field.
  String? _currentHeartRate;
  String get currentHeartRate => _currentHeartRate ?? '';
  bool hasCurrentHeartRate() => _currentHeartRate != null;

  // "ML" field.
  int? _ml;
  int get ml => _ml ?? 0;
  bool hasMl() => _ml != null;

  // "SPO2" field.
  String? _spo2;
  String get spo2 => _spo2 ?? '';
  bool hasSpo2() => _spo2 != null;

  // "Movement" field.
  String? _movement;
  String get movement => _movement ?? '';
  bool hasMovement() => _movement != null;

  // "TimeMoving" field.
  String? _timeMoving;
  String get timeMoving => _timeMoving ?? '';
  bool hasTimeMoving() => _timeMoving != null;

  void _initializeFields() {
    _uid = snapshotData['uid'] as DocumentReference?;
    _test = snapshotData['Test'] as bool?;
    _stepsMonth = getDataList(snapshotData['StepsMonth']);
    _hrv1 = getDataList(snapshotData['HRV1']);
    _hrv2 = getDataList(snapshotData['HRV2']);
    _hrv3 = getDataList(snapshotData['HRV3']);
    _hrv4 = getDataList(snapshotData['HRV4']);
    _hrv5 = getDataList(snapshotData['HRV5']);
    _hrv6 = getDataList(snapshotData['HRV6']);
    _hrv7 = getDataList(snapshotData['HRV7']);
    _hrv8 = getDataList(snapshotData['HRV8']);
    _hrv9 = getDataList(snapshotData['HRV9']);
    _hrv10 = getDataList(snapshotData['HRV10']);
    _heartRate1 = getDataList(snapshotData['HeartRate1']);
    _heartRate2 = getDataList(snapshotData['HeartRate2']);
    _heartRate3 = getDataList(snapshotData['HeartRate3']);
    _heartRate4 = getDataList(snapshotData['HeartRate4']);
    _heartRate5 = getDataList(snapshotData['HeartRate5']);
    _heartRate6 = getDataList(snapshotData['HeartRate6']);
    _heartRate7 = getDataList(snapshotData['HeartRate7']);
    _heartRate8 = getDataList(snapshotData['HeartRate8']);
    _heartRate9 = getDataList(snapshotData['HeartRate9']);
    _heartRate10 = getDataList(snapshotData['HeartRate10']);
    _time1 = getDataList(snapshotData['Time1']);
    _time2 = getDataList(snapshotData['Time2']);
    _time3 = getDataList(snapshotData['Time3']);
    _time4 = getDataList(snapshotData['Time4']);
    _time5 = getDataList(snapshotData['Time5']);
    _time6 = getDataList(snapshotData['Time6']);
    _time7 = getDataList(snapshotData['Time7']);
    _time8 = getDataList(snapshotData['Time8']);
    _time9 = getDataList(snapshotData['Time9']);
    _time10 = getDataList(snapshotData['Time10']);
    _stress = getDataList(snapshotData['Stress']);
    _peakHeartrate = getDataList(snapshotData['PeakHeartrate']);
    _currentHeartRate = snapshotData['CurrentHeartRate'] as String?;
    _ml = castToType<int>(snapshotData['ML']);
    _spo2 = snapshotData['SPO2'] as String?;
    _movement = snapshotData['Movement'] as String?;
    _timeMoving = snapshotData['TimeMoving'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('SensorData');

  static Stream<SensorDataRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SensorDataRecord.fromSnapshot(s));

  static Future<SensorDataRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SensorDataRecord.fromSnapshot(s));

  static SensorDataRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SensorDataRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SensorDataRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SensorDataRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SensorDataRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SensorDataRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSensorDataRecordData({
  DocumentReference? uid,
  bool? test,
  String? currentHeartRate,
  int? ml,
  String? spo2,
  String? movement,
  String? timeMoving,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'Test': test,
      'CurrentHeartRate': currentHeartRate,
      'ML': ml,
      'SPO2': spo2,
      'Movement': movement,
      'TimeMoving': timeMoving,
    }.withoutNulls,
  );

  return firestoreData;
}

class SensorDataRecordDocumentEquality implements Equality<SensorDataRecord> {
  const SensorDataRecordDocumentEquality();

  @override
  bool equals(SensorDataRecord? e1, SensorDataRecord? e2) {
    const listEquality = ListEquality();
    return e1?.uid == e2?.uid &&
        e1?.test == e2?.test &&
        listEquality.equals(e1?.stepsMonth, e2?.stepsMonth) &&
        listEquality.equals(e1?.hrv1, e2?.hrv1) &&
        listEquality.equals(e1?.hrv2, e2?.hrv2) &&
        listEquality.equals(e1?.hrv3, e2?.hrv3) &&
        listEquality.equals(e1?.hrv4, e2?.hrv4) &&
        listEquality.equals(e1?.hrv5, e2?.hrv5) &&
        listEquality.equals(e1?.hrv6, e2?.hrv6) &&
        listEquality.equals(e1?.hrv7, e2?.hrv7) &&
        listEquality.equals(e1?.hrv8, e2?.hrv8) &&
        listEquality.equals(e1?.hrv9, e2?.hrv9) &&
        listEquality.equals(e1?.hrv10, e2?.hrv10) &&
        listEquality.equals(e1?.heartRate1, e2?.heartRate1) &&
        listEquality.equals(e1?.heartRate2, e2?.heartRate2) &&
        listEquality.equals(e1?.heartRate3, e2?.heartRate3) &&
        listEquality.equals(e1?.heartRate4, e2?.heartRate4) &&
        listEquality.equals(e1?.heartRate5, e2?.heartRate5) &&
        listEquality.equals(e1?.heartRate6, e2?.heartRate6) &&
        listEquality.equals(e1?.heartRate7, e2?.heartRate7) &&
        listEquality.equals(e1?.heartRate8, e2?.heartRate8) &&
        listEquality.equals(e1?.heartRate9, e2?.heartRate9) &&
        listEquality.equals(e1?.heartRate10, e2?.heartRate10) &&
        listEquality.equals(e1?.time1, e2?.time1) &&
        listEquality.equals(e1?.time2, e2?.time2) &&
        listEquality.equals(e1?.time3, e2?.time3) &&
        listEquality.equals(e1?.time4, e2?.time4) &&
        listEquality.equals(e1?.time5, e2?.time5) &&
        listEquality.equals(e1?.time6, e2?.time6) &&
        listEquality.equals(e1?.time7, e2?.time7) &&
        listEquality.equals(e1?.time8, e2?.time8) &&
        listEquality.equals(e1?.time9, e2?.time9) &&
        listEquality.equals(e1?.time10, e2?.time10) &&
        listEquality.equals(e1?.stress, e2?.stress) &&
        listEquality.equals(e1?.peakHeartrate, e2?.peakHeartrate) &&
        e1?.currentHeartRate == e2?.currentHeartRate &&
        e1?.ml == e2?.ml &&
        e1?.spo2 == e2?.spo2 &&
        e1?.movement == e2?.movement &&
        e1?.timeMoving == e2?.timeMoving;
  }

  @override
  int hash(SensorDataRecord? e) => const ListEquality().hash([
        e?.uid,
        e?.test,
        e?.stepsMonth,
        e?.hrv1,
        e?.hrv2,
        e?.hrv3,
        e?.hrv4,
        e?.hrv5,
        e?.hrv6,
        e?.hrv7,
        e?.hrv8,
        e?.hrv9,
        e?.hrv10,
        e?.heartRate1,
        e?.heartRate2,
        e?.heartRate3,
        e?.heartRate4,
        e?.heartRate5,
        e?.heartRate6,
        e?.heartRate7,
        e?.heartRate8,
        e?.heartRate9,
        e?.heartRate10,
        e?.time1,
        e?.time2,
        e?.time3,
        e?.time4,
        e?.time5,
        e?.time6,
        e?.time7,
        e?.time8,
        e?.time9,
        e?.time10,
        e?.stress,
        e?.peakHeartrate,
        e?.currentHeartRate,
        e?.ml,
        e?.spo2,
        e?.movement,
        e?.timeMoving
      ]);

  @override
  bool isValidKey(Object? o) => o is SensorDataRecord;
}
