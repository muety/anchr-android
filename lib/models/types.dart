import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/link_collection.dart';

typedef DeleteLink(Link link);
typedef DeleteCollection(LinkCollection collection);
typedef AddCollection(String name);
typedef OnLogout();
typedef OnUnauthorized();