import 'package:anchr_android/mixins/anchr_actions.dart';
import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/pages/add_link_page.dart';
import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnchrApp extends StatefulWidget {
  final AppState appState = AppState.loading().copyWith(user: 'mail@ferdinand-muetsch.de');

  @override
  State<AnchrApp> createState() => _AnchrAppState(appState);
}

class _AnchrAppState extends AnchrState<AnchrApp> with AnchrActions {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoggedIn = false;

  _AnchrAppState(AppState appState) : super(appState);

  @override
  void initState() {
    _loadPrefs();
  }

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString("user.mail") != null && prefs.getString("user.token") != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CollectionsPage defaultCollectionsPage = CollectionsPage(appState);
    final AddLinkPage defaultAddLinkPage = AddLinkPage(appState);
    final LoginPage defaultLoginPage = LoginPage(appState);

    return MaterialApp(
        title: 'Anchr.io',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal, accentColor: Color(0xFFDD5237)),
        home: isLoggedIn ? defaultCollectionsPage : defaultLoginPage,
        routes: <String, WidgetBuilder>{
          //5
          CollectionsPage.routeName: (BuildContext context) => defaultCollectionsPage, //6
          AddLinkPage.routeName: (BuildContext context) => defaultAddLinkPage, //7
          LoginPage.routeName: (BuildContext context) => defaultAddLinkPage //7
        });
  }

  @override
  ScaffoldState get scaffold => _scaffoldKey.currentState;
}
