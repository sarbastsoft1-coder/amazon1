import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class AuctionDetailsScreen extends StatefulWidget {
  final int auctionId;
  const AuctionDetailsScreen({super.key, required this.auctionId});

  @override
  State<AuctionDetailsScreen> createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends State<AuctionDetailsScreen> {
  double _currentPrice = 75.00;
  final List<Map<String, dynamic>> _bidHistory = [
    {'bidder': 'John', 'amount': 75.00, 'time': '10:30 AM'},
    {'bidder': 'Alice', 'amount': 70.00, 'time': '10:25 AM'},
    {'bidder': 'Bob', 'amount': 65.00, 'time': '10:20 AM'},
  ];

  void _placeBid() {
    setState(() {
      _currentPrice += 5;
      _bidHistory.insert(0, {'bidder': 'You', 'amount': _currentPrice, 'time': 'Just now'});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bid placed successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auction Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              child: const Icon(Icons.gavel, size: 80, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Auction Item #${widget.auctionId}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${_currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Ends in: 02:45:12',
                  style: TextStyle(fontSize: 16, color: Colors.red[700], fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Bid History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._bidHistory.map((bid) => ListTile(
                  leading: CircleAvatar(child: Text(bid['bidder'][0] as String)),
                  title: Text(bid['bidder'] as String),
                  subtitle: Text(bid['time'] as String),
                  trailing: Text(
                    '\$${(bid['amount'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _placeBid,
            child: const Text('Place Bid'),
          ),
        ),
      ),
    );
  }
}
