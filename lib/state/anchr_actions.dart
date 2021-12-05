import 'package:anchr_android/database/collection_db_helper.dart';
import 'package:anchr_android/database/link_db_helper.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/services/auth_service.dart';
import 'package:anchr_android/services/collection_service.dart';
import 'package:anchr_android/services/remote_service.dart';
import 'package:anchr_android/state/app_state.dart';
import 'package:anchr_android/utils.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AnchrState<T extends StatefulWidget> extends State<T> {
  final AppState appState;
  final CollectionService collectionService = CollectionService();
  final RemoteService remoteService = RemoteService();
  final AuthService authService = AuthService();
  final CollectionDbHelper collectionDbHelper = CollectionDbHelper();
  final LinkDbHelper linkDbHelper = LinkDbHelper();

  SharedPreferences preferences;

  AnchrState(this.appState);

  set onUnauthorizedCallback(OnUnauthorized cb) {
    collectionService.onUnauthorized = cb;
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<dynamic> _loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    collectionService.sharedPreferences = preferences;
  }

  Future<bool> initApp() async {
    if (preferences == null) await _loadPreferences();

    if (preferences.getString(Strings.keyUserServerPref) != null) {
      authService.apiUrl = preferences.getString(Strings.keyUserServerPref);
    } else {
      return false;
    }

    if (preferences.getString(Strings.keyUserTokenPref) != null) {
      _updateServiceToken(preferences.getString(Strings.keyUserTokenPref));
    }

    if (preferences.getString(Strings.keyUserMailPref) != null) {
      appState.user = preferences.getString(Strings.keyUserMailPref);
    }

    await CollectionDbHelper().open(Strings.keyDbCollections);
    await LinkDbHelper().open(Strings.keyDbLinks);

    return true;
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

  Future<dynamic> loadCollection(String id, { bool force = false }) {
    setState(() => appState.isLoading = true);
    return collectionService.getCollection(id, force: force).then((activeCollection) {
      setState(() => appState.activeCollection = activeCollection);
      setLastActiveCollection(appState.activeCollection.id);
    }).whenComplete(() => setState(() => appState.isLoading = false));
  }

  Future<dynamic> addCollection(LinkCollection collection) {
    return collectionService.addCollection(collection).then((collection) {
      showSnackbar(Strings.msgCollectionAdded);
      setState(() {
        appState.collections.add(collection);
        appState.activeCollection = collection;
      });
    });
  }

  Future<dynamic> deleteCollection(LinkCollection collection) {
    return collectionService.deleteCollection(collection.id).then((_) {
      showSnackbar(Strings.msgCollectionDeleted);
      setState(() {
        appState.collections.remove(collection);
        if (appState.activeCollection == collection) {
          // TODO: What if last collection was deleted?
          loadCollection(appState.collections[0].id);
        }
      });
    });
  }

  Future<dynamic> deleteLink(Link link) {
    return collectionService.deleteLink(appState.activeCollection.id, link.id).then((_) {
      showSnackbar(Strings.msgLinkDeleted);
      setState(() => appState.activeCollection.links.remove(link));
    });
  }

  Future<dynamic> addLink(String collectionId, Link link) {
    return collectionService.addLink(collectionId, link).then((link) {
      showSnackbar(Strings.msgLinkAdded);
      setState(() => appState.collections.firstWhere((c) => c.id == collectionId).links.insert(0, link));
    });
  }

  Future<String> getPageTitle(String url) {
    return remoteService.fetchPageTitle(url);
  }

  Future<dynamic> login(String serverUrl, String userMail, String password) {
    preferences.setString(Strings.keyUserServerPref, serverUrl);
    authService.apiUrl = serverUrl;
    return authService.login(userMail, password).then((token) {
      preferences.setString(Strings.keyUserMailPref, userMail);
      preferences.setString(Strings.keyUserTokenPref, token);
      return initApp();
    });
  }

  Future<dynamic> renewToken() {
    return authService.renew().then((token) {
      preferences.setString(Strings.keyUserTokenPref, token);
      _updateServiceToken(token);
    });
  }

  Future<dynamic> logout() {
    _clearAll();
    return Future.value(null);
  }

  void setLastActiveCollection(String id) => preferences.setString(Strings.keyLastActiveCollectionPref, id);

  void _clearAll() async {
    await linkDbHelper.delete();
    await collectionDbHelper.delete();
    FLog.clearLogs();
    preferences.clear();
    appState.user = null;
  }
}
