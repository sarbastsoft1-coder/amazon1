class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final int? storeId;

  User({required this.id, required this.name, required this.email, required this.role, this.storeId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      storeId: json['store'] != null ? json['store']['id'] : null,
    );
  }
}
