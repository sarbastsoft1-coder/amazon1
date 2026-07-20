import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    if (provider.loading) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount: provider.orders.length,
      itemBuilder: (context, index) {
        final order = provider.orders[index];
        return ListTile(
          title: Text(order.orderNumber),
          subtitle: Text('Status: ${order.status}'),
          trailing: Text('\$${order.total.toStringAsFixed(2)}'),
          onTap: () => _showStatusDialog(context, order.id, order.status),
        );
      },
    );
  }

  void _showStatusDialog(BuildContext context, int orderId, String current) {
    final statuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses
              .map((s) => ListTile(
                    title: Text(s),
                    selected: s == current,
                    onTap: () async {
                      await context.read<OrderProvider>().updateStatus(orderId, s);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
