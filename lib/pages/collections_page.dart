import 'package:anchr_android/app.dart';
import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/widgets/collection_drawer.dart';
import 'package:anchr_android/widgets/link_list.dart';
import 'package:flutter/material.dart';

class CollectionsPage extends StatefulWidget {
  static const String routeName = '/';

  final AppState appState;
  final LoadCollection loadCollection;
  final DeleteLink deleteLink;

  const CollectionsPage({Key key, this.appState, this.loadCollection, this.deleteLink}) : super(key: key);

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
        onCollectionSelect: widget.loadCollection,
      ),
      appBar: AppBar(
        title: Text(widget.appState.title),
      ),
      body: Center(
        child: () {
          if (!widget.appState.hasData || (widget.appState.isLoading && !refreshing)) {
            return CircularProgressIndicator();
          }
          return RefreshIndicator(
            child: LinkList(
              links: widget.appState.activeCollection.links,
              deleteLink: widget.deleteLink,
            ),
            onRefresh: () async {
              refreshing = true;
              await widget.loadCollection(widget.appState.activeCollection.id);
              refreshing = false;
            },
          );
        }(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Add Link',
        child: Icon(Icons.add),
      ),
    );
  }
}
