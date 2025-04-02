class User {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String role; // 'instructor' o 'aprendiz'

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      lastName: map['lastName'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}