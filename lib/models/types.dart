import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/link_collection.dart';

typedef DeleteLink = Function(Link link);
typedef DeleteCollection = Function(LinkCollection collection);
typedef AddCollection = Function(String name);
typedef OnLogout = Function();
typedef OnUnauthorized = Function();