import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class ApiService {
  static const String _apiUrl = "http://ferdinand-muetsch.de:3005/api";
  String _token;

  ApiService();

  set token(String token) => this._token = token;

  set safeToken(String token) => this._token = token ?? this._token;

  Future<http.Response> get(String resourcePath) {
    return http.get(_apiUrl + resourcePath, headers: _getHeaders());
  }

  Future<http.Response> post(String resourcePath, Map<String, dynamic> data) {
    return http.post(_apiUrl + resourcePath, headers: _getHeaders(), body: json.encode(data));
  }

  Future<http.Response> delete(String resourcePath) {
    return http.delete(_apiUrl + resourcePath, headers: _getHeaders());
  }

  Map<String, String> _getHeaders() {
    return {'Authorization': 'Bearer $_token', 'Content-Type': 'application/json'};
  }
}
