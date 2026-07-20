import 'package:flutter/material.dart';
import '../../config/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'title': 'New Order', 'body': 'You received a new order #123.', 'type': 'order'},
      {'title': 'Amazon Sync Complete', 'body': 'Inventory sync completed successfully.', 'type': 'sync'},
      {'title': 'Payment Received', 'body': '\$250.00 has been added to your wallet.', 'type': 'payment'},
      {'title': 'New Review', 'body': 'A buyer left a 5-star review.', 'type': 'review'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _colorForType(n['type'] as String),
                child: Icon(_iconForType(n['type'] as String), color: Colors.white),
              ),
              title: Text(n['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(n['body'] as String),
            ),
          );
        },
      ),
    );
  }

  IconData _iconForType(String type) {
    return switch (type) {
      'order' => Icons.receipt,
      'sync' => Icons.sync,
      'payment' => Icons.payment,
      'review' => Icons.star,
      _ => Icons.notifications,
    };
  }

  Color _colorForType(String type) {
    return switch (type) {
      'order' => AppTheme.secondaryColor,
      'sync' => Colors.blue,
      'payment' => Colors.green,
      'review' => Colors.amber,
      _ => Colors.grey,
    };
  }
}
