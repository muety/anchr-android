import 'package:anchr_android/pages/collection_page.dart';
import 'package:anchr_android/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(AnchrApp());

class AnchrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: CollectionPage(collectionId: 'links.json'),
        routes: <String, WidgetBuilder>{
          LoginPage.routeName: (BuildContext context) => const LoginPage(),
        });
  }
}
