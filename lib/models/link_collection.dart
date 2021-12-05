import 'package:anchr_android/models/link.dart';

class LinkCollection with Comparable<LinkCollection> {
  String id;
  String name;
  List<Link> links;

  LinkCollection({this.id, this.name, this.links});

  factory LinkCollection.fromJson(Map<String, dynamic> json) {
    List<Link> links = json.containsKey('links') ? (json['links'] as List<Map<String, dynamic>>).map((l) => Link.fromJson(l)).toList() : [];
    links.sort();

    return LinkCollection(
        id: json['_id'],
        name: json['name'],
        links: links);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'links': links.map((l) => l.toJson())};
  }

  @override
  int compareTo(other) {
    if (other is! LinkCollection) return -1;
    return name.compareTo((other).name);
  }
}
