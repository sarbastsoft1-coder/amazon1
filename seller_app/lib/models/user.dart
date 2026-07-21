class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final int? storeId;
  final String? phone;
  final String? address;
  final Map<String, dynamic>? store;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.storeId,
    this.phone,
    this.address,
    this.store,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      storeId: json['store'] != null ? json['store']['id'] : null,
      phone: json['phone'],
      address: json['address'],
      store: json['store'],
    );
  }
}
