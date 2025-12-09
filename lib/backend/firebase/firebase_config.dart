import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBoZpMV2SzvFyHlizvGtbR61Rgy8L6Lzak",
            authDomain: "smarthealthjplevtr.firebaseapp.com",
            projectId: "smarthealthjplevtr",
            storageBucket: "smarthealthjplevtr.firebasestorage.app",
            messagingSenderId: "63205640916",
            appId: "1:63205640916:web:9c8e06181842dcc2d54941",
            measurementId: "G-PT11FXN6QB"));
  } else {
    await Firebase.initializeApp();
  }
}
