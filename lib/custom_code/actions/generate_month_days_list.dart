// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
Future<void> generateMonthDaysList() async {
  final DateTime now = DateTime.now();
  final int currentYear = now.year;
  final int currentMonth = now.month;

  // Compute how many days are in this month
  // Trick: create the first day of next month, subtract one day
  final DateTime firstDayNextMonth = (currentMonth == 12)
      ? DateTime(currentYear + 1, 1, 1)
      : DateTime(currentYear, currentMonth + 1, 1);
  final int daysInMonth =
      firstDayNextMonth.subtract(const Duration(days: 1)).day;

  // Create a list [1, 2, 3, ..., daysInMonth]
  final List<int> monthDays = List<int>.generate(daysInMonth, (i) => i + 1);

  // Store in your FlutterFlow AppState variable
  FFAppState().monthDays = monthDays;

  // Optional: trigger reactive rebuild
  // FFAppState().update(() {});
}
