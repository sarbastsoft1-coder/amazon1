import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../services/mock_data_service.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _loading = false;

  List<Order> get orders => _orders;
  bool get loading => _loading;

  Future<void> fetchOrders() async {
    _loading = true;
    notifyListeners();
    try {
      final response = await ApiService.get('/orders');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _orders = (data['data'] as List).map((o) => Order.fromJson(o)).toList();
      } else {
        _orders = MockDataService.getMockOrders();
      }
    } catch (e) {
      debugPrint('Failed to fetch orders: $e');
      _orders = MockDataService.getMockOrders();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Order?> placeOrder(Map<String, dynamic> data) async {
    final response = await ApiService.post('/orders', data);
    if (response.statusCode == 201) {
      await fetchOrders();
      return Order.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
