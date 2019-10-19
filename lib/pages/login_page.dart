import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/state/anchr_actions.dart';
import 'package:anchr_android/state/app_state.dart';
import 'package:anchr_android/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  final AppState appState;

  const LoginPage(this.appState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState(appState);
}

class _LoginPageState extends AnchrState<LoginPage> with AnchrActions {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BuildContext currentContext;

  String userMail;
  String userPassword;

  _LoginPageState(AppState appState) : super(appState);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    currentContext = context;

    appState.currentContext = _scaffoldKey.currentContext;
    appState.currentState = _scaffoldKey.currentState;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(Strings.titleLoginPage),
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
                        hintText: Strings.labelEmailInputHint,
                        labelText: Strings.labelEmailInput,
                      ),
                      onSaved: (val) => userMail = val.trim(),
                      validator: (val) => Utils.validateEmail(val.trim()) ? null : Strings.errorInvalidEmail),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                      key: Key('password'),
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.lock),
                        labelText: Strings.labelPasswordInput,
                      ),
                      obscureText: true,
                      onSaved: (val) => userPassword = val.trim(),
                      validator: (val) => val.trim().isNotEmpty ? null : Strings.errorNoPassword),
                ),
                Container(
                  width: screenSize.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: RaisedButton(
                      child: const Text(Strings.labelLoginButton, style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      onPressed: _submit,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(text: Strings.msgSignUp, style: TextStyle(color: Theme.of(context).textTheme.body1.color)),
                        TextSpan(
                            text: ' anchr.io.',
                            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = () => Utils.launchURL(Strings.urlAnchr))
                      ]
                      )),
                )
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
          .catchError((e) => showSnackbar(Strings.errorLogin));
    }
  }
}
