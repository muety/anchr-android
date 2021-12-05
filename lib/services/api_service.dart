import 'dart:convert';

import 'package:anchr_android/models/types.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class ApiService {
  static String _apiUrl;
  OnUnauthorized _onUnauthorized;
  String _token;

  ApiService();

  String get apiUrl => _apiUrl;

  set apiUrl(String url) => _apiUrl = url;

  set token(String token) => _token = token;

  set safeToken(String token) => _token = token ?? _token;

  set onUnauthorized(OnUnauthorized cb) => _onUnauthorized = cb;

  set safeOnUnauthorized(OnUnauthorized cb) => _onUnauthorized = cb ?? _onUnauthorized;

  Future<http.Response> head(String resourcePath) {
    return http.head(Uri.parse(_apiUrl + resourcePath), headers: _getHeaders()).then((res) => _checkUnauthorized(res));
  }

  Future<http.Response> get(String resourcePath) {
    return http.get(Uri.parse(_apiUrl + resourcePath), headers: _getHeaders()).then((res) => _checkUnauthorized(res));
  }

  Future<http.Response> post(String resourcePath, Map<String, dynamic> data) {
    return http.post(Uri.parse(_apiUrl + resourcePath), headers: _getHeaders(), body: json.encode(data)).then((res) => _checkUnauthorized(res));
  }

  Future<http.Response> delete(String resourcePath) {
    return http.delete(Uri.parse(_apiUrl + resourcePath), headers: _getHeaders()).then((res) => _checkUnauthorized(res));
  }

  Map<String, String> _getHeaders() {
    return {'Authorization': 'Bearer $_token', 'Content-Type': 'application/json'};
  }

  Future<Response> _checkUnauthorized(Response res) {
    if (res.statusCode == 401 && _onUnauthorized != null) {
      _onUnauthorized();
    }
    return Future.value(res);
  }
}
