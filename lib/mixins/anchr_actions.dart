import 'package:anchr_android/models/app_state.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/services/collection_service.dart';
import 'package:anchr_android/utils.dart';
import 'package:flutter/material.dart';

abstract class AnchrState<T extends StatefulWidget> extends State<T> {
  final AppState appState;
  final collectionService = CollectionService();

  AnchrState(this.appState);

  ScaffoldState get scaffold;

  void showSnackbar(String text) {
    Utils.showSnackbar(text, scaffoldState: scaffold);
  }
}

mixin AnchrActions<T extends StatefulWidget> on AnchrState<T> {
  Future<dynamic> loadCollections() {
    return collectionService.listCollections()
        .then((collections) {
          if (collections != null) {
            setState(() => appState.collections = collections);
          }
        })
        .catchError((e) => showSnackbar('Could not load collections, sorry...'))
        .whenComplete(() => setState(() => appState.isLoading = false));
  }

  Future<dynamic> loadCollection(String id, {BuildContext context}) {
    setState(() => appState.isLoading = true);
    return collectionService.getCollection(id)
        .then((activeCollection) => setState(() => appState.activeCollection = activeCollection))
        .catchError((e) => showSnackbar('Could not load collection, sorry...'))
        .whenComplete(() => setState(() => appState.isLoading = false));
  }

  Future<dynamic> deleteLink(Link link, {BuildContext context}) {
    return collectionService.deleteLink(appState.activeCollection.id, link.id)
        .then((_) {
          showSnackbar('Link deleted');
          setState(() => appState.activeCollection.links.remove(link));
        })
        .catchError((e) => showSnackbar('Could not delete link, sorry...'));
  }
}
