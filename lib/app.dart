import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/services/collection_service.dart';
import 'package:flutter/material.dart';

class AnchrApp extends StatefulWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
          deleteLink: _deleteLink,
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

  void _deleteLink(Link link) async {
    final ScaffoldState scaffoldContext = AnchrApp.scaffoldKey.currentState;
    await widget.collectionService.deleteLink(appState.activeCollection.id, link.id);
    scaffoldContext.showSnackBar(SnackBar(content: Text('Link deleted.')));
    setState(() {
      appState.activeCollection.links.remove(link);
    });
  }
}