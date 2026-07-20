class Product {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? comparePrice;
  final int stock;
  final String? sku;
  final List<dynamic> images;
  final bool isActive;
  final String status;
  final Map<String, dynamic>? store;
  final Map<String, dynamic>? category;
  final String createdAt;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.comparePrice,
    required this.stock,
    this.sku,
    required this.images,
    required this.isActive,
    required this.status,
    this.store,
    this.category,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      comparePrice: json['compare_price'] != null ? (json['compare_price'] as num).toDouble() : null,
      stock: json['stock'] ?? 0,
      sku: json['sku'],
      images: json['images'] as List? ?? [],
      isActive: json['is_active'] ?? false,
      status: json['status'] ?? 'pending',
      store: json['store'] as Map<String, dynamic>?,
      category: json['category'] as Map<String, dynamic>?,
      createdAt: json['created_at'] ?? '',
    );
  }
}
