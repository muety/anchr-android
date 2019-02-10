import 'package:anchr_android/models/link.dart';
import 'package:flutter/material.dart';

typedef Future<dynamic> LoadCollections({BuildContext context});
typedef Future<dynamic> LoadCollection(String id, {BuildContext context});
typedef Future<dynamic> DeleteLink(Link link, {BuildContext context});

class AnchrActions {
  final LoadCollections loadCollections;
  final LoadCollection loadCollection;
  final DeleteLink deleteLink;

  AnchrActions({this.loadCollections, this.loadCollection, this.deleteLink});
}