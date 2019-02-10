import 'package:anchr_android/app.dart';
import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/types.dart';
import 'package:flutter/material.dart';

class AddLinkPage extends StatelessWidget {
  static const String routeName = '/add';
  static const String title = 'Add new link';

  final AppState appState;
  final AnchrActions anchrActions;

  const AddLinkPage({Key key, this.appState, this.anchrActions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: AnchrApp.scaffoldKey,
        appBar: AppBar(
          title: Text(AddLinkPage.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[],
          ),
        ));
  }
}