
import 'package:anchr_android/models/link.dart';

class LinkCollection {
  final String id;
  final String name;
  final String ownerId;
  final bool shared;
  final List<Link> links;

  const LinkCollection({this.id, this.name, this.ownerId, this.shared, this.links});

  factory LinkCollection.fromJson(Map<String, dynamic> json) {
        return LinkCollection(
              id: json['_id'],
              name: json['name'],
              ownerId: json.containsKey('owner') ? json['owner'] : null,
              shared: json.containsKey('shared') ? json['shared'] : null,
              links: json.containsKey('links') ? (json['links'] as List<dynamic>).map((l) => Link.fromJson(l)).toList() : new List()
    );
  }
}