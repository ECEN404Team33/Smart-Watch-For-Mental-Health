import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'username_widget.dart' show UsernameWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UsernameModel extends FlutterFlowModel<UsernameWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Create_Username widget.
  FocusNode? createUsernameFocusNode;
  TextEditingController? createUsernameTextController;
  String? Function(BuildContext, String?)?
      createUsernameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    createUsernameFocusNode?.dispose();
    createUsernameTextController?.dispose();
  }
}
