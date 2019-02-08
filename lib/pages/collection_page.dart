import 'package:anchr_android/objects/link_collection.dart';
import 'package:anchr_android/services/collection_service.dart';
import 'package:anchr_android/widgets/collection_drawer.dart';
import 'package:anchr_android/widgets/link_list.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatefulWidget {
  static const String routeName = '/';

  final String collectionId;

  CollectionPage({Key key, this.collectionId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionPageState(collectionId);
}

class _CollectionPageState extends State<CollectionPage> {
  final CollectionService collectionService = CollectionService();

  LinkCollection collection;
  String title = 'Collection';

  _CollectionPageState(String collectionId) {
    loadCollection(collectionId);
  }

  void loadCollection(String collectionId) async {
    collection = await collectionService.getCollection(collectionId);
    setState(() {
      this.collection = collection;
      this.title = collection.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CollectionDrawer(
          username: "mail@ferdinand-muetsch.de",
          onCollectionSelect: loadCollection,
      ),
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: LinkList(links: collection?.links),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Add Link',
        child: Icon(Icons.add),
      ),
    );
  }
}
