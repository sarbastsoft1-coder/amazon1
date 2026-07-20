import 'package:flutter/material.dart';
import '../../config/theme.dart';

class AuctionsScreen extends StatelessWidget {
  const AuctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auctions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAuctionTile('Vintage Camera', 'Live', 150.00, '02:45:12'),
          _buildAuctionTile('Gaming Mouse', 'Upcoming', 45.00, 'Starts in 2 days'),
          _buildAuctionTile('Bluetooth Speaker', 'Finished', 60.00, 'Ended'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAuctionTile(String name, String status, double price, String time) {
    Color statusColor;
    switch (status) {
      case 'Live':
        statusColor = Colors.red;
        break;
      case 'Upcoming':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.gavel)),
        title: Text(name),
        subtitle: Text(time),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
            Chip(label: Text(status), backgroundColor: statusColor.withValues(alpha: 0.1), labelStyle: TextStyle(color: statusColor, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
