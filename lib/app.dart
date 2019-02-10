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
    await _loadCollections();
    await _loadCollection(appState.collections.first.id);
  }

  Future<Null> _loadCollections() {
    return widget.collectionService.listCollections().then((collections) {
      setState(() {
        if (collections != null) {
          appState = appState.copyWith(collections: collections);
        } else {
          appState.isLoading = false;
        }
      });
    });
  }

  Future<Null> _loadCollection(String id) {
    setState(() {
      appState.isLoading = true;
    });
    return widget.collectionService.getCollection(id).then((activeCollection) {
      setState(() {
        appState = appState.copyWith(activeCollection: activeCollection);
      });
    });
  }

  Future<Null> _deleteLink(Link link) {
    final ScaffoldState scaffoldContext = AnchrApp.scaffoldKey.currentState;
    return widget.collectionService.deleteLink(appState.activeCollection.id, link.id).then((_) {
      scaffoldContext.showSnackBar(SnackBar(content: Text('Link deleted.')));
      setState(() {
        appState.activeCollection.links.remove(link);
      });
    });
  }
}