import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsProvider>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          _buildFilterTabs(provider),
          Expanded(
            child: provider.loading && provider.products.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : provider.products.isEmpty
                    ? const Center(child: Text('No products found.'))
                    : ListView.builder(
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          return ListTile(
                            leading: const Icon(Icons.inventory),
                            title: Text(product.name),
                            subtitle: Text('Store: ${product.store?['name'] ?? 'Unknown'} • Price: \$${product.price.toStringAsFixed(2)}'),
                            trailing: _StatusChip(status: product.status),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(productId: product.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(ProductsProvider provider) {
    final tabs = ['all', 'pending', 'approved', 'rejected'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        children: tabs.map((tab) {
          final isSelected = provider.statusFilter == tab;
          return ChoiceChip(
            label: Text(tab[0].toUpperCase() + tab.substring(1)),
            selected: isSelected,
            onSelected: (_) => provider.loadProducts(status: tab),
          );
        }).toList(),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status.toUpperCase()),
      backgroundColor: color.withAlpha(26),
      labelStyle: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
    );
  }
}
