import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'account_delete_validate_widget.dart' show AccountDeleteValidateWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountDeleteValidateModel
    extends FlutterFlowModel<AccountDeleteValidateWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for password_validate widget.
  FocusNode? passwordValidateFocusNode;
  TextEditingController? passwordValidateTextController;
  late bool passwordValidateVisibility;
  String? Function(BuildContext, String?)?
      passwordValidateTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  SensorDataRecord? docId;

  @override
  void initState(BuildContext context) {
    passwordValidateVisibility = false;
  }

  @override
  void dispose() {
    passwordValidateFocusNode?.dispose();
    passwordValidateTextController?.dispose();
  }
}
