import 'dart:async';
import 'dart:convert';

import 'package:anchr_android/database/collection_db_helper.dart';
import 'package:anchr_android/database/link_db_helper.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/services/api_service.dart';

class CollectionService extends ApiService {
  static final CollectionService _instance = new CollectionService._internal();

  static const int timeoutSecs = 5;
  final CollectionDbHelper collectionDbHelper = CollectionDbHelper();
  final LinkDbHelper linkDbHelper = LinkDbHelper();

  factory CollectionService({String token}) {
    _instance.safeToken = token;
    return _instance;
  }

  CollectionService._internal();

  Future<List<LinkCollection>> listCollections() async {
    try {
      return await _listCollectionsOnline().timeout(Duration(seconds: timeoutSecs), onTimeout: () => _listCollectionsOffline());
    } catch (e) {
      return await _listCollectionsOffline();
    }
  }

  Future<LinkCollection> getCollection(String id) async {
    try {
      return await _getCollectionOnline(id).timeout(Duration(seconds: timeoutSecs), onTimeout: () => _getCollectionOffline(id));
    } catch (e) {
      return await _getCollectionOffline(id);
    }
  }

  Future<LinkCollection> addCollection(LinkCollection collection) async {
    final data = {
      'name': collection.name,
      'links': collection.links
    };
    final res = await super.post('/collection', data);
    if (res.statusCode != 201) {
      throw Exception(res.body);
    }
    collection = LinkCollection.fromJson(json.decode(res.body));
    collectionDbHelper.insert(collection);
    linkDbHelper.insertBatch(collection.links, collection.id);
    return collection;
  }

  Future<Null> deleteLink(String collectionId, String linkId) async {
    final res = await super.delete('/collection/$collectionId/links/$linkId');
    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
    linkDbHelper.deleteById(linkId);
  }

  Future<Link> addLink(String collectionId, Link link) async {
    final data = {
      'collId': collectionId,
      'description': link.description,
      'url': link.url
    };
    final res = await super.post('/collection/$collectionId/links', data);
    if (res.statusCode != 201) {
      throw Exception(res.body);
    }
    link = Link.fromJson(json.decode(res.body));
    linkDbHelper.insert(link, collectionId);
    return link;
  }

  Future<List<LinkCollection>> _listCollectionsOnline() async {
    final res = await super.get('/collection?short=true');
    if (res.statusCode == 200) {
      List<LinkCollection> collections = (json.decode(res.body) as List<dynamic>)
          .map((c) => LinkCollection.fromJson(c))
          .where((c) => c.name != null)
          .toList();
      collectionDbHelper.insertBatch(collections);
      return collections;
    } else throw Exception(res.body);
  }

  Future<LinkCollection> _getCollectionOnline(String id) async {
    final res = await super.get('/collection/$id');
    if (res.statusCode == 200) {
      LinkCollection collection = LinkCollection.fromJson(json.decode(res.body));
      linkDbHelper.insertBatch(collection.links, collection.id);
      return collection;
    } else throw Exception(res.body);
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