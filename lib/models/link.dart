class Link with Comparable {
  final String id;
  final String url;
  final String description;
  final DateTime date;

  const Link({this.id, this.url, this.description, this.date});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
        id: json['_id'], url: json['url'], description: json['description'], date: DateTime.parse(json['date'])
    );
  }

  @override
  int compareTo(other) {
    if (!(other is Link)) return -1;
    return (this.date.compareTo((other as Link).date)) * -1;
  }
}
