import 'package:http/http.dart' as http;

abstract class ApiService {
  static const String _apiUrl = "http://ferdinand-muetsch.de:3005/api";

  Future<http.Response> get(String resourcePath) {
    const headers = {
      'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJsb2NhbCI6eyJwYXNzd29yZCI6IiQyYSQwOCRzTjUuaXc1SkpBajRwTVBPTDdWYkZ1LkszemRSYk9GYkgxODNqRzUyZnlRZjVVS2kubm1zRyIsImVtYWlsIjoidWVkc2ZAc3R1ZGVudC5raXQuZWR1In0sInN0cmF0ZWd5IjoibG9jYWwiLCJpYXQiOjE1NDk1OTEyMjUsImV4cCI6MTU1MjE4MzIyNX0.iW96GG2Sy8cx0xWSX_AU_I2JTGyQDTPhoaq3nktivqo'
    };
    return http.get(_apiUrl + resourcePath, headers: headers);
  }
}