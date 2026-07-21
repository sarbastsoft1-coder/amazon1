import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../core/responsive/responsive.dart';
import '../../../data/models/product.dart';
import '../../../data/services/mock_data_service.dart';
import '../../widgets/common/widgets.dart';


class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const categories = [
    {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Color(0xFFE91E63), 'gradient': [Color(0xFFE91E63), Color(0xFFFF5252)]},
    {'name': 'Electronics', 'icon': Icons.devices, 'color': Color(0xFF2196F3), 'gradient': [Color(0xFF2196F3), Color(0xFF42A5F5)]},
    {'name': 'Beauty', 'icon': Icons.face, 'color': Color(0xFF9C27B0), 'gradient': [Color(0xFF9C27B0), Color(0xFFBA68C8)]},
    {'name': 'Home', 'icon': Icons.home, 'color': Color(0xFFFF9800), 'gradient': [Color(0xFFFF9800), Color(0xFFFFB74D)]},
    {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': Color(0xFF4CAF50), 'gradient': [Color(0xFF4CAF50), Color(0xFF81C784)]},
    {'name': 'Books', 'icon': Icons.auto_stories, 'color': Color(0xFF795548), 'gradient': [Color(0xFF795548), Color(0xFFA1887F)]},
    {'name': 'Grocery', 'icon': Icons.local_grocery_store, 'color': Color(0xFF009688), 'gradient': [Color(0xFF009688), Color(0xFF4DB6AC)]},
    {'name': 'Automotive', 'icon': Icons.directions_car, 'color': Color(0xFF3F51B5), 'gradient': [Color(0xFF3F51B5), Color(0xFF7986CB)]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Categories'.tr(context)),
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final gradientColors = cat['gradient'] as List<Color>;
            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.categoryProducts,
                arguments: {'title': cat['name'], 'categoryId': index + 1},
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (cat['color'] as Color).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative circle
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(cat['icon'] as IconData, size: 30, color: Colors.white),
                          ),
                          SizedBox(height: 12),
                          Text(
                            cat['name'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryProductsScreen extends StatefulWidget {
  final int categoryId;
  final String title;
  const CategoryProductsScreen({super.key, required this.categoryId, required this.title});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product> _products = [];
  String _sortBy = 'default';
  bool _isGridView = true;
  RangeValues _priceRange = RangeValues(0, 500);
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    // Get products for this category
    final allProducts = MockDataService.getMockProducts();
    _products = allProducts.where((p) => p.categoryName == widget.title).toList();
    if (_products.isEmpty) {
      _products = allProducts; // Fallback to all
    }
    _loading = false;
    if (mounted) setState(() {});
  }

  void _applySortAndFilter() {
    final allProducts = MockDataService.getMockProducts();
    var filtered = allProducts.where((p) => p.categoryName == widget.title).toList();
    if (filtered.isEmpty) {
      filtered = allProducts;
    }

    // Price filter
    filtered = filtered.where((p) => p.price >= _priceRange.start && p.price <= _priceRange.end).toList();

    // Sort
    switch (_sortBy) {
      case 'price_asc':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    setState(() => _products = filtered);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        RangeValues tempRange = _priceRange;
        String tempSort = _sortBy;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Filter & Sort'.tr(context), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  SizedBox(height: 24),

                  // Sort Options
                  Text('Sort By'.tr(context), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSortChip('Default', 'default', tempSort, (v) => setModalState(() => tempSort = v)),
                      _buildSortChip('Price ↑', 'price_asc', tempSort, (v) => setModalState(() => tempSort = v)),
                      _buildSortChip('Price ↓', 'price_desc', tempSort, (v) => setModalState(() => tempSort = v)),
                      _buildSortChip('Name', 'name', tempSort, (v) => setModalState(() => tempSort = v)),
                      _buildSortChip('Rating', 'rating', tempSort, (v) => setModalState(() => tempSort = v)),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Price Range
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price Range'.tr(context), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      Text(
                        '\$${tempRange.start.round()} - \$${tempRange.end.round()}',
                        style: TextStyle(fontSize: 13, color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  RangeSlider(
                    values: tempRange,
                    min: 0,
                    max: 500,
                    divisions: 50,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                    labels: RangeLabels(
                      '\$${tempRange.start.round()}',
                      '\$${tempRange.end.round()}',
                    ),
                    onChanged: (values) => setModalState(() => tempRange = values),
                  ),
                  SizedBox(height: 24),

                  // Apply button
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempRange = RangeValues(0, 500);
                              tempSort = 'default';
                            });
                          },
                          child: Text('Reset'.tr(context)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            _sortBy = tempSort;
                            _priceRange = tempRange;
                            _applySortAndFilter();
                            Navigator.pop(context);
                          },
                          child: Text('Apply'.tr(context)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortChip(String label, String value, String current, ValueChanged<String> onTap) {
    final isSelected = current == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter / Sort bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showFilterSheet,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tune_rounded, size: 18, color: AppTheme.primaryColor),
                          SizedBox(width: 8),
                          Text('Filter & Sort'.tr(context),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Results count
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${_products.length} items',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active filters display
          if (_sortBy != 'default' || _priceRange.start > 0 || _priceRange.end < 500)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (_sortBy != 'default')
                      _buildActiveFilter(
                        'Sort: ${_sortBy == 'price_asc' ? 'Price ↑' : _sortBy == 'price_desc' ? 'Price ↓' : _sortBy == 'name' ? 'A-Z' : 'Rating'}',
                        () => setState(() {
                          _sortBy = 'default';
                          _applySortAndFilter();
                        }),
                      ),
                    if (_priceRange.start > 0 || _priceRange.end < 500)
                      _buildActiveFilter(
                        '\$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
                        () => setState(() {
                          _priceRange = RangeValues(0, 500);
                          _applySortAndFilter();
                        }),
                      ),
                  ],
                ),
              ),
            ),

          // Products Grid/List
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? EmptyState(message: 'No products in this category')
                    : _isGridView
                        ? GridView.builder(
                            padding: EdgeInsets.all(16),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Responsive(context).isSmall ? 2 : Responsive(context).isMedium ? 2 : 3,
                              childAspectRatio: Responsive(context).isSmall ? 0.6 : Responsive(context).isMedium ? 0.58 : 0.65,
                              crossAxisSpacing: Responsive(context).isSmall ? 8 : 14,
                              mainAxisSpacing: Responsive(context).isSmall ? 8 : 14,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return ProductCard(
                                product: product,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.productDetails,
                                  arguments: {'productId': product.id},
                                ),
                              );
                            },
                          )
                        : ListView.separated(
                            padding: EdgeInsets.all(16),
                            itemCount: _products.length,
                            separatorBuilder: (_, _) => SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return _buildListTile(context, product);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilter(String label, VoidCallback onRemove) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryColor),
          ),
          SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.productDetails,
        arguments: {'productId': product.id},
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          children: [
            // Product image
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: product.images.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(product.images.first, fit: BoxFit.cover),
                    )
                  : Icon(Icons.image, size: 36, color: Colors.grey[400]),
            ),
            SizedBox(width: 14),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, height: 1.3),
                  ),
                  SizedBox(height: 6),
                  if (product.brand != null)
                    Text(
                      product.brand!,
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      if (product.comparePrice != null) ...[
                        SizedBox(width: 8),
                        Text(
                          '\$${product.comparePrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (product.rating > 0) ...[
                    SizedBox(height: 6),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          return Icon(
                            i < product.rating.floor() ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Color(0xFFFFC107),
                          );
                        }),
                        SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Wishlist + Cart
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
                    ],
                  ),
                  child: Icon(Icons.favorite_border, size: 18, color: AppTheme.textSecondary),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
