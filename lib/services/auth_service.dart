import 'dart:convert';

import 'package:anchr_android/services/api_service.dart';

class AuthService extends ApiService {
  static final AuthService _instance = new AuthService._internal();

  factory AuthService({String token}) {
    _instance.safeToken = token;
    return _instance;
  }

  AuthService._internal();

  Future<String> login(String email, String password) async {
    final data = {'email': email, 'password': password};
    final res = await super.post('/auth/token', data);
    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
    return json.decode(res.body)['token'];
  }

  Future<String> renew() async {
    final res = await super.post('/auth/renew', {});
    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
    return json.decode(res.body)['token'];
  }
}
