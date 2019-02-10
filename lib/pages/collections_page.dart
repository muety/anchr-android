import 'package:anchr_android/app.dart';
import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/widgets/collection_drawer.dart';
import 'package:anchr_android/widgets/link_list.dart';
import 'package:flutter/material.dart';

class CollectionsPage extends StatefulWidget {
  static const String routeName = '/collection';

  final AppState appState;
  final AnchrActions anchrActions;

  const CollectionsPage({Key key, this.appState, this.anchrActions}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  static const defaultTitle = 'Collection';
  bool refreshing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AnchrApp.scaffoldKey,
      drawer: CollectionDrawer(
        appState: widget.appState,
        onCollectionSelect: widget.anchrActions.loadCollection,
      ),
      appBar: AppBar(
        title: Text(widget.appState.title),
      ),
      body: Center(
        child: () {
          if (widget.appState.isLoading && !refreshing) {
            return CircularProgressIndicator();
          }
          return RefreshIndicator(
            child: LinkList(
              links: widget.appState.activeCollection?.links,
              deleteLink: widget.anchrActions.deleteLink,
            ),
            onRefresh: () async {
              refreshing = true;
              await widget.anchrActions.loadCollection(widget.appState.activeCollection.id, context: context);
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
}
