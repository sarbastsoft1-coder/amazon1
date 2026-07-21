import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../services/mock_data_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _allProducts = []; // Unfiltered master list
  List<Product> _featured = [];
  List<Product> _newArrivals = [];
  List<Product> _bestSellers = [];
  List<Product> _flashSale = [];
  List<Product> _auctions = [];
  List<Category> _categories = [];
  bool _loading = false;
  String? _error;
  String? _selectedCategory;
  String _sortBy = 'default'; // default, price_asc, price_desc, name, rating

  List<Product> get products => _products;
  List<Product> get allProducts => _allProducts;
  List<Product> get featured => _featured;
  List<Product> get newArrivals => _newArrivals;
  List<Product> get bestSellers => _bestSellers;
  List<Product> get flashSale => _flashSale;
  List<Product> get auctions => _auctions;
  List<Category> get categories => _categories;
  bool get loading => _loading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  // Get unique category names from loaded products
  List<String> get availableCategories {
    final cats = _allProducts
        .where((p) => p.categoryName != null && p.categoryName!.isNotEmpty)
        .map((p) => p.categoryName!)
        .toSet()
        .toList();
    cats.sort();
    return cats;
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    // Start from all products
    List<Product> filtered = List.from(_allProducts);

    // Apply category filter
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      filtered = filtered.where((p) => p.categoryName == _selectedCategory).toList();
    }

    // Apply sorting
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
      default:
        break;
    }

    _products = filtered;

    // Also update section lists based on filtering
    _featured = filtered.take(5).toList();
    _newArrivals = filtered.toList();
    _bestSellers = filtered.toList();
    _flashSale = filtered.where((p) => p.discount != null && p.discount! > 0).toList();
    _auctions = filtered.where((p) => p.isAuction).toList();
  }

  Future<void> fetchProducts({int? categoryId, String? query}) async {
    _loading = true;
    notifyListeners();

    String path = '/products';
    final params = <String, String>{};
    if (categoryId != null) params['category_id'] = categoryId.toString();
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (params.isNotEmpty) {
      path += '?${params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';
    }

    try {
      final response = await ApiService.get(path);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _products = (data['data'] as List).map((p) => Product.fromJson(p)).toList();
        _allProducts = List.from(_products);
        _error = null;
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      debugPrint('Failed to fetch products: $e');
      _error = 'Network error: Failed to load products';
    }
    
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchHomeData() async {
    _loading = true;
    notifyListeners();
    
    List<Product> all = [];
    try {
      final response = await ApiService.get('/products');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        all = (data['data'] as List).map((p) => Product.fromJson(p)).toList();
      } else {
        all = MockDataService.getMockProducts();
      }
    } catch (e) {
      debugPrint('Failed to fetch home data: $e');
      all = MockDataService.getMockProducts();
    }
    
    _loading = false;
    _allProducts = all;
    _selectedCategory = null;
    _sortBy = 'default';
    _featured = all.take(5).toList();
    _newArrivals = all.toList();
    _bestSellers = all.toList();
    _flashSale = all.where((p) => p.discount != null && p.discount! > 0).toList();
    _auctions = all.where((p) => p.isAuction).toList();
    _products = all;
    _error = null;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiService.get('/categories');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _categories = (data['data'] as List).map((c) => Category.fromJson(c)).toList();
      } else {
        _categories = MockDataService.getMockCategories();
      }
    } catch (e) {
      debugPrint('Failed to fetch categories: $e');
      _categories = MockDataService.getMockCategories();
    }
    notifyListeners();
  }

  Future<bool> placeBid(int productId, double amount) async {
    try {
      final response = await ApiService.post(
        '/products/$productId/bids',
        {'amount': amount},
      );
      if (response.statusCode == 201) {
        // Refresh product data if needed, or rely on caller to refetch
        return true;
      }
    } catch (e) {
      debugPrint('Failed to place bid: $e');
    }
    return false;
  }
}
