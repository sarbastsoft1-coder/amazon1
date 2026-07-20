import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../data/providers/product_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _recent = ['Headphones', 'Shoes', 'Laptop', 'Watch'];
  final _popular = ['iPhone', 'Nike', 'Samsung', 'Backpack'];

  void _search(String q) {
    context.read<ProductProvider>().fetchProducts(query: q);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
          onSubmitted: _search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
        ],
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.products.isNotEmpty
              ? Column(
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
                      child: ListView.builder(
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: product.images.isNotEmpty
                                  ? Image.network(product.images.first, fit: BoxFit.cover)
                                  : const Icon(Icons.image),
                            ),
                            title: Text(product.name),
                            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: {'productId': product.id}),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _recent.map((s) => ActionChip(
                        label: Text(s),
                        onPressed: () {
                          _controller.text = s;
                          _search(s);
                        },
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text('Popular Searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _popular.map((s) => ActionChip(
                        label: Text(s),
                        onPressed: () {
                          _controller.text = s;
                          _search(s);
                        },
                      )).toList(),
                    ),
                  ],
                ),
    );
  }
}
