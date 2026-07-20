class Order {
  final int id;
  final String orderNumber;
  final String status;
  final double total;
  final DateTime createdAt;

  Order({required this.id, required this.orderNumber, required this.status, required this.total, required this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['order_number'],
      status: json['status'],
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
