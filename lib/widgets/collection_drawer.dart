import 'package:anchr_android/objects/link_collection.dart';
import 'package:flutter/material.dart';

class CollectionDrawer extends StatefulWidget {
  final String username;
  final Function(String collectionId) onCollectionSelect;

  // TODO: Remove class attributes
  // TODO: Rework constructor: should initialize collection loading
  const CollectionDrawer({Key key, this.username, this.onCollectionSelect}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionDrawerState(username, onCollectionSelect);
}

class _CollectionDrawerState extends State<CollectionDrawer> {
  final String username;
  final Function(String collectionId) onCollectionSelect;

  List<LinkCollection> collections = List();

  _CollectionDrawerState(this.username, this.onCollectionSelect);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView.builder(
            itemCount: collections.length + 1,
            itemBuilder: (ctx, idx) {
              if (idx == 0) {
                return Container(
                  child: ListTile(
                      title: Text(
                          'Collections',
                          style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)
                      )
                  ),
                  decoration: BoxDecoration(
                      color: Colors.teal
                  ),
                );
              }

              final item = collections[idx - 1];
              return ListTile(
                title: Text(item.name),
                onTap: () {
                  onCollectionSelect(item.id);
                  Navigator.pop(context);
                },
              );
            })
    );
  }
}