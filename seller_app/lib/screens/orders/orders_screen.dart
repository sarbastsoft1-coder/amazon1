import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'number': 'ORD-001', 'status': 'Pending', 'total': 99.99},
      {'number': 'ORD-002', 'status': 'Processing', 'total': 199.99},
      {'number': 'ORD-003', 'status': 'Shipped', 'total': 79.99},
      {'number': 'ORD-004', 'status': 'Delivered', 'total': 149.99},
      {'number': 'ORD-005', 'status': 'Cancelled', 'total': 49.99},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _statusColor(order['status'] as String),
                child: const Icon(Icons.receipt, color: Colors.white),
              ),
              title: Text(order['number'] as String),
              subtitle: Text('Status: ${order['status']}'),
              trailing: Text('\$${(order['total'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
              onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetails, arguments: {'orderId': index + 1}),
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'Pending' => Colors.orange,
      'Processing' => Colors.blue,
      'Shipped' => Colors.purple,
      'Delivered' => Colors.green,
      'Cancelled' => Colors.red,
      _ => Colors.grey,
    };
  }
}
