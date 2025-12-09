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
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> setCommand(String command, String uid) async {
  final firebaseApp = Firebase.app(); // Get the default Firebase app instance.
  final db = FirebaseDatabase.instanceFor(
    app: firebaseApp,
    databaseURL: 'https://smarthealthjplevtr-default-rtdb.firebaseio.com',
  );
  final ref = db.ref('command'); // Reference to the 'command' node.

  await ref.set(command); // Write the command value to the database.
  final UIDref = db.ref('UID');
  await UIDref.set(uid);
}
