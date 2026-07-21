import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    if (provider.loading) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        final product = provider.products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('Stock: ${product.stock} - \$${product.price.toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () => _showForm(context, product: product)),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => provider.deleteProduct(product.id),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showForm(BuildContext context, {Product? product}) {
    showDialog(context: context, builder: (_) => ProductFormDialog(product: product));
  }
}

class ProductFormDialog extends StatefulWidget {
  final Product? product;
  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  late final _name = TextEditingController(text: widget.product?.name);
  late final _description = TextEditingController(text: widget.product?.description);
  late final _price = TextEditingController(text: widget.product?.price.toString());
  late final _stock = TextEditingController(text: widget.product?.stock.toString());
  late final _sku = TextEditingController(text: widget.product?.sku ?? '');
  late final _asin = TextEditingController(text: widget.product?.amazonAsin ?? '');
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    final data = {
      'store_id': 1,
      'name': _name.text,
      'description': _description.text,
      'price': double.tryParse(_price.text) ?? 0,
      'stock': int.tryParse(_stock.text) ?? 0,
      'sku': _sku.text,
      'amazon_asin': _asin.text,
      'category_id': null,
    };

    final provider = context.read<ProductProvider>();
    final ok = widget.product == null
        ? await provider.createProduct(data, [])
        : await provider.updateProduct(widget.product!.id, data, []);

    setState(() => _saving = false);
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _description, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: _price, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: _stock, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
            TextField(controller: _sku, decoration: const InputDecoration(labelText: 'SKU')),
            TextField(controller: _asin, decoration: const InputDecoration(labelText: 'Amazon ASIN')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _saving ? null : _save, child: _saving ? const CircularProgressIndicator() : const Text('Save')),
      ],
    );
  }
}
