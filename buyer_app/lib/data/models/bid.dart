class Bid {
  final int id;
  final int productId;
  final String userId;
  final String userName;
  final double amount;
  final DateTime createdAt;

  Bid({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.createdAt,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'],
      productId: json['product_id'],
      userId: json['user_id'].toString(),
      userName: json['user_name'] ?? 'User',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
