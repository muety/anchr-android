import 'dart:async';
import 'dart:convert';

import 'package:anchr_android/database/collection_db_helper.dart';
import 'package:anchr_android/database/link_db_helper.dart';
import 'package:anchr_android/models/exception.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionService extends ApiService {
  static final CollectionService _instance = new CollectionService._internal();

  static const int timeoutSecs = 5;
  final CollectionDbHelper collectionDbHelper = CollectionDbHelper();
  final LinkDbHelper linkDbHelper = LinkDbHelper();
  SharedPreferences sharedPreferences;

  factory CollectionService({String token, OnUnauthorized onUnauthorized, SharedPreferences prefs}) {
    _instance.safeToken = token;
    _instance.safeOnUnauthorized = onUnauthorized;
    _instance.sharedPreferences = prefs;
    return _instance;
  }

  CollectionService._internal();

  Future<List<LinkCollection>> listCollections() async {
    try {
      final lastKnownEtag = sharedPreferences.getString(Strings.keyCollectionsEtag);
      final latestEtag = await _getCollectionsEtag();
      sharedPreferences.setString(Strings.keyCollectionsEtag, latestEtag);

      if (lastKnownEtag == latestEtag) {
        return await _listCollectionsOffline();
      } else {
        return await _listCollectionsOnline()
            .timeout(Duration(seconds: timeoutSecs), onTimeout: () => _listCollectionsOffline());
      }
    } catch (e) {
      return await _listCollectionsOffline();
    }
  }

  Future<LinkCollection> getCollection(String id, { force: false }) async {
    try {
      final lastKnownEtag = sharedPreferences.getString(Strings.keyCollectionEtagPrefix + id);
      final latestEtag = await _getCollectionEtag(id);
      await sharedPreferences.setString(Strings.keyCollectionEtagPrefix + id, latestEtag);

      if (!force && lastKnownEtag == latestEtag) {
        return await _getCollectionOffline(id);
      } else {
        return await _getCollectionOnline(id)
            .timeout(Duration(seconds: timeoutSecs), onTimeout: () => _getCollectionOffline(id));
      }

    } catch (e) {
      return await _getCollectionOffline(id);
    }
  }

  Future<LinkCollection> addCollection(LinkCollection collection) async {
    final data = {'name': collection.name, 'links': collection.links};
    final res = await super.post('/collection', data);
    if (res.statusCode != 201) {
      throw WebServiceException(message: res.body);
    }
    collection = LinkCollection.fromJson(json.decode(res.body));
    collectionDbHelper.insert(collection);
    linkDbHelper.insertBatch(collection.links, collection.id);
    return collection;
  }

  Future<Null> deleteCollection(String collectionId) async {
    final res = await super.delete('/collection/$collectionId');
    if (res.statusCode != 200) {
      throw WebServiceException(message: res.body);
    }
    collectionDbHelper.deleteById(collectionId);
  }

  Future<Null> deleteLink(String collectionId, String linkId) async {
    final res = await super.delete('/collection/$collectionId/links/$linkId');
    if (res.statusCode != 200) {
      throw WebServiceException(message: res.body);
    }
    linkDbHelper.deleteById(linkId);
  }

  Future<Link> addLink(String collectionId, Link link) async {
    final data = {'collId': collectionId, 'description': link.description, 'url': link.url};
    final res = await super.post('/collection/$collectionId/links', data);
    if (res.statusCode != 201) {
      throw WebServiceException(message: res.body);
    }
    link = Link.fromJson(json.decode(res.body));
    linkDbHelper.insert(link, collectionId);
    return link;
  }

  Future<String> _getCollectionsEtag() async {
    final res = await super.head('/collection?short=true');
    if (res.statusCode == 200)
      return res.headers['etag'];
    else
      throw WebServiceException(message: res.body);
  }

  Future<String> _getCollectionEtag(String id) async {
    final res = await super.head('/collection/$id');
    if (res.statusCode == 200)
      return res.headers['etag'];
    else
      throw WebServiceException(message: res.body);
  }

  Future<List<LinkCollection>> _listCollectionsOnline() async {
    final res = (await Future.wait([
      super.get('/collection?short=true'),
      collectionDbHelper.deleteAll()
    ]))[0];

    if (res.statusCode == 200) {
      List<LinkCollection> collections = (json.decode(res.body) as List<dynamic>)
          .map((c) => LinkCollection.fromJson(c))
          .where((c) => c.name != null)
          .toList();
      await collectionDbHelper.insertBatch(collections);
      return collections;
    } else
      throw WebServiceException(message: res.body);
  }

  Future<LinkCollection> _getCollectionOnline(String id) async {
    final res = (await Future.wait([
      super.get('/collection/$id'),
      linkDbHelper.deleteAllByCollection(id)
    ]))[0];

    if (res.statusCode == 200) {
      LinkCollection collection = LinkCollection.fromJson(json.decode(res.body));
      await linkDbHelper.insertBatch(collection.links, collection.id);
      return collection;
    } else
      throw WebServiceException(message: res.body);
  }

  Future<List<LinkCollection>> _listCollectionsOffline() async {
    return collectionDbHelper.findAll();
  }

  Future<LinkCollection> _getCollectionOffline(String id) async {
    LinkCollection collection = await collectionDbHelper.findOne(id);
    collection.links = await linkDbHelper.findAllByCollection(id);
    return collection;
  }
}
