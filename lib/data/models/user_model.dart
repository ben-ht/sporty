class UserModel {
  final String? uid;
  final String username;
  final String name;
  final String surname;
  final String email;

  UserModel({
    this.uid,
    required this.username,
    required this.name,
    required this.surname,
    required this.email
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'surname': surname,
      'email': email
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      username: map['username'],
      name: map['name'],
      surname: map['surname'],
      email: map['email']
    );
  }
}
