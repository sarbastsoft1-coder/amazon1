import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/providers/wishlist_provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../../widgets/common/widgets.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: !context.watch<AuthProvider>().isAuthenticated
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_rounded, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Please login to view your wishlist', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: const Text('Login'),
                  ),
                ],
              ),
            )
          : wishlist.items.isEmpty
              ? const EmptyState(message: 'Your wishlist is empty', icon: Icons.favorite_border)
              : ListView.builder(
                  itemCount: wishlist.items.length,
                  itemBuilder: (context, index) {
                    final product = wishlist.items[index];
                    return Dismissible(
                      key: ValueKey(product.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => wishlist.remove(product),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: product.images.isNotEmpty
                                ? Image.network(product.images.first, fit: BoxFit.cover)
                                : const Icon(Icons.image),
                          ),
                          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.primaryColor)),
                          trailing: SizedBox(
                            width: 96,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.shopping_cart, color: AppTheme.primaryColor),
                                  onPressed: () => context.read<CartProvider>().add(product),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => wishlist.remove(product),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: {'productId': product.id}),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
