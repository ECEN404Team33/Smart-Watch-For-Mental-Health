import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserDataRecord extends FirestoreRecord {
  UserDataRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "user_first_name" field.
  String? _userFirstName;
  String get userFirstName => _userFirstName ?? '';
  bool hasUserFirstName() => _userFirstName != null;

  // "user_last_name" field.
  String? _userLastName;
  String get userLastName => _userLastName ?? '';
  bool hasUserLastName() => _userLastName != null;

  // "user_age" field.
  int? _userAge;
  int get userAge => _userAge ?? 0;
  bool hasUserAge() => _userAge != null;

  // "password" field.
  String? _password;
  String get password => _password ?? '';
  bool hasPassword() => _password != null;

  // "EmailAuth" field.
  bool? _emailAuth;
  bool get emailAuth => _emailAuth ?? false;
  bool hasEmailAuth() => _emailAuth != null;

  // "SensorDataDoc" field.
  DocumentReference? _sensorDataDoc;
  DocumentReference? get sensorDataDoc => _sensorDataDoc;
  bool hasSensorDataDoc() => _sensorDataDoc != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _userFirstName = snapshotData['user_first_name'] as String?;
    _userLastName = snapshotData['user_last_name'] as String?;
    _userAge = castToType<int>(snapshotData['user_age']);
    _password = snapshotData['password'] as String?;
    _emailAuth = snapshotData['EmailAuth'] as bool?;
    _sensorDataDoc = snapshotData['SensorDataDoc'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('User_Data');

  static Stream<UserDataRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserDataRecord.fromSnapshot(s));

  static Future<UserDataRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserDataRecord.fromSnapshot(s));

  static UserDataRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserDataRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserDataRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserDataRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserDataRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserDataRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserDataRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? userFirstName,
  String? userLastName,
  int? userAge,
  String? password,
  bool? emailAuth,
  DocumentReference? sensorDataDoc,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'user_first_name': userFirstName,
      'user_last_name': userLastName,
      'user_age': userAge,
      'password': password,
      'EmailAuth': emailAuth,
      'SensorDataDoc': sensorDataDoc,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserDataRecordDocumentEquality implements Equality<UserDataRecord> {
  const UserDataRecordDocumentEquality();

  @override
  bool equals(UserDataRecord? e1, UserDataRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.userFirstName == e2?.userFirstName &&
        e1?.userLastName == e2?.userLastName &&
        e1?.userAge == e2?.userAge &&
        e1?.password == e2?.password &&
        e1?.emailAuth == e2?.emailAuth &&
        e1?.sensorDataDoc == e2?.sensorDataDoc;
  }

  @override
  int hash(UserDataRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.userFirstName,
        e?.userLastName,
        e?.userAge,
        e?.password,
        e?.emailAuth,
        e?.sensorDataDoc
      ]);

  @override
  bool isValidKey(Object? o) => o is UserDataRecord;
}
