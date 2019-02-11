import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class Utils {
  factory Utils._() => null;

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

mixin SnackbarSupport<T extends StatefulWidget> on State<T> {
  /**
   * Show a notification. Requires a Scaffold to be present.
   * You must either pass a ScaffoldState directly or use it in a context where a Scaffold widget is available.
   * Will do nothing if no Scaffold can be found.
   */
  void showSnackbar(String text, { ScaffoldState scaffoldState }) {
    scaffoldState = scaffoldState ?? context.ancestorStateOfType(TypeMatcher<ScaffoldState>());
    if (scaffoldState != null) {
      scaffoldState.showSnackBar(SnackBar(content: Text(text)));
    }
  }
}