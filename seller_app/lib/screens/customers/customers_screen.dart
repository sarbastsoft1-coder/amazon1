import 'package:flutter/material.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = [
      {'name': 'John Doe', 'email': 'john@example.com', 'orders': 5},
      {'name': 'Jane Smith', 'email': 'jane@example.com', 'orders': 3},
      {'name': 'Bob Johnson', 'email': 'bob@example.com', 'orders': 8},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(child: Text((customer['name'] as String)[0])),
              title: Text(customer['name'] as String),
              subtitle: Text('${customer['email']} • ${customer['orders']} orders'),
              trailing: IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
