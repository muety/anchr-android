import 'dart:convert';

import 'package:anchr_android/models/exception.dart';
import 'package:anchr_android/models/types.dart';
import 'package:anchr_android/services/api_service.dart';

class AuthService extends ApiService {
  static final AuthService _instance = new AuthService._internal();

  factory AuthService({String token, OnUnauthorized onUnauthorized}) {
    _instance.safeToken = token;
    _instance.safeOnUnauthorized = onUnauthorized;
    return _instance;
  }

  AuthService._internal();

  Future<String> login(String email, String password) async {
    final data = {'email': email, 'password': password};
    final res = await super.post('/auth/token', data);
    if (res.statusCode == 400 || res.statusCode == 401) {
      throw UnauthorizedException();
    } else if (res.statusCode != 200) {
      throw WebServiceException(message: res.body);
    }
    return json.decode(res.body)['token'];
  }

  Future<String> renew() async {
    final res = await super.post('/auth/renew', {});
    if (res.statusCode == 401) {
      // Status was already checked by middleware in super class. This caused the custom
      // onAuthorized callback to be triggered, which should have called logout().
      // However, the 401 response is still forwarded by post() to here.
      throw UnauthorizedException();
    } else if (res.statusCode != 200) {
      throw WebServiceException(message: res.body);
    }
    return json.decode(res.body)['token'];
  }
}
