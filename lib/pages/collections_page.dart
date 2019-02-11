import 'package:anchr_android/mixins/anchr_actions.dart';
import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/widgets/collection_drawer.dart';
import 'package:anchr_android/widgets/link_list.dart';
import 'package:flutter/material.dart';

class CollectionsPage extends StatefulWidget {
  static const String routeName = '/collection';
  final AppState appState;

  const CollectionsPage(this.appState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionsPageState(appState);
}

class _CollectionsPageState extends AnchrState<CollectionsPage> with AnchrActions {
  static const defaultTitle = 'Collection';
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
    return Scaffold(
      key: _scaffoldKey,
      drawer: CollectionDrawer(
        appState: appState,
        onCollectionSelect: loadCollection,
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
              deleteLink: deleteLink,
            ),
            onRefresh: () async {
              refreshing = true;
              await loadCollection(appState.activeCollection.id, context: context);
              refreshing = false;
            },
          );
        }(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add');
        },
        tooltip: 'Add Link',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _initData() async {
    await loadCollections();
    if (appState.collections != null && appState.collections.isNotEmpty) {
      await loadCollection(appState.collections.first.id);
    }
  }

  @override
  ScaffoldState get scaffold => _scaffoldKey.currentState;
}
