import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'age_widget.dart' show AgeWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AgeModel extends FlutterFlowModel<AgeWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Age_Create widget.
  FocusNode? ageCreateFocusNode;
  TextEditingController? ageCreateTextController;
  String? Function(BuildContext, String?)? ageCreateTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    ageCreateFocusNode?.dispose();
    ageCreateTextController?.dispose();
  }
}
