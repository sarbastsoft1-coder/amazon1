import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';

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
  bool _isCompressing = false;
  bool _isAuction = false;
  DateTime? _auctionEndTime;

  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> _compressImage(XFile file) async {
    if (kIsWeb) {
      return file; // Web handles compression directly via HTTP or we skip it for now
    }
    try {
      final tempDir = await path_provider.getTemporaryDirectory();
      final extensionName = p.extension(file.path);
      final targetPath = p.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed$extensionName',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: 80,
        minWidth: 800,
        minHeight: 800,
      );

      return result;
    } catch (e) {
      debugPrint('Error compressing image: $e');
    }
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= 5) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You can only add up to 5 images for a product.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() => _isCompressing = true);
        final compressedFile = await _compressImage(pickedFile);
        setState(() => _isCompressing = false);

        if (compressedFile != null) {
          setState(() {
            _selectedImages.add(compressedFile);
          });
        }
      }
    } catch (e) {
      setState(() => _isCompressing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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

  Future<void> _selectAuctionEndTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _auctionEndTime ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_auctionEndTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _auctionEndTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

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

    if (_isAuction && _auctionEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an auction end time.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    final user = context.read<AuthProvider>().user;
    final storeId = user?.storeId;
    if (storeId == null) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No store associated with this account. Please set up your store first.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // Map Category name to seeded category ID
    int categoryId;
    if (_selectedCategory == 'Electronics') {
      categoryId = 1;
    } else if (_selectedCategory == 'Fashion') {
      categoryId = 4;
    } else {
      categoryId = 1; // Default fallback to Electronics
    }

    final payload = {
      'store_id': storeId,
      'category_id': categoryId,
      'name': _name.text,
      'description': _description.text,
      'price': double.tryParse(_price.text) ?? 0.0,
      'stock': int.tryParse(_stock.text) ?? 0,
      'sku': _sku.text.isNotEmpty ? _sku.text : null,
      'is_auction': _isAuction,
      'auction_end_time': _isAuction && _auctionEndTime != null ? _auctionEndTime!.toIso8601String() : null,
    };

    bool success = false;
    try {
      if (widget.productId == null) {
        success = await context.read<ProductProvider>().createProduct(payload, _selectedImages);
      } else {
        success = await context.read<ProductProvider>().updateProduct(widget.productId!, payload, _selectedImages);
      }
    } catch (e) {
      debugPrint('Error saving product: $e');
      success = false;
    } finally {
      setState(() => _loading = false);
    }
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.productId == null ? 'Product published!' : 'Product updated!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context, true); // Return true to trigger refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save product. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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

              // Auction Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Sell as Auction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Allow buyers to place bids on this item.', style: TextStyle(fontSize: 12)),
                      value: _isAuction,
                      activeTrackColor: AppTheme.primaryColor.withOpacity(0.4),
                      activeThumbColor: AppTheme.primaryColor,
                      onChanged: (bool value) {
                        setState(() {
                          _isAuction = value;
                        });
                      },
                    ),
                    if (_isAuction)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Auction End Time:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            TextButton.icon(
                              onPressed: _selectAuctionEndTime,
                              icon: const Icon(Icons.calendar_today, size: 16),
                              label: Text(
                                _auctionEndTime != null
                                    ? '${_auctionEndTime!.year}-${_auctionEndTime!.month.toString().padLeft(2, '0')}-${_auctionEndTime!.day.toString().padLeft(2, '0')} ${_auctionEndTime!.hour.toString().padLeft(2, '0')}:${_auctionEndTime!.minute.toString().padLeft(2, '0')}'
                                    : 'Select Time',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Product Images Section
              const Text(
                'Product Images',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Add Image Button
                      final isLimitReached = _selectedImages.length >= 5;
                      return GestureDetector(
                        onTap: isLimitReached
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('You can only add up to 5 images for a product.'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            : _showImageSourceActionSheet,
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: isLimitReached ? Colors.grey.withValues(alpha: 0.02) : Colors.grey.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isLimitReached ? Colors.grey.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.3),
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          child: _isCompressing
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.secondaryColor),
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      color: isLimitReached ? Colors.grey : AppTheme.secondaryColor,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Add Photo',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isLimitReached ? Colors.grey : AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }

                    final imageFile = _selectedImages[index - 1];
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            image: DecorationImage(
                              image: kIsWeb 
                                  ? NetworkImage(imageFile.path) as ImageProvider
                                  : FileImage(File(imageFile.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 16,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.removeAt(index - 1);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
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
