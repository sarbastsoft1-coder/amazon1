import 'package:buyer_app/core/localization/string_extension.dart';
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
      appBar: AppBar(title: Text('Wishlist'.tr(context))),
      body: !context.watch<AuthProvider>().isAuthenticated
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_rounded, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Please login to view your wishlist'.tr(context), style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: Text('Login'.tr(context)),
                  ),
                ],
              ),
            )
          : wishlist.items.isEmpty
              ? EmptyState(message: 'Your wishlist is empty', icon: Icons.favorite_border)
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
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => wishlist.remove(product),
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                : Icon(Icons.image),
                          ),
                          title: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(color: AppTheme.primaryColor)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.shopping_cart, color: AppTheme.primaryColor),
                                onPressed: () => context.read<CartProvider>().add(product),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => wishlist.remove(product),
                              ),
                            ],
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
