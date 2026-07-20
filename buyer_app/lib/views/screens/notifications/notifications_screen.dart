import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../data/models/notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      NotificationItem(id: 1, title: 'Order Shipped', body: 'Your order #123 has been shipped.', type: 'order', createdAt: DateTime.now()),
      NotificationItem(id: 2, title: 'Flash Sale', body: '50% off on electronics today only!', type: 'offer', createdAt: DateTime.now().subtract(const Duration(hours: 2))),
      NotificationItem(id: 3, title: 'Auction Ending', body: 'Your watched auction ends in 10 minutes.', type: 'auction', createdAt: DateTime.now().subtract(const Duration(hours: 5))),
      NotificationItem(id: 4, title: 'New Message', body: 'You have a new message from TechStore.', type: 'message', createdAt: DateTime.now().subtract(const Duration(days: 1))),
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
                backgroundColor: _colorForType(n.type),
                child: Icon(_iconForType(n.type), color: Colors.white),
              ),
              title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(n.body),
              trailing: Text(_formatTime(n.createdAt), style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          );
        },
      ),
    );
  }

  IconData _iconForType(String type) {
    return switch (type) {
      'order' => Icons.receipt,
      'offer' => Icons.local_offer,
      'auction' => Icons.gavel,
      'message' => Icons.message,
      _ => Icons.notifications,
    };
  }

  Color _colorForType(String type) {
    return switch (type) {
      'order' => AppTheme.primaryColor,
      'offer' => Colors.red,
      'auction' => Colors.purple,
      'message' => Colors.blue,
      _ => Colors.grey,
    };
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
