import 'dart:convert';

import 'package:anchr_android/objects/link_collection.dart';
import 'package:anchr_android/services/api_service.dart';

class CollectionService extends ApiService {
  static final CollectionService _instance = new CollectionService._internal();

  factory CollectionService() {
    return _instance;
  }

  CollectionService._internal();

  Future<LinkCollection> getCollection(String id) async {
    final res = await super.get('/$id');
    if (res.statusCode == 200) {
      return LinkCollection.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.body);
    }
  }
}