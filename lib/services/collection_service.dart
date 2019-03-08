import 'dart:convert';

import 'package:anchr_android/database/collection_db_helper.dart';
import 'package:anchr_android/database/link_db_helper.dart';
import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/services/api_service.dart';

class CollectionService extends ApiService {
  static final CollectionService _instance = new CollectionService._internal();
  final CollectionDbHelper collectionDbHelper = CollectionDbHelper();
  final LinkDbHelper linkDbHelper = LinkDbHelper();

  factory CollectionService({String token}) {
    _instance.safeToken = token;
    return _instance;
  }

  CollectionService._internal();

  Future<List<LinkCollection>> listCollections() async {
    try {
      final res = await super.get('/collection?short=true');
      if (res.statusCode == 200) {
        List<LinkCollection> collections = (json.decode(res.body) as List<dynamic>)
            .map((c) => LinkCollection.fromJson(c))
            .where((c) => c.name != null)
            .toList();
        collectionDbHelper.insertBatch(collections);
        return collections;
      } else throw Exception(res.body);
    } catch (e) {
      return collectionDbHelper.findAll();
    }
  }

  Future<LinkCollection> getCollection(String id) async {
    try {
      final res = await super.get('/collection/$id');
      if (res.statusCode == 200) {
        LinkCollection collection = LinkCollection.fromJson(json.decode(res.body));
        linkDbHelper.insertBatch(collection.links, collection.id);
        return collection;
      } else throw Exception(res.body);
    } catch (e) {
        LinkCollection collection = await collectionDbHelper.findOne(id);
        collection.links = await linkDbHelper.findAllByCollection(id);
        return collection;
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
    return LinkCollection.fromJson(json.decode(res.body));
  }

  Future<Null> deleteLink(String collectionId, String linkId) async {
    final res = await super.delete('/collection/$collectionId/links/$linkId');
    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
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
    return Link.fromJson(json.decode(res.body));
  }
}