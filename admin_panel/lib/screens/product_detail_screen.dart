import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductsProvider>().loadProduct(widget.productId);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();
    final product = provider.selectedProduct;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: provider.loading || product == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(product),
                  const SizedBox(height: 24),
                  _buildActions(context, provider, product),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(Product product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Slug: ${product.slug}'),
            const SizedBox(height: 8),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Stock: ${product.stock}'),
            const SizedBox(height: 8),
            Text('SKU: ${product.sku ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Status: ${product.status.toUpperCase()}'),
            const SizedBox(height: 8),
            Text('Active: ${product.isActive ? 'Yes' : 'No'}'),
            const SizedBox(height: 8),
            Text('Store: ${product.store?['name'] ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Category: ${product.category?['name'] ?? 'Unknown'}'),
            const SizedBox(height: 8),
            if (product.description != null && product.description!.isNotEmpty)
              Text('Description: ${product.description}'),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, ProductsProvider provider, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (product.status == 'pending')
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Review Notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            if (product.status == 'pending') ...[
              ElevatedButton.icon(
                onPressed: () => _approve(provider, product.id),
                icon: const Icon(Icons.check),
                label: const Text('Approve'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              ElevatedButton.icon(
                onPressed: () => _reject(provider, product.id),
                icon: const Icon(Icons.close),
                label: const Text('Reject'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
            ElevatedButton.icon(
              onPressed: () => _delete(context, provider, product.id),
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _approve(ProductsProvider provider, int id) async {
    final ok = await provider.approveProduct(id, notes: _notesController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Product approved.' : 'Failed to approve product.')));
    }
  }

  Future<void> _reject(ProductsProvider provider, int id) async {
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide rejection notes.')));
      return;
    }
    final ok = await provider.rejectProduct(id, notes: _notesController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Product rejected.' : 'Failed to reject product.')));
    }
  }

  Future<void> _delete(BuildContext screenContext, ProductsProvider provider, int id) async {
    final confirmed = await showDialog<bool>(
      context: screenContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      final ok = await provider.deleteProduct(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Product deleted.' : 'Failed to delete product.')));
        if (ok) Navigator.of(context).pop();
      }
    }
  }
}
