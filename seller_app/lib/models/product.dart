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
  final String? amazonAsin;

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
    this.isActive = true,
    this.amazonAsin,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      comparePrice: json['compare_price'] != null ? double.tryParse(json['compare_price'].toString()) : null,
      stock: json['stock'],
      sku: json['sku'],
      images: json['images'] ?? [],
      isActive: json['is_active'] ?? true,
      amazonAsin: json['amazon_asin'],
    );
  }
}
