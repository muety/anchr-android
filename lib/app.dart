import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/types.dart';
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
  AnchrActions anchrActions;

  @override
  void initState() {
    super.initState();
    _initData();

    anchrActions = AnchrActions(
        loadCollections: _loadCollections,
        loadCollection: _loadCollection,
        deleteLink: _deleteLink
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anchr.io',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Color(0xFFDD5237)
        ),
        home: CollectionsPage(
          appState: appState,
          anchrActions: anchrActions,
        )
    );
  }

  void _initData() async {
    await _loadCollections();
    await _loadCollection(appState.collections.first.id);
  }

  Future<dynamic> _loadCollections() {
    return widget.collectionService.listCollections()
        .then((collections) {
          if (collections != null) {
            setState(() => appState.collections = collections);
          }
        })
        .catchError((e) => showSnackbar('Could not load collections, sorry...'))
        .whenComplete(() =>
        setState(() {
          appState.isLoading = false;
        }));
  }

  Future<dynamic> _loadCollection(String id) {
    setState(() {
      appState.isLoading = true;
    });
    return widget.collectionService.getCollection(id)
        .then((activeCollection) {
      setState(() {
        appState.activeCollection = activeCollection;
      });
    })
        .catchError((e) => showSnackbar('Could not load collection, sorry...'))
        .whenComplete(() => setState(() => appState.isLoading = false));
  }

  Future<dynamic> _deleteLink(Link link) {
    return widget.collectionService.deleteLink(appState.activeCollection.id, link.id)
        .then((_) {
      showSnackbar('Link deleted');
      setState(() {
        appState.activeCollection.links.remove(link);
      });
    })
        .catchError((e) => showSnackbar('Could not delete link, sorry...'));
  }

  void showSnackbar(String text) {
    final ScaffoldState scaffoldContext = AnchrApp.scaffoldKey.currentState;
    scaffoldContext.showSnackBar(SnackBar(content: Text(text)));
  }
}