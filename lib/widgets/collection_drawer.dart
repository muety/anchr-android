import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/pages/login_page.dart';
import 'package:anchr_android/widgets/add_collection_dialog.dart';
import 'package:flutter/material.dart';

class CollectionDrawer extends StatefulWidget {
  final AppState appState;
  final Function(String collectionId) onCollectionSelect;
  final AddCollection onAddCollection;
  final OnLogout onLogout;

  const CollectionDrawer({Key key, this.appState, this.onCollectionSelect, this.onAddCollection, this.onLogout}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionDrawerState();
}

class _CollectionDrawerState extends State<CollectionDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView.builder(
            itemCount: widget.appState.hasData ? widget.appState.collections.length + 2 : 1,
            itemBuilder: (ctx, idx) => _getDrawerItem(ctx, idx)));
  }

  Widget _getDrawerItem(BuildContext ctx, int idx) {
    if (idx == 0) {
      return DrawerHeader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              child: Text('Collections', style: Theme.of(ctx).textTheme.title.copyWith(color: Colors.white)),
              padding: const EdgeInsets.only(bottom: 8),
            ),
            Padding(
              child: Text(widget.appState.user, style: Theme.of(ctx).textTheme.body1.copyWith(color: Colors.white)),
              padding: const EdgeInsets.only(bottom: 16),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Logout'),
                    onPressed: () => widget.onLogout().then((_) => Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (_) => false)),
                    color: Theme.of(ctx).accentColor,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(color: Theme.of(ctx).primaryColor),
      );
    } else if (idx == widget.appState.collections.length + 1) {
      return ListTile(
        title: const Text('Add collection'),
        leading: Icon(Icons.add),
        onTap: () => showDialog(
            context: context,
            builder: AddCollectionDialog(
              existingCollections: widget.appState.collections,
              onAddCollection: (collection) {
                widget.onAddCollection(collection).whenComplete(() => Navigator.pop(ctx));
              },
            ).builder),
      );
    } else {
      final item = widget.appState.collections[idx - 1];
      return ListTile(
        title: Text(item.name),
        onTap: () {
          widget.onCollectionSelect(item.id);
          Navigator.pop(ctx);
        },
      );
    }
  }
}
