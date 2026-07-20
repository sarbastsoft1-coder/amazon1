import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../data/providers/product_provider.dart';
import '../../widgets/common/widgets.dart';

class ProductListScreen extends StatefulWidget {
  final String title;
  const ProductListScreen({super.key, required this.title});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sort),
                    label: const Text('Sort'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.products.isEmpty
                    ? const EmptyState(message: 'No products found')
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: {'productId': product.id}),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
