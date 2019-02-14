import 'package:anchr_android/mixins/anchr_actions.dart';
import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  static const String title = 'Log in';
  final AppState appState;

  const LoginPage(this.appState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState(appState);
}

class _LoginPageState extends AnchrState<LoginPage> with AnchrActions {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userMail;
  String userPassword;

  _LoginPageState(AppState appState) : super(appState);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(LoginPage.title),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                      key: Key('email'),
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'E.g. you@example.org',
                        labelText: 'E-Mail',
                      ),
                      onSaved: (val) => userMail = val,
                      validator: (val) => Utils.validateEmail(val) ? null : 'Not a valid e-mail address.'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                      key: Key('password'),
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.lock),
                        labelText: 'Passwort',
                      ),
                      obscureText: true,
                      onSaved: (val) => userPassword = val,
                      validator: (val) => val.isNotEmpty ? null : 'Please enter a password.'
                  ),
                ),
                Container(
                  width: screenSize.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RaisedButton(
                      child: const Text('Login', style: TextStyle(color: Colors.white)),
                      color: Theme
                          .of(context)
                          .primaryColor,
                      onPressed: _submit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      login(userMail, userPassword)
          .then((_) => Navigator.pushReplacementNamed(context, CollectionsPage.routeName))
          .catchError((e) => showSnackbar('Could not log in, sorry...'));
    }
  }

  @override
  ScaffoldState get scaffold => _scaffoldKey.currentState;
}
