import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _DocId = '';
  String get DocId => _DocId;
  set DocId(String value) {
    _DocId = value;
  }

  String _filePath = '';
  String get filePath => _filePath;
  set filePath(String value) {
    _filePath = value;
  }

  List<String> _Dates = [];
  List<String> get Dates => _Dates;
  set Dates(List<String> value) {
    _Dates = value;
  }

  void addToDates(String value) {
    Dates.add(value);
  }

  void removeFromDates(String value) {
    Dates.remove(value);
  }

  void removeAtIndexFromDates(int index) {
    Dates.removeAt(index);
  }

  void updateDatesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    Dates[index] = updateFn(_Dates[index]);
  }

  void insertAtIndexInDates(int index, String value) {
    Dates.insert(index, value);
  }

  List<int> _monthDays = [];
  List<int> get monthDays => _monthDays;
  set monthDays(List<int> value) {
    _monthDays = value;
  }

  void addToMonthDays(int value) {
    monthDays.add(value);
  }

  void removeFromMonthDays(int value) {
    monthDays.remove(value);
  }

  void removeAtIndexFromMonthDays(int index) {
    monthDays.removeAt(index);
  }

  void updateMonthDaysAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    monthDays[index] = updateFn(_monthDays[index]);
  }

  void insertAtIndexInMonthDays(int index, int value) {
    monthDays.insert(index, value);
  }

  int _Anomaly = 0;
  int get Anomaly => _Anomaly;
  set Anomaly(int value) {
    _Anomaly = value;
  }
}
