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
  static const defaultTitle = 'Collection';
  final CollectionService collectionService = CollectionService();
  final String collectionId;
  Future<LinkCollection> collection;

  _CollectionPageState(this.collectionId);

  @override
  void initState() {
    super.initState();
    loadCollection(collectionId);
  }

  void loadCollection(String collectionId) {
    collection = collectionService.getCollection(collectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CollectionDrawer(
        username: "mail@ferdinand-muetsch.de",
        onCollectionSelect: loadCollection,
      ),
      appBar: AppBar(
        title: FutureBuilder<LinkCollection>(
          future: collection,
          builder: (context, snapshot) => snapshot.hasData ? Text(snapshot.data.name) : Text(defaultTitle),
        ),
      ),
      body: Center(
        child: FutureBuilder<LinkCollection>(
          future: collection,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LinkList(links: snapshot.data.links);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Add Link',
        child: Icon(Icons.add),
      ),
    );
  }
}
