import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/services/collection_service.dart';
import 'package:flutter/material.dart';

class AnchrApp extends StatefulWidget {
  final collectionService = CollectionService();

  @override
  State<StatefulWidget> createState() => AnchrAppState();
}

class AnchrAppState extends State<AnchrApp> {
  AppState appState = AppState.loading().copyWith(user: 'mail@ferdinand-muetsch.de');

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anchr.io',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: CollectionsPage(
          appState: appState,
          loadCollection: _loadCollection,
        )
    );
  }

  void _initData() async {
    var collections = await widget.collectionService.listCollections();
    setState(() {
      if (collections != null) {
        appState = appState.copyWith(collections: collections);
      } else {
        appState.isLoading = false;
      }
    });
    _loadCollection(appState.collections.first.id);
  }

  void _loadCollection(String id) async {
    setState(() {
      appState.isLoading = true;
    });
    var activeCollection = await widget.collectionService.getCollection(id);
    setState(() {
      appState = appState.copyWith(activeCollection: activeCollection);
    });
  }
}