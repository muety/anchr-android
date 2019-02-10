import 'package:anchr_android/models/link.dart';

typedef Future<dynamic> LoadCollections();
typedef Future<dynamic> LoadCollection(String id);
typedef Future<dynamic> DeleteLink(Link link);
typedef void ShowSnackbar(String text);

class AnchrActions {
  final LoadCollections loadCollections;
  final LoadCollection loadCollection;
  final DeleteLink deleteLink;
  final ShowSnackbar showSnackbar;

  AnchrActions({this.loadCollections, this.loadCollection, this.deleteLink, this.showSnackbar});
}