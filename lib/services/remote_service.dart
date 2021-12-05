import 'dart:convert';

import 'package:anchr_android/services/api_service.dart';
import 'package:f_logs/f_logs.dart';

class RemoteService extends ApiService {
  static final RemoteService _instance = RemoteService._internal();

  factory RemoteService() {
    return _instance;
  }

  RemoteService._internal();

  Future<String> fetchPageTitle(String url) async {
    const String defaultVal = '';
    try {
      final res = await super.get('/remote/page?url=$url');
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data.containsKey('title')) return data['title'];
        throw Exception();
      }
      throw Exception();
    } catch (e) {
      FLog.error(text: "Failed to fetch page title for $url.", exception: e);
      return defaultVal;
    }
  }
}