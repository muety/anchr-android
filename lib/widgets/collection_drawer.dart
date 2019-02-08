import 'package:anchr_android/models/app_state.dart';
import 'package:flutter/material.dart';

class CollectionDrawer extends StatefulWidget {
  final AppState appState;
  final Function(String collectionId) onCollectionSelect;

  const CollectionDrawer({Key key, this.appState, this.onCollectionSelect}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionDrawerState();
}

class _CollectionDrawerState extends State<CollectionDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView.builder(
            itemCount: widget.appState.hasData ? widget.appState.collections.length : 0,
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

              final item = widget.appState.collections[idx - 1];
              return ListTile(
                title: Text(item.name),
                onTap: () {
                  widget.onCollectionSelect(item.id);
                  Navigator.pop(context);
                },
              );
            })
    );
  }
}