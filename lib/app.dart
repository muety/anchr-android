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

  Map<dynamic, dynamic> sharedData = Map();
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
    var data = await _getSharedData();
    setState(() => sharedData = data);

    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg.contains('resumed')) {
        _getSharedData().then((d) {
          if (d.isEmpty) return;
          Navigator.of(appState.currentContext).pushNamedAndRemoveUntil(
              AddLinkPage.routeName, (Route<dynamic> route) => route.settings.name != AddLinkPage.routeName,
              arguments: d);
        });
      }
    });
  }

  Future<Map> _getSharedData() async {
    return await platform.invokeMethod("getSharedData");
  }

  Future<SharedPreferences> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString("user.mail") != null && prefs.getString("user.token") != null;
    });
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    var linkData = Map.from(sharedData);
    sharedData.clear();

    final CollectionsPage defaultCollectionsPage = CollectionsPage(appState);
    final AddLinkPage defaultAddLinkPage = AddLinkPage(appState, linkData: linkData);
    final LoginPage defaultLoginPage = LoginPage(appState);

    StatefulWidget startingPage;
    if (!isLoggedIn)
      startingPage = defaultLoginPage;
    else if (linkData != null && linkData.length > 0)
      startingPage = defaultAddLinkPage;
    else
      startingPage = defaultCollectionsPage;

    return MaterialApp(
        title: 'Anchr.io',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal, accentColor: Color(0xFFDD5237)),
        home: startingPage,
        routes: <String, WidgetBuilder>{
          //5
          CollectionsPage.routeName: (BuildContext context) => defaultCollectionsPage, //6
          LoginPage.routeName: (BuildContext context) => defaultLoginPage //7
        },
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case AddLinkPage.routeName:
              var linkData = (settings.arguments is Map) ? settings.arguments : null;
              return MaterialPageRoute(
                  settings: settings, builder: (context) => AddLinkPage(appState, linkData: linkData));
              break;
          }
        });
  }
}
