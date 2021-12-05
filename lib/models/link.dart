class Link with Comparable<Link> {
  String id;
  String url;
  String description;
  DateTime date;

  Link({this.id, this.url, this.description, this.date});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(id: json['_id'], url: json['url'], description: json['description'], date: DateTime.parse(json['date']));
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'url': url, 'description': description, 'date': date.toIso8601String()};
  }

  @override
  int compareTo(other) {
    if (other is! Link) return -1;
    return (date.compareTo((other).date)) * -1;
  }
}
