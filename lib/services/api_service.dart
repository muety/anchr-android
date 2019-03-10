import 'dart:convert';

import 'package:anchr_android/models/types.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class ApiService {
  static const String _apiUrl = "https://anchr.io/api";
  OnUnauthorized _onUnauthorized;
  String _token;

  ApiService();

  set token(String token) => this._token = token;

  set safeToken(String token) => this._token = token ?? this._token;

  set onUnauthorized(OnUnauthorized cb) => this._onUnauthorized = cb;

  set safeOnUnauthorized(OnUnauthorized cb) => this._onUnauthorized = cb ?? this._onUnauthorized;

  Future<http.Response> get(String resourcePath) {
    return http.get(_apiUrl + resourcePath, headers: _getHeaders()).then((res) => _checkUnauthorized(res));
  }

  Future<http.Response> post(String resourcePath, Map<String, dynamic> data) {
    return http.post(_apiUrl + resourcePath, headers: _getHeaders(), body: json.encode(data)).then((res) => _checkUnauthorized(res));
  }

  Future<http.Response> delete(String resourcePath) {
    return http.delete(_apiUrl + resourcePath, headers: _getHeaders()).then((res) => _checkUnauthorized(res));
  }

  Map<String, String> _getHeaders() {
    return {'Authorization': 'Bearer $_token', 'Content-Type': 'application/json'};
  }

  _checkUnauthorized(Response res) {
    if (res.statusCode == 401 && _onUnauthorized != null) {
      _onUnauthorized();
    }
    return res;
  }
}
