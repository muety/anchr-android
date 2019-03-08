import 'dart:async';

abstract class Cache<T> {
  Future<T> getFromCache(String key);
  putToCache(String key, T object);
}