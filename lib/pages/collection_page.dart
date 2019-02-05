import 'package:anchr_android/objects/link_collection.dart';
import 'package:anchr_android/services/collection_service.dart';
import 'package:anchr_android/widgets/link_list.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatefulWidget {
  final String collectionId;

  CollectionPage({Key key, this.collectionId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionPageState(collectionId);
}

class _CollectionPageState extends State<CollectionPage> {
  final CollectionService collectionService = CollectionService();

  String title = 'Collection';
  LinkCollection collection;

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
