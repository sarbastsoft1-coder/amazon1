import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../data/models/product.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/providers/wishlist_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  int _selectedImage = 0;

  final _productImages = [Colors.blue, Colors.green, Colors.orange, Colors.purple];

  @override
  Widget build(BuildContext context) {
    final product = Product(
      id: widget.productId,
      name: 'Wireless Headphones',
      slug: 'wireless-headphones',
      description: 'High-quality wireless headphones with noise cancellation and long battery life. Enjoy crystal-clear sound, comfortable ear cushions, and up to 30 hours of playtime on a single charge.',
      price: 99.99,
      comparePrice: 129.99,
      stock: 50,
      sku: 'WH-001',
      images: const [],
      rating: 4.5,
      reviewCount: 128,
      brand: 'Sony',
    );

    final inWishlist = context.watch<WishlistProvider>().isInWishlist(product);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(inWishlist ? Icons.favorite : Icons.favorite_border),
            onPressed: () => context.read<WishlistProvider>().toggle(product),
          ),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _productImages[_selectedImage],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Icon(Icons.image, size: 100, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _productImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedImage = index),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: _productImages[index],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedImage == index ? AppTheme.primaryColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(product.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('In Stock', style: TextStyle(color: Colors.green[800])),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                const SizedBox(width: 12),
                if (product.comparePrice != null)
                  Text(
                    '\$${product.comparePrice!.toStringAsFixed(2)}',
                    style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 16),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(' ${product.rating} (${product.reviewCount} reviews)'),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Description'),
            Text(product.description ?? ''),
            const SizedBox(height: 16),
            _buildSectionTitle('Specifications'),
            _buildSpecifications(),
            const SizedBox(height: 16),
            _buildSectionTitle('Seller Information'),
            _buildSellerInfo(),
            const SizedBox(height: 16),
            _buildSectionTitle('Reviews'),
            _buildReviews(),
            const SizedBox(height: 16),
            _buildSectionTitle('Questions & Answers'),
            _buildQAndA(),
            const SizedBox(height: 16),
            _buildSectionTitle('Similar Products'),
            _buildSimilarProducts(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1),
                  ),
                  Text('$_quantity', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().add(product, quantity: _quantity);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().add(product, quantity: _quantity);
                    Navigator.pushNamed(context, AppRoutes.checkout);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryColor),
                  child: const Text('Buy Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSpecifications() {
    final specs = {
      'Brand': 'Sony',
      'Model': 'WH-1000XM4',
      'Color': 'Black',
      'Battery Life': '30 hours',
      'Connectivity': 'Bluetooth 5.0',
      'Weight': '250g',
    };
    return Column(
      children: specs.entries
          .map((e) => ListTile(
                dense: true,
                title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text(e.value),
              ))
          .toList(),
    );
  }

  Widget _buildSellerInfo() {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.store)),
      title: const Text('TechStore Official'),
      subtitle: const Text('98% positive rating'),
      trailing: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.messages),
        child: const Text('Chat'),
      ),
    );
  }

  Widget _buildReviews() {
    final reviews = [
      {'name': 'John D.', 'rating': 5, 'text': 'Excellent sound quality!'},
      {'name': 'Sarah M.', 'rating': 4, 'text': 'Great but a bit pricey.'},
    ];
    return Column(
      children: reviews
          .map((r) => ListTile(
                leading: CircleAvatar(child: Text((r['name'] as String)[0])),
                title: Row(
                  children: [
                    Text(r['name'] as String),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(
                        r['rating'] as int,
                        (_) => const Icon(Icons.star, size: 14, color: Colors.amber),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(r['text'] as String),
              ))
          .toList(),
    );
  }

  Widget _buildQAndA() {
    return Column(
      children: const [
        ListTile(
          title: Text('Is this compatible with Android?', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Yes, it works with any Bluetooth-enabled device.'),
        ),
        ListTile(
          title: Text('Does it come with a warranty?', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Yes, it comes with a 1-year manufacturer warranty.'),
        ),
      ],
    );
  }

  Widget _buildSimilarProducts() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Icon(Icons.headphones, size: 40)),
          );
        },
      ),
    );
  }
}
