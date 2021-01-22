import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class Utils {
  factory Utils._() => null;

  static launchURL(String url) async {
    if (validateUrl(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static bool validateUrl(String url) {
    Uri parsedUrl = Uri.tryParse(url);
    return parsedUrl != null && parsedUrl.scheme.isNotEmpty;
  }

  static bool validateEmail(String input) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  static String sanitizeApiUrl(String url) {
    return Uri.parse(url.trim() + '/api').toString();
  }

  static String formatResponse(Response res) {
    return "Request: ${res.request.method} ${res.request.url}; Response: ${res.statusCode}: ${res.body}";
  }

  /// Show a notification. Requires a Scaffold to be present.
  /// You must either pass a ScaffoldState directly or use it in a context where a Scaffold widget is available.
  /// Will do nothing if no Scaffold can be found.
  static void showSnackbar(String text, {BuildContext context, ScaffoldState scaffoldState}) {
    if (scaffoldState == null && context != null) {
      scaffoldState = context.findAncestorStateOfType<ScaffoldState>();
    }

    if (scaffoldState != null) {
      scaffoldState.showSnackBar(SnackBar(content: Text(text)));
    }
  }
}
