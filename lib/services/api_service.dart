import 'package:http/http.dart' as http;

abstract class ApiService {
  static const String _apiUrl = "http://ferdinand-muetsch.de:3005/api";

  Future<http.Response> get(String resourcePath) {
    return http.get(_apiUrl + resourcePath, headers: _getHeaders());
  }

  Future<http.Response> delete(String resourcePath) {
    return http.delete(_apiUrl + resourcePath, headers: _getHeaders());
  }

  Map<String, String> _getHeaders() {
    return {
      'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJsb2NhbCI6eyJwYXNzd29yZCI6IiQyYSQwOCRzTjUuaXc1SkpBajRwTVBPTDdWYkZ1LkszemRSYk9GYkgxODNqRzUyZnlRZjVVS2kubm1zRyIsImVtYWlsIjoidWVkc2ZAc3R1ZGVudC5raXQuZWR1In0sInN0cmF0ZWd5IjoibG9jYWwiLCJpYXQiOjE1NDk2MDcwMzQsImV4cCI6MTU1MjE5OTAzNH0.9QMGtJPiM0Wq0QmgrHt4V3Wf89-XdW1_cc_Af1pn0Ts'
    };
  }
}