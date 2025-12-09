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
import 'package:intl/intl.dart'; // FlutterFlow supports intl.

Future<void> addRecentDatesToAppState() async {
  // Get today's date
  final DateTime today = DateTime.now();

  // Formatter for "MMM d" (e.g., "Oct 16")
  final DateFormat formatter = DateFormat('MMM d');

  // Create a list of today + past 10 days
  final List<String> dateList = List.generate(
    11,
    (i) => formatter.format(today.subtract(Duration(days: i))),
  ).reversed.toList(); // chronological order (oldest → newest)

  // Update FlutterFlow AppState variable named `Dates`
  FFAppState().Dates = dateList;

  // Optional: trigger UI refresh if needed
  // FFAppState().update(() {});
}
