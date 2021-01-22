import 'dart:io';

import 'package:anchr_android/models/exception.dart';
import 'package:anchr_android/pages/about_page.dart';
import 'package:anchr_android/pages/add_link_page.dart';
import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/pages/login_page.dart';
import 'package:anchr_android/pages/logs_page.dart';
import 'package:anchr_android/pages/splash_page.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/state/anchr_actions.dart';
import 'package:anchr_android/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnchrApp extends StatefulWidget {
  @override
  State<AnchrApp> createState() => _AnchrAppState(AppState.loading());
}

class _AnchrAppState extends AnchrState<AnchrApp> with AnchrActions {
  static const platform = const MethodChannel('app.channel.shared.data');

  Map<dynamic, dynamic> sharedData = Map();
  bool initialized = false;
  bool isLoggedIn = false;

  _AnchrAppState(AppState appState) : super(appState);

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    onUnauthorizedCallback = _onUnauthorized;

    if (!await initApp()) {
      logout();
      setState(() => isLoggedIn = false);
    }

    var data = await _getSharedData();
    setState(() => sharedData = data);

    if (_isLoggedIn()) {
      try {
        await renewToken();
        setState(() => isLoggedIn = true);
        // There is two kinds of failures here:
        // 1. No network connection (SocketException) -> keep going, load collections page and use cache
        // 2. Token expired (UnauthorizedException) -> go to login page
        // Originally, _onUnauthorized was supposed to handle redirection to login page. However, for some
        // buggy reason, appState.currentContext is not yet set at this time, so nothing can be popped from navigator.
        // TODO: Fix this and make it more consistent.
      } on SocketException {
        setState(() => isLoggedIn = true);
      } on UnauthorizedException {
        setState(() => isLoggedIn = false);
      }
    }

    setState(() => initialized = true);

    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (!msg.contains('resumed')) return;
      _handleSharedData(await _getSharedData());
      return;
    });
  }

  Future<Map> _getSharedData() async => await platform.invokeMethod('getSharedData');

  _handleSharedData(data) {
    if (data.isEmpty) return;
    Navigator.of(appState.currentContext).pushNamedAndRemoveUntil(AddLinkPage.routeName, (Route<dynamic> route) => route.settings.name != AddLinkPage.routeName, arguments: data);
  }

  bool _isLoggedIn() {
    final userMail = preferences.getString(Strings.keyUserMailPref);
    final userToken = preferences.getString(Strings.keyUserTokenPref);
    return userMail != null && userToken != null;
  }

  _onUnauthorized() {
    logout();
    if (appState.currentContext != null) {
      Navigator.of(appState.currentContext).pushNamedAndRemoveUntil(LoginPage.routeName, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var linkData = Map.from(sharedData);

    final SplashPage defaultSplashPage = SplashPage();
    final AboutPage defaultAboutPage = AboutPage();
    final LogsPage defaultLogsPage = LogsPage();
    final CollectionsPage defaultCollectionsPage = CollectionsPage(appState);
    final AddLinkPage defaultAddLinkPage = AddLinkPage(appState, linkData: linkData);
    final LoginPage defaultLoginPage = LoginPage(appState);

    Widget getPage() {
      Widget startingPage;
      if (initialized) {
        if (!isLoggedIn) {
          startingPage = defaultLoginPage;
        } else if (linkData != null && linkData.length > 0) {
          startingPage = defaultAddLinkPage;
          sharedData.clear();
        } else {
          startingPage = defaultCollectionsPage;
        }
      } else {
        startingPage = defaultSplashPage;
      }
      return startingPage;
    }

    return MaterialApp(
        title: Strings.title,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal, accentColor: Color(0xFFDD5237)),
        home: getPage(),
        routes: <String, WidgetBuilder>{
          //5
          CollectionsPage.routeName: (BuildContext context) => defaultCollectionsPage,
          LoginPage.routeName: (BuildContext context) => defaultLoginPage,
          AboutPage.routeName: (BuildContext context) => defaultAboutPage,
          LogsPage.routeName: (BuildContext context) => defaultLogsPage
        },
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case AddLinkPage.routeName:
              var linkData = (settings.arguments is Map) ? settings.arguments : null;
              return MaterialPageRoute(settings: settings, builder: (context) => AddLinkPage(appState, linkData: linkData));
              break;
          }
          return null;
        });
  }
}
