import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  Product? _selectedProduct;
  bool _loading = false;
  String? _error;
  String _statusFilter = 'all';

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get loading => _loading;
  String? get error => _error;
  String get statusFilter => _statusFilter;

  Future<void> loadProducts({String status = 'all', int page = 1}) async {
    _loading = true;
    _error = null;
    _statusFilter = status;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/products?status=$status&page=$page');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _products = (data['data'] as List)
            .map((p) => Product.fromJson(p as Map<String, dynamic>))
            .toList();
      } else {
        _error = 'Failed to load products: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading products: $e';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadProduct(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/products/$id');
      if (response.statusCode == 200) {
        _selectedProduct = Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        _error = 'Failed to load product: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading product: $e';
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> approveProduct(int id, {String? notes}) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/admin/products/$id/approve', {'notes': notes ?? ''});
      if (response.statusCode == 200) {
        await loadProduct(id);
        await loadProducts(status: _statusFilter);
        _loading = false;
        notifyListeners();
        return true;
      }
      _error = 'Failed to approve product: ${response.statusCode}';
    } catch (e) {
      _error = 'Error approving product: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> rejectProduct(int id, {required String notes}) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/admin/products/$id/reject', {'notes': notes});
      if (response.statusCode == 200) {
        await loadProduct(id);
        await loadProducts(status: _statusFilter);
        _loading = false;
        notifyListeners();
        return true;
      }
      _error = 'Failed to reject product: ${response.statusCode}';
    } catch (e) {
      _error = 'Error rejecting product: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> deleteProduct(int id) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiService.delete('/admin/products/$id');
      if (response.statusCode == 200) {
        _products.removeWhere((p) => p.id == id);
        _loading = false;
        notifyListeners();
        return true;
      }
      _error = 'Failed to delete product: ${response.statusCode}';
    } catch (e) {
      _error = 'Error deleting product: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }
}
