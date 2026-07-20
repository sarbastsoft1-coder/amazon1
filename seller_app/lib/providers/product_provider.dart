import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _loading = false;
  String? _error;

  List<Product> get products => _products;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _loading = true;
    notifyListeners();
    final response = await ApiService.get('/products');
    _loading = false;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _products = (data['data'] as List).map((p) => Product.fromJson(p)).toList();
      _error = null;
    } else {
      _error = 'Failed to load products';
    }
    notifyListeners();
  }

  Future<bool> createProduct(Map<String, dynamic> data) async {
    final response = await ApiService.post('/products', data);
    if (response.statusCode == 201) {
      await fetchProducts();
      return true;
    }
    return false;
  }

  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await ApiService.put('/products/$id', data);
    if (response.statusCode == 200) {
      await fetchProducts();
      return true;
    }
    return false;
  }

  Future<bool> deleteProduct(int id) async {
    final response = await ApiService.delete('/products/$id');
    if (response.statusCode == 200) {
      await fetchProducts();
      return true;
    }
    return false;
  }
}
