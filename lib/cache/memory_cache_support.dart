import 'dart:async';
import 'dart:collection';

import 'package:anchr_android/cache/cache.dart';

mixin MemoryCacheSupport<T> implements Cache<T> {
  final map = HashMap<String, T>();

  @override
  Future<T> getFromCache(String key) {
    return Future.value(map[key]);
  }

  @override
  putToCache(String key, object) {
    map[key] = object;
  }
}