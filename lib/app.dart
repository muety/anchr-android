import 'package:anchr_android/database/collection_db_helper.dart';
import 'package:anchr_android/database/link_db_helper.dart';
import 'package:anchr_android/pages/add_link_page.dart';
import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/pages/login_page.dart';
import 'package:anchr_android/state/anchr_actions.dart';
import 'package:anchr_android/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnchrApp extends StatefulWidget {
  final AppState appState = AppState.loading().copyWith(user: 'mail@ferdinand-muetsch.de');

  @override
  State<AnchrApp> createState() => _AnchrAppState(appState);
}

class _AnchrAppState extends AnchrState<AnchrApp> with AnchrActions {
  static const platform = const MethodChannel('app.channel.shared.data');

  Map<dynamic, dynamic> sharedData;
  bool isLoggedIn = false;

  _AnchrAppState(AppState appState) : super(appState);

  @override
  void initState() {
    _init();
  }

  void _init() async {
    await CollectionDbHelper().open('collection.db');
    await LinkDbHelper().open('link.db');
    await _loadPrefs();
    await _getSharedData();

    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg.contains('resumed')) {
        _getSharedData();
        Navigator.of(appState.currentContext).pushNamed(AddLinkPage.routeName);
      }
    });
  }

  Future<void> _getSharedData() async {
    var data = await platform.invokeMethod("getSharedData");
    setState(() => sharedData = data);
    return data;
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString("user.mail") != null && prefs.getString("user.token") != null;
    });
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    final CollectionsPage defaultCollectionsPage = CollectionsPage(appState);
    final AddLinkPage defaultAddLinkPage = AddLinkPage(appState);
    final LoginPage defaultLoginPage = LoginPage(appState);

    StatefulWidget startingPage;
    if (!isLoggedIn) startingPage = defaultLoginPage;
    else if (sharedData != null && sharedData.length > 0) startingPage = defaultAddLinkPage;
    else startingPage = defaultCollectionsPage;

    return MaterialApp(
        title: 'Anchr.io',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal, accentColor: Color(0xFFDD5237)),
        home: startingPage,
        routes: <String, WidgetBuilder>{
          //5
          CollectionsPage.routeName: (BuildContext context) => defaultCollectionsPage, //6
          AddLinkPage.routeName: (BuildContext context) => defaultAddLinkPage, //7
          LoginPage.routeName: (BuildContext context) => defaultLoginPage //7
        });
  }
}
