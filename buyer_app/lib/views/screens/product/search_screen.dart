import 'package:buyer_app/core/localization/string_extension.dart';
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
          decoration: InputDecoration(
            hintText: 'Search products...'.tr(context),
            border: InputBorder.none,
          ),
          onSubmitted: _search,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
        ],
      ),
      body: provider.loading
          ? Center(child: CircularProgressIndicator())
          : provider.products.isNotEmpty
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.filter_list),
                              label: Text('Filter'.tr(context)),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.sort),
                              label: Text('Sort'.tr(context)),
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
                                  : Icon(Icons.image),
                            ),
                            title: Text(product.name),
                            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: {'productId': product.id}),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Text('Recent Searches'.tr(context), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
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
                    SizedBox(height: 24),
                    Text('Popular Searches'.tr(context), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
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
