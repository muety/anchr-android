import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/register';
  static const String title = 'Log in';

  const LoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LoginPage.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[],
          ),
        ));
  }
}
