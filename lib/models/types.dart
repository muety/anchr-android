import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/link_collection.dart';

typedef Future<dynamic> DeleteLink(Link link);
typedef Future<dynamic> DeleteCollection(LinkCollection collection);
typedef Future<dynamic> AddCollection(String name);
typedef Future<dynamic> OnLogout();
typedef OnUnauthorized();