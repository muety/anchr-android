import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/pages/add_link_page.dart';
import 'package:anchr_android/pages/collections_page.dart';
import 'package:anchr_android/services/collection_service.dart';
import 'package:anchr_android/utils.dart';
import 'package:flutter/material.dart';

class AnchrApp extends StatefulWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final collectionService = CollectionService();

  @override
  State<AnchrApp> createState() => AnchrAppState();
}

class AnchrAppState extends State<AnchrApp> with SnackbarSupport {
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
    final CollectionsPage defaultCollectionsPage = CollectionsPage(
      appState: appState,
      anchrActions: anchrActions,
    );

    final AddLinkPage defaultAddLinkPage = AddLinkPage(
      appState: appState,
      anchrActions: anchrActions,
    );

    return MaterialApp(
        title: 'Anchr.io',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Color(0xFFDD5237)
        ),
        home: defaultCollectionsPage,
        routes: <String, WidgetBuilder> { //5
          CollectionsPage.routeName: (BuildContext context) => defaultCollectionsPage, //6
          AddLinkPage.routeName: (BuildContext context) => defaultAddLinkPage //7
        }
    );
  }

  void _initData() async {
    await _loadCollections();
    if (appState.collections != null && appState.collections.isNotEmpty) {
      await _loadCollection(appState.collections.first.id);
    }
  }

  Future<dynamic> _loadCollections({BuildContext context}) {
    return widget.collectionService.listCollections()
        .then((collections) {
          if (collections != null) {
            setState(() => appState.collections = collections);
          }
        })
        .catchError((e) => _showSnackbar('Could not load collections, sorry...'))
        .whenComplete(() => setState(() => appState.isLoading = false));
  }

  Future<dynamic> _loadCollection(String id, {BuildContext context}) {
    setState(() => appState.isLoading = true);
    return widget.collectionService.getCollection(id)
        .then((activeCollection) => setState(() => appState.activeCollection = activeCollection))
        .catchError((e) => _showSnackbar('Could not load collection, sorry...'))
        .whenComplete(() => setState(() => appState.isLoading = false));
  }

  Future<dynamic> _deleteLink(Link link, {BuildContext context}) {
    return widget.collectionService.deleteLink(appState.activeCollection.id, link.id)
        .then((_) {
          _showSnackbar('Link deleted');
          setState(() => appState.activeCollection.links.remove(link));
        })
        .catchError((e) => _showSnackbar('Could not delete link, sorry...'));
  }

  void _showSnackbar(String text, {BuildContext context}) {
    if (AnchrApp.scaffoldKey?.currentState is ScaffoldState) {
      showSnackbar(text, scaffoldState: AnchrApp.scaffoldKey.currentState);
    }
  }
}