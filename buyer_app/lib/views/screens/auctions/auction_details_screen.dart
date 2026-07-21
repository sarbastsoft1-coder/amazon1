import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../data/models/product.dart';
import '../../../data/providers/product_provider.dart';
import '../../widgets/common/countdown_timer.dart';

class AuctionDetailsScreen extends StatefulWidget {
  final int productId;
  const AuctionDetailsScreen({super.key, required this.productId});

  @override
  State<AuctionDetailsScreen> createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends State<AuctionDetailsScreen> {
  final TextEditingController _bidController = TextEditingController();
  final List<Map<String, dynamic>> _bidHistory = [
    {'bidder': 'John', 'amount': 120.00, 'time': '10:30 AM'},
    {'bidder': 'Alice', 'amount': 110.00, 'time': '10:25 AM'},
    {'bidder': 'Bob', 'amount': 100.00, 'time': '10:20 AM'},
  ];

  Product? _getProduct() {
    final products = context.read<ProductProvider>().products;
    try {
      return products.firstWhere((p) => p.id == widget.productId);
    } catch (_) {
      return null;
    }
  }

  void _placeBid(Product product) {
    final amount = double.tryParse(_bidController.text) ?? 0.0;
    final current = product.currentBid ?? product.startingBid ?? 0.0;
    final minIncrement = product.minimumIncrement ?? 1.0;

    if (amount < current + minIncrement) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bid must be at least \$${(current + minIncrement).toStringAsFixed(2)}')),
      );
      return;
    }

    setState(() {
      _bidHistory.insert(0, {'bidder': 'You', 'amount': amount, 'time': 'Just now'});
      _bidController.clear();
      // In a real app, this would update the backend and real-time state.
      // Here we just mock it.
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bid placed successfully!'.tr(context))),
    );
  }

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = _getProduct();
    if (product == null) {
      return Scaffold(appBar: AppBar(title: Text('Error')), body: Center(child: Text('Product not found')));
    }

    final isEnded = product.status == 'closed';
    final isUpcoming = product.status == 'upcoming';
    final currentPrice = _bidHistory.isNotEmpty ? _bidHistory.first['amount'] : (product.currentBid ?? product.startingBid ?? 0);

    return Scaffold(
      appBar: AppBar(title: Text('Auction Details'.tr(context))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: product.images.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(product.images.first, fit: BoxFit.cover))
                  : Icon(Icons.gavel, size: 80, color: AppTheme.primaryColor),
            ),
            SizedBox(height: 16),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${currentPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            SizedBox(height: 16),
            AuctionCountdownTimer(auctionStart: product.auctionStart, auctionEnd: product.auctionEnd),
            SizedBox(height: 24),
            Text('Bid History'.tr(context),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ..._bidHistory.map((bid) => ListTile(
                  leading: CircleAvatar(child: Text(bid['bidder'][0] as String)),
                  title: Text(bid['bidder'] as String),
                  subtitle: Text(bid['time'] as String),
                  trailing: Text(
                    '\$${(bid['amount'] as double).toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: isEnded || isUpcoming ? Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isEnded ? 'Auction Ended\nWinner: ${product.winnerId ?? 'Unknown'}' : 'Auction has not started yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ) : Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bidController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _placeBid(product),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Place Bid'.tr(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

