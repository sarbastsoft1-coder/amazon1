import 'product.dart';

class Order {
  final int id;
  final String orderNumber;
  final String status;
  final double total;
  final double subtotal;
  final double tax;
  final double shipping;
  final List<OrderItem> items;
  final DateTime createdAt;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.total,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.items,
    required this.createdAt,
    this.trackingNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['order_number'],
      status: json['status'],
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      tax: double.tryParse(json['tax'].toString()) ?? 0.0,
      shipping: double.tryParse(json['shipping'].toString()) ?? 0.0,
      items: (json['items'] as List? ?? []).map((i) => OrderItem.fromJson(i)).toList(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      trackingNumber: json['tracking_number'],
    );
  }
}

class OrderItem {
  final int id;
  final Product product;
  final int quantity;
  final double price;

  OrderItem({required this.id, required this.product, required this.quantity, required this.price});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }
}
