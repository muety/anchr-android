import 'package:anchr_android/pages/collection_page.dart';
import 'package:anchr_android/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(AnchrApp());

class AnchrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anchr.io',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        initialRoute: "/",
        routes: <String, WidgetBuilder>{
          LoginPage.routeName: (BuildContext context) => LoginPage(),
          CollectionPage.routeName: (BuildContext context) => CollectionPage(collectionId: 'Sr1xI',),
        });
  }
}
