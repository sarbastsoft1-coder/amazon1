import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../data/models/product.dart';
import '../../../data/providers/product_provider.dart';
import '../../widgets/common/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.textPrimary, size: 28),
          onPressed: () {},
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
                  SizedBox(width: 8),
                  Text('Browse categories...', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BannerSlider(),
                  const SizedBox(height: 16),
                  const CategoryFilterBar(),
                  const SizedBox(height: 8),
                  if (provider.flashSale.isNotEmpty) ...[
                    SectionTitle(
                      title: 'Flash Sale',
                      onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productList, arguments: {'title': 'Flash Sale'}),
                    ),
                    ProductHorizontalList(products: provider.flashSale),
                  ],
                  if (provider.newArrivals.isNotEmpty) ...[
                    SectionTitle(
                      title: "Today's Deals",
                      onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productList, arguments: {'title': "Today's Deals"}),
                    ),
                    ProductHorizontalList(products: provider.newArrivals.take(6).toList()),
                  ],
                  if (provider.newArrivals.isNotEmpty) ...[
                    SectionTitle(
                      title: 'New Arrivals',
                      onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productList, arguments: {'title': 'New Arrivals'}),
                    ),
                    ProductHorizontalList(products: provider.newArrivals),
                  ],
                  if (provider.bestSellers.isNotEmpty) ...[
                    SectionTitle(
                      title: 'Best Sellers',
                      onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productList, arguments: {'title': 'Best Sellers'}),
                    ),
                    ProductHorizontalList(products: provider.bestSellers),
                  ],
                  if (provider.featured.isNotEmpty) ...[
                    SectionTitle(
                      title: 'Recommended Products',
                      onSeeAll: () => Navigator.pushNamed(context, AppRoutes.productList, arguments: {'title': 'Recommended'}),
                    ),
                    ProductHorizontalList(products: provider.featured),
                  ],
                  if (provider.auctions.isNotEmpty) ...[
                    SectionTitle(
                      title: 'Auction Products',
                      onSeeAll: () => Navigator.pushNamed(context, AppRoutes.auctions),
                    ),
                    ProductHorizontalList(products: provider.auctions),
                  ],
                  const CategoryGrid(),
                  const BrandGrid(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final _controller = PageController();
  int _currentPage = 0;

  final _banners = const [
    {'color': Color(0xFF3B82F6), 'title': 'Summer Sale', 'subtitle': 'Up to 50% off'},
    {'color': Color(0xFF10B981), 'title': 'New Arrivals', 'subtitle': 'Discover the latest'},
    {'color': Color(0xFFF59E0B), 'title': 'Flash Deals', 'subtitle': 'Limited time offers'},
    {'color': Color(0xFF8B5CF6), 'title': 'Live Auctions', 'subtitle': 'Bid and win'},
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      if (page != _currentPage) setState(() => _currentPage = page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      banner['color'] as Color,
                      (banner['color'] as Color).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: (banner['color'] as Color).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      bottom: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner['title'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['subtitle'] as String,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 28 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: _currentPage == index ? AppTheme.primaryColor : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductHorizontalList extends StatelessWidget {
  final List<Product> products;
  const ProductHorizontalList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260, // Increased slightly to accommodate padding for shadows
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 160,
            child: ProductCard(
              product: product,
              onTap: () => Navigator.pushNamed(context, AppRoutes.productDetails, arguments: {'productId': product.id}),
            ),
          );
        },
      ),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static const categories = [
    {'name': 'Fashion', 'icon': Icons.checkroom},
    {'name': 'Electronics', 'icon': Icons.devices},
    {'name': 'Beauty', 'icon': Icons.face},
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Sports', 'icon': Icons.sports},
    {'name': 'Books', 'icon': Icons.book},
    {'name': 'Grocery', 'icon': Icons.local_grocery_store},
    {'name': 'Automotive', 'icon': Icons.car_rental},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Categories'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            children: categories.map((cat) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.categoryProducts, arguments: {'title': cat['name']}),
                child: SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
                          ],
                        ),
                        child: Icon(cat['icon'] as IconData, color: AppTheme.primaryColor, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(cat['name'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class BrandGrid extends StatelessWidget {
  const BrandGrid({super.key});

  static const brands = ['Nike', 'Adidas', 'Apple', 'Samsung', 'Sony', 'LG'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Popular Brands'),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Center(child: Text(brands[index], style: const TextStyle(fontWeight: FontWeight.w700))),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final categories = provider.availableCategories;
    final selectedCategory = provider.selectedCategory;

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Sort Dropdown
          _SortDropdown(
            currentSort: provider.sortBy,
            onChanged: (sort) => provider.setSortBy(sort),
          ),
          const SizedBox(width: 8),
          // "All" chip
          _FilterChip(
            label: 'All',
            isSelected: selectedCategory == null,
            onTap: () => provider.setCategory(null),
            count: provider.allProducts.length,
          ),
          // Category chips
          ...categories.map((cat) {
            final count = provider.allProducts.where((p) => p.categoryName == cat).length;
            return _FilterChip(
              label: cat,
              isSelected: selectedCategory == cat,
              onTap: () => provider.setCategory(cat),
              count: count,
            );
          }),
        ],
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final String currentSort;
  final ValueChanged<String> onChanged;

  const _SortDropdown({required this.currentSort, required this.onChanged});

  String get _label {
    switch (currentSort) {
      case 'price_asc':
        return '↑ Price';
      case 'price_desc':
        return '↓ Price';
      case 'name':
        return 'A-Z';
      case 'rating':
        return '★ Top';
      default:
        return 'Sort';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      offset: const Offset(0, 48),
      itemBuilder: (context) => [
        _buildMenuItem('default', 'Default', Icons.auto_awesome, currentSort == 'default'),
        _buildMenuItem('price_asc', 'Price: Low to High', Icons.arrow_upward, currentSort == 'price_asc'),
        _buildMenuItem('price_desc', 'Price: High to Low', Icons.arrow_downward, currentSort == 'price_desc'),
        _buildMenuItem('name', 'Name: A-Z', Icons.sort_by_alpha, currentSort == 'name'),
        _buildMenuItem('rating', 'Top Rated', Icons.star, currentSort == 'rating'),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        decoration: BoxDecoration(
          color: currentSort != 'default'
              ? AppTheme.primaryColor.withValues(alpha: 0.08)
              : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: currentSort != 'default'
                ? AppTheme.primaryColor.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.3),
            width: currentSort != 'default' ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.swap_vert_rounded,
              size: 18,
              color: currentSort != 'default' ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              _label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: currentSort != 'default' ? AppTheme.primaryColor : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: currentSort != 'default' ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuEntry<String> _buildMenuItem(String value, String label, IconData icon, bool isSelected) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
              fontSize: 14,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check, size: 18, color: AppTheme.primaryColor),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int count;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(left: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                fontSize: 14,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

