class Product {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? comparePrice;
  final double? discount;
  final int stock;
  final String? sku;
  final List<dynamic> images;
  final bool isActive;
  final double rating;
  final int reviewCount;
  final bool isAuction;
  final String? brand;
  final int? categoryId;
  final String? categoryName;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.comparePrice,
    this.discount,
    required this.stock,
    this.sku,
    required this.images,
    this.isActive = true,
    this.rating = 0,
    this.reviewCount = 0,
    this.isAuction = false,
    this.brand,
    this.categoryId,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      comparePrice: json['compare_price'] != null ? double.tryParse(json['compare_price'].toString()) : null,
      discount: json['discount'] != null ? double.tryParse(json['discount'].toString()) : null,
      stock: json['stock'],
      sku: json['sku'],
      images: json['images'] ?? [],
      isActive: json['is_active'] ?? true,
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) ?? 0 : 0,
      reviewCount: json['review_count'] ?? 0,
      isAuction: json['is_auction'] ?? false,
      brand: json['brand'],
      categoryId: json['category_id'],
      categoryName: json['category_name'] ?? json['category']?['name'],
    );
  }
}
