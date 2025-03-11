class Sport {
  final int? id;
  final String name;

  Sport({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Sport.fromMap(Map<String, dynamic> map) {
    return Sport(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  String toString() {
    return 'Sport{id: $id, name: $name}';
  }

  // factory Sport.fromJson(Map<String, dynamic> json) {
  //   return Sport(
  //     id: json['id'],
  //     name: json['name'],
  //   );
  // }
}