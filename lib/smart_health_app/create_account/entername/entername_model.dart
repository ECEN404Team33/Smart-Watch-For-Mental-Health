import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'entername_widget.dart' show EnternameWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EnternameModel extends FlutterFlowModel<EnternameWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Firstname_Create widget.
  FocusNode? firstnameCreateFocusNode;
  TextEditingController? firstnameCreateTextController;
  String? Function(BuildContext, String?)?
      firstnameCreateTextControllerValidator;
  // State field(s) for Lastname_Create widget.
  FocusNode? lastnameCreateFocusNode;
  TextEditingController? lastnameCreateTextController;
  String? Function(BuildContext, String?)?
      lastnameCreateTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    firstnameCreateFocusNode?.dispose();
    firstnameCreateTextController?.dispose();

    lastnameCreateFocusNode?.dispose();
    lastnameCreateTextController?.dispose();
  }
}
