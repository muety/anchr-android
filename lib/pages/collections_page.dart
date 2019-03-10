import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/pages/add_link_page.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/state/anchr_actions.dart';
import 'package:anchr_android/state/app_state.dart';
import 'package:anchr_android/widgets/collection_drawer.dart';
import 'package:anchr_android/widgets/link_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionsPage extends StatefulWidget {
  static const String routeName = '/collection';
  final AppState appState;

  const CollectionsPage(this.appState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionsPageState(appState);
}

class _CollectionsPageState extends AnchrState<CollectionsPage> with AnchrActions {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool refreshing = false;

  _CollectionsPageState(AppState appState) : super(appState);

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    appState.currentContext = _scaffoldKey.currentContext;
    appState.currentState = _scaffoldKey.currentState;

    return Scaffold(
      key: _scaffoldKey,
      drawer: CollectionDrawer(
        appState: appState,
        onCollectionSelect: (id) =>
            loadCollection(id).catchError((e) => showSnackbar(Strings.errorLoadCollection)),
        onAddCollection: (name) => addCollection(LinkCollection(name: name, links: []))
            .catchError((e) => showSnackbar(Strings.errorAddCollection)),
        onLogout: logout,
      ),
      appBar: AppBar(
        title: Text(appState.title),
      ),
      body: Center(
        child: () {
          if (appState.isLoading && !refreshing) {
            return CircularProgressIndicator();
          }
          return RefreshIndicator(
            child: LinkList(
              links: widget.appState.activeCollection?.links,
              deleteLink: (link) => deleteLink(link).catchError((e) => showSnackbar(Strings.errorDeleteLink)),
            ),
            onRefresh: () async {
              refreshing = true;
              try {
                await loadCollection(appState.activeCollection.id);
              } catch (e) {
                showSnackbar(Strings.errorLoadCollection);
              } finally {
                refreshing = false;
              }
            },
          );
        }(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddLinkPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _initData() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await loadCollections();
      if (appState.collections != null && appState.collections.isNotEmpty) {
        var lastActive = prefs.getString(Strings.keyLastActiveCollectionPref);
        var loadId = appState.collections.any((c) => c.id == lastActive) ? lastActive : appState.collections.first.id;
        await loadCollection(loadId);
      }
    } catch (e) {
      showSnackbar(Strings.errorLoadCollections);
    }
  }
}
