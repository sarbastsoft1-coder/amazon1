import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #$orderId', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.headphones),
                title: Text('Wireless Headphones'),
                subtitle: Text('Quantity: 1'),
                trailing: Text('\$99.99'),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Customer'),
            const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('John Doe'),
                subtitle: Text('john@example.com'),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Shipping Address'),
            const Card(
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text('123 Main St'),
                subtitle: Text('New York, NY 10001'),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Update Status'),
            Wrap(
              spacing: 8,
              children: ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled']
                  .map((s) => ActionChip(label: Text(s), onPressed: () {}))
                  .toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print),
                label: const Text('Print Invoice'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
