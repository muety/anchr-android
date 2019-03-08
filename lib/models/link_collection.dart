import 'package:anchr_android/models/link.dart';

class LinkCollection with Comparable {
  final String id;
  final String name;
  final String ownerId;
  final bool shared;
  final List<Link> links;

  const LinkCollection({this.id, this.name, this.ownerId, this.shared, this.links});

  factory LinkCollection.fromJson(Map<String, dynamic> json) {
    List<Link> links = json.containsKey('links')
        ? (json['links'] as List<dynamic>).map((l) => Link.fromJson(l)).toList()
        : List();
    links.sort();

    return LinkCollection(
        id: json['_id'],
        name: json['name'],
        ownerId: json.containsKey('owner') ? json['owner'] : null,
        shared: json.containsKey('shared') ? json['shared'] : null,
        links: links
    );
  }

  @override
  int compareTo(other) {
    if (!(other is LinkCollection)) return -1;
    return name.compareTo((other as LinkCollection).name);
  }
}
