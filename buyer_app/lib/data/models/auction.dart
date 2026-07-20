import 'product.dart';

class Auction {
  final int id;
  final Product product;
  final double currentPrice;
  final DateTime endTime;
  final List<Bid> bidHistory;
  final String status;
  final String? winner;

  Auction({
    required this.id,
    required this.product,
    required this.currentPrice,
    required this.endTime,
    this.bidHistory = const [],
    this.status = 'live',
    this.winner,
  });
}

class Bid {
  final String bidder;
  final double amount;
  final DateTime time;

  Bid({required this.bidder, required this.amount, required this.time});
}
