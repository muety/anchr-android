import 'package:anchr_android/resources/strings.dart';
import 'package:f_logs/f_logs.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';

class LogsPage extends StatelessWidget {
  static const String routeName = '/logs';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: formatLogs(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        return Scaffold(
            appBar: AppBar(
              title: const Text(Strings.titleLogsPage),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: const Text(Strings.msgCopyLogs),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(
                            snapshot.hasData ? snapshot.data : "",
                            autofocus: true,
                            style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12.0
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(color: Color(0xffe6e6e6)),
                      ),
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }

  Future<String> formatLogs() async {
    LogsConfig config = FLog.getDefaultConfigurations();
    List<Log> logs = await FLog.getAllLogs();
    return Stream.fromIterable(logs.reversed).map((l) => Formatter.format(l, config)).join("\n");
  }
}
