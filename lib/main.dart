import 'dart:async';

import 'package:anchr_android/app.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

void main() async {
  runZonedGuarded(
          () => runApp(AnchrApp()),
          (err, stackTrace) => FLog.error(text: "Root level error", exception: err, stacktrace: stackTrace)
  );
}
