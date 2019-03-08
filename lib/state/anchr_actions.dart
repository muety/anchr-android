import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/services/auth_service.dart';
import 'package:anchr_android/services/collection_service.dart';
import 'package:anchr_android/state/app_state.dart';
import 'package:anchr_android/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AnchrState<T extends StatefulWidget> extends State<T> {
  final AppState appState;
  final collectionService = CollectionService();
  final authService = AuthService();
  SharedPreferences preferences;

  AnchrState(this.appState);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    this.preferences = await SharedPreferences.getInstance();
    if (this.preferences.getString("user.token") != null) {
      _updateServiceToken(this.preferences.getString("user.token"));
    }
  }

  void showSnackbar(String text) => Utils.showSnackbar(text, scaffoldState: appState.currentState);

  void _updateServiceToken(String token) {
    collectionService.safeToken = token;
    authService.safeToken = token;
  }
}

mixin AnchrActions<T extends StatefulWidget> on AnchrState<T> {
  Future<dynamic> loadCollections() {
    return collectionService.listCollections().then((collections) {
      if (collections != null) {
        collections.sort();
        setState(() => appState.collections = collections);
      }
    }).whenComplete(() => setState(() => appState.isLoading = false));
  }

  Future<dynamic> loadCollection(String id) {
    setState(() => appState.isLoading = true);
    return collectionService.getCollection(id).then((activeCollection) {
      setState(() => appState.activeCollection = activeCollection);
      setLastActiveCollection(appState.activeCollection.id);
    }).whenComplete(() => setState(() => appState.isLoading = false));
  }

  Future<dynamic> addCollection(LinkCollection collection) {
    return collectionService.addCollection(collection).then((collection) {
      showSnackbar('Collection added');
      setState(() {
        appState.collections.add(collection);
        appState.activeCollection = collection;
      });
    });
  }

  Future<dynamic> deleteLink(Link link) {
    return collectionService.deleteLink(appState.activeCollection.id, link.id).then((_) {
      showSnackbar('Link deleted');
      setState(() => appState.activeCollection.links.remove(link));
    });
  }

  Future<dynamic> addLink(String collectionId, Link link) {
    return collectionService.addLink(collectionId, link).then((link) {
      showSnackbar('Link added');
      setState(() => appState.collections.firstWhere((c) => c.id == collectionId).links.insert(0, link));
    });
  }

  Future<dynamic> login(String userMail, String password) {
    return authService.login(userMail, password).then((token) {
      preferences.setString("user.mail", userMail);
      preferences.setString("user.token", token);
      return token;
    }).then((token) {
      _updateServiceToken(token);
      return token;
    });
  }

  Future<dynamic> logout() {
    preferences.clear();
    return Future.value(null);
  }

  void setLastActiveCollection(String id) => preferences.setString('collection.last_active', id);
}
