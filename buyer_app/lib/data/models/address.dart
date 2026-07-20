class Address {
  final int? id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String phone;
  final bool isDefault;

  Address({
    this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    this.country = 'US',
    required this.phone,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
      country: json['country'] ?? 'US',
      phone: json['phone'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'phone': phone,
      'is_default': isDefault,
    };
  }
}
