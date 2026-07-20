import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/seller.dart';
import '../services/api_service.dart';

class SellersProvider extends ChangeNotifier {
  List<Seller> _sellers = [];
  Seller? _selectedSeller;
  bool _loading = false;
  String? _error;
  String _statusFilter = 'all';
  int _currentPage = 1;

  List<Seller> get sellers => _sellers;
  Seller? get selectedSeller => _selectedSeller;
  bool get loading => _loading;
  String? get error => _error;
  String get statusFilter => _statusFilter;

  Future<void> loadSellers({String status = 'all', int page = 1}) async {
    _loading = true;
    _error = null;
    _statusFilter = status;
    _currentPage = page;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/sellers?status=$status&page=$page');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _sellers = (data['data'] as List)
            .map((s) => Seller.fromJson(s as Map<String, dynamic>))
            .toList();
        _currentPage = data['current_page'] ?? 1;
      } else {
        _error = 'Failed to load sellers: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading sellers: $e';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadSeller(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/sellers/$id');
      if (response.statusCode == 200) {
        _selectedSeller = Seller.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        _error = 'Failed to load seller: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading seller: $e';
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> approveSeller(int id, {String? notes}) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/admin/sellers/$id/approve', {'notes': notes ?? ''});
      if (response.statusCode == 200) {
        await loadSeller(id);
        await loadSellers(status: _statusFilter, page: _currentPage);
        _loading = false;
        notifyListeners();
        return true;
      }
      _error = 'Failed to approve seller: ${response.statusCode}';
    } catch (e) {
      _error = 'Error approving seller: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> rejectSeller(int id, {required String notes}) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/admin/sellers/$id/reject', {'notes': notes});
      if (response.statusCode == 200) {
        await loadSeller(id);
        await loadSellers(status: _statusFilter, page: _currentPage);
        _loading = false;
        notifyListeners();
        return true;
      }
      _error = 'Failed to reject seller: ${response.statusCode}';
    } catch (e) {
      _error = 'Error rejecting seller: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> suspendSeller(int id) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/admin/sellers/$id/suspend', {});
      if (response.statusCode == 200) {
        await loadSeller(id);
        await loadSellers(status: _statusFilter, page: _currentPage);
        _loading = false;
        notifyListeners();
        return true;
      }
      _error = 'Failed to suspend seller: ${response.statusCode}';
    } catch (e) {
      _error = 'Error suspending seller: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> deleteSeller(int id) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiService.delete('/admin/sellers/$id');
      if (response.statusCode == 200) {
        _sellers.removeWhere((s) => s.id == id);
        _loading = false;
        notifyListeners();
        return true;
      }
      _error = 'Failed to delete seller: ${response.statusCode}';
    } catch (e) {
      _error = 'Error deleting seller: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }
}
