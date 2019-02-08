class Link {
  final String url;
  final String description;
  final DateTime date;

  const Link({this.url, this.description, this.date});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
        url: json['url'],
        description: json['description'],
        date: DateTime.parse(json['date'])
    );
  }
}