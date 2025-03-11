class Sport {
  final int? id;
  final String name;

  Sport({this.id, required this.name});

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['id'],
      name: json['name'],
    );
  }
}