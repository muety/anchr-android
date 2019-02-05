import 'package:http/http.dart' as http;

abstract class ApiService {
  static const String _apiUrl = "http://192.168.84.84:8080";

  Future<http.Response> get(String resourcePath) {
    return http.get(_apiUrl + resourcePath);
  }
}