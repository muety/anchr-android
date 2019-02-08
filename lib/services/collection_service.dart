import 'dart:convert';

import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/services/api_service.dart';

class CollectionService extends ApiService {
  static final CollectionService _instance = new CollectionService._internal();

  factory CollectionService() {
    return _instance;
  }

  CollectionService._internal();

  Future<List<LinkCollection>> listCollections() async {
    final res = await super.get('/collection?short=true');
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List<dynamic>)
          .map((c) => LinkCollection.fromJson(c))
          .where((c) => c.name != null)
          .toList();
    } else {
      throw Exception(res.body);
    }
  }

  Future<LinkCollection> getCollection(String id) async {
    final res = await super.get('/collection/$id');
    if (res.statusCode == 200) {
      return LinkCollection.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.body);
    }
  }
}