import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../core/responsive/responsive.dart';
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
    final r = Responsive(context);

    // Responsive grid parameters
    final crossAxisCount = r.isSmall ? 2 : r.isMedium ? 2 : 3;
    final aspectRatio = r.isSmall ? 0.6 : r.isMedium ? 0.58 : 0.65;
    final gridSpacing = r.isSmall ? 8.0 : 12.0;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(gridSpacing),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.filter_list),
                      label: Text('Filter'.tr(context)),
                    ),
                  ),
                  SizedBox(width: gridSpacing),
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
              child: provider.loading
                  ? Center(child: CircularProgressIndicator())
                  : provider.products.isEmpty
                      ? EmptyState(message: 'No products found')
                      : GridView.builder(
                          padding: EdgeInsets.all(gridSpacing),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: aspectRatio,
                            crossAxisSpacing: gridSpacing,
                            mainAxisSpacing: gridSpacing,
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
      ),
    );
  }
}
