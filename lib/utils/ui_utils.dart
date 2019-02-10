import 'package:flutter/material.dart';

class UIUtils {
  /**
   * Show a notification. Requires a Scaffold to be present.
   * You must either pass a ScaffoldState directly or alternatively a context, in which a Scaffold widget is available.
   * Will do nothing if no Scaffold can be found.
   */
  static void showSnackbar(String text, {BuildContext context, ScaffoldState scaffoldState}) {
    scaffoldState = scaffoldState ?? context.ancestorStateOfType(TypeMatcher<ScaffoldState>());
    if (scaffoldState != null) {
      scaffoldState.showSnackBar(SnackBar(content: Text(text)));
    }
  }
}