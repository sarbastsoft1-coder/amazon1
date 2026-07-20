import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFilterChips(),
          const SizedBox(height: 16),
          _buildProductTile(context, 'Wireless Headphones', 'Active', 50, 99.99),
          _buildProductTile(context, 'Smart Watch', 'Active', 30, 199.99),
          _buildProductTile(context, 'Running Shoes', 'Out of Stock', 0, 79.99),
          _buildProductTile(context, 'Laptop Stand', 'Draft', 75, 49.99),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addProduct),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Active', 'Draft', 'Out of Stock', 'Archived'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(label: Text(filters[index])),
          );
        },
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, String name, String status, int stock, double price) {
    Color statusColor;
    switch (status) {
      case 'Active':
        statusColor = Colors.green;
        break;
      case 'Draft':
        statusColor = Colors.grey;
        break;
      case 'Out of Stock':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.image),
        ),
        title: Text(name),
        subtitle: Text('Stock: $stock'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
            Chip(label: Text(status), backgroundColor: statusColor.withValues(alpha: 0.1), labelStyle: TextStyle(color: statusColor, fontSize: 10)),
          ],
        ),
        onTap: () => Navigator.pushNamed(context, AppRoutes.editProduct, arguments: {'productId': 1}),
      ),
    );
  }
}
