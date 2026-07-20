import 'package:flutter/material.dart';
import '../../config/theme.dart';

class AddProductScreen extends StatefulWidget {
  final int? productId;
  const AddProductScreen({super.key, this.productId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();
  final _sku = TextEditingController();
  final _brand = TextEditingController();
  bool _loading = false;

  // Category selection
  String? _selectedCategory;
  String? _selectedSubCategory;

  static const Map<String, List<String>> _categoryTree = {
    'Electronics': ['Phones & Tablets', 'Laptops & Computers', 'Audio', 'Cameras', 'Gaming', 'Accessories'],
    'Fashion': ['Men\'s Clothing', 'Women\'s Clothing', 'Kids', 'Shoes', 'Bags & Wallets', 'Jewelry'],
    'Beauty': ['Skincare', 'Makeup', 'Hair Care', 'Fragrances', 'Personal Care'],
    'Home & Living': ['Furniture', 'Kitchen', 'Bedding', 'Decor', 'Lighting', 'Storage'],
    'Sports & Outdoors': ['Fitness', 'Running', 'Cycling', 'Camping', 'Swimming', 'Team Sports'],
    'Books & Media': ['Fiction', 'Non-Fiction', 'Textbooks', 'Comics', 'Magazines'],
    'Grocery': ['Snacks', 'Beverages', 'Fresh Food', 'Canned Goods', 'Organic'],
    'Automotive': ['Car Accessories', 'Motorcycle', 'Tools', 'Parts', 'Car Care'],
  };

  static const Map<String, IconData> _categoryIcons = {
    'Electronics': Icons.devices,
    'Fashion': Icons.checkroom,
    'Beauty': Icons.face,
    'Home & Living': Icons.home,
    'Sports & Outdoors': Icons.sports_soccer,
    'Books & Media': Icons.auto_stories,
    'Grocery': Icons.local_grocery_store,
    'Automotive': Icons.directions_car,
  };

  static const Map<String, Color> _categoryColors = {
    'Electronics': Color(0xFF2196F3),
    'Fashion': Color(0xFFE91E63),
    'Beauty': Color(0xFF9C27B0),
    'Home & Living': Color(0xFFFF9800),
    'Sports & Outdoors': Color(0xFF4CAF50),
    'Books & Media': Color(0xFF795548),
    'Grocery': Color(0xFF009688),
    'Automotive': Color(0xFF3F51B5),
  };

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.productId == null ? 'Product published!' : 'Product updated!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String? tempCategory = _selectedCategory;
        String? tempSubCategory = _selectedSubCategory;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final subCategories = tempCategory != null ? _categoryTree[tempCategory]! : <String>[];

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Handle bar
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select Category',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          if (tempCategory != null)
                            TextButton(
                              onPressed: () {
                                setModalState(() {
                                  tempCategory = null;
                                  tempSubCategory = null;
                                });
                              },
                              child: const Text('Reset'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tempCategory == null
                            ? 'Choose a main category'
                            : 'Choose a subcategory in $tempCategory',
                        style: TextStyle(fontSize: 13, color: AppTheme.mutedTextColor),
                      ),
                      const SizedBox(height: 16),

                      // Breadcrumb
                      if (tempCategory != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: (_categoryColors[tempCategory] ?? Colors.blue).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _categoryIcons[tempCategory] ?? Icons.category,
                                size: 20,
                                color: _categoryColors[tempCategory] ?? Colors.blue,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                tempCategory!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: _categoryColors[tempCategory] ?? Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                              if (tempSubCategory != null) ...[
                                Icon(Icons.chevron_right, size: 18, color: _categoryColors[tempCategory]),
                                Text(
                                  tempSubCategory!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _categoryColors[tempCategory] ?? Colors.blue,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  if (tempSubCategory != null) {
                                    setModalState(() => tempSubCategory = null);
                                  } else {
                                    setModalState(() {
                                      tempCategory = null;
                                      tempSubCategory = null;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
                                    ],
                                  ),
                                  child: const Icon(Icons.arrow_back, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Category / Subcategory Grid
                      Expanded(
                        child: tempCategory == null
                            ? _buildMainCategoryGrid(setModalState, (cat) {
                                setModalState(() {
                                  tempCategory = cat;
                                  tempSubCategory = null;
                                });
                              })
                            : _buildSubCategoryList(
                                scrollController,
                                subCategories,
                                tempSubCategory,
                                tempCategory!,
                                (sub) => setModalState(() => tempSubCategory = sub),
                              ),
                      ),

                      // Confirm Button
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: tempCategory != null
                                  ? () {
                                      setState(() {
                                        _selectedCategory = tempCategory;
                                        _selectedSubCategory = tempSubCategory;
                                      });
                                      Navigator.pop(context);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.secondaryColor,
                                disabledBackgroundColor: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: Text(
                                tempSubCategory != null
                                    ? 'Confirm: $tempCategory > $tempSubCategory'
                                    : tempCategory != null
                                        ? 'Select $tempCategory'
                                        : 'Select a category',
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMainCategoryGrid(StateSetter setModalState, ValueChanged<String> onSelect) {
    final cats = _categoryTree.keys.toList();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cats.length,
      itemBuilder: (context, index) {
        final cat = cats[index];
        final color = _categoryColors[cat] ?? Colors.blue;
        final icon = _categoryIcons[cat] ?? Icons.category;
        final subCount = _categoryTree[cat]?.length ?? 0;

        return GestureDetector(
          onTap: () => onSelect(cat),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, size: 22, color: color),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cat,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$subCount subcategories',
                        style: TextStyle(fontSize: 11, color: AppTheme.mutedTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubCategoryList(
    ScrollController controller,
    List<String> subCategories,
    String? selected,
    String parentCategory,
    ValueChanged<String> onSelect,
  ) {
    final color = _categoryColors[parentCategory] ?? Colors.blue;
    return ListView.separated(
      controller: controller,
      itemCount: subCategories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final sub = subCategories[index];
        final isSelected = selected == sub;
        return GestureDetector(
          onTap: () => onSelect(sub),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.08) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? color : Colors.grey.withValues(alpha: 0.15),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.label_outline,
                    size: 18,
                    color: isSelected ? color : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    sub,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 15,
                      color: isSelected ? color : AppTheme.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 2),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.shopping_bag_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Product name is required' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Price and Stock
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _price,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Price is required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stock,
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // SKU and Brand
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sku,
                      decoration: const InputDecoration(
                        labelText: 'SKU',
                        prefixIcon: Icon(Icons.qr_code),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _brand,
                      decoration: const InputDecoration(
                        labelText: 'Brand',
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Category Selector
              const Text(
                'Category',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showCategoryPicker,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedCategory != null
                        ? (_categoryColors[_selectedCategory] ?? Colors.blue).withValues(alpha: 0.05)
                        : const Color(0xFFF8F9FC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedCategory != null
                          ? (_categoryColors[_selectedCategory] ?? Colors.blue).withValues(alpha: 0.4)
                          : const Color(0xFFE2E8F0),
                      width: _selectedCategory != null ? 2 : 1,
                    ),
                  ),
                  child: _selectedCategory != null
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: (_categoryColors[_selectedCategory] ?? Colors.blue).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _categoryIcons[_selectedCategory] ?? Icons.category,
                                size: 24,
                                color: _categoryColors[_selectedCategory] ?? Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedCategory!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  if (_selectedSubCategory != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      _selectedSubCategory!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: _categoryColors[_selectedCategory] ?? Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: _categoryColors[_selectedCategory] ?? Colors.blue,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.category_outlined, size: 24, color: AppTheme.mutedTextColor),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Tap to select a category',
                                style: TextStyle(
                                  color: AppTheme.mutedTextColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.mutedTextColor),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 28),

              // Publish Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _save,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.publish),
                  label: Text(
                    _loading
                        ? 'Publishing...'
                        : widget.productId == null
                            ? 'Publish Product'
                            : 'Update Product',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
