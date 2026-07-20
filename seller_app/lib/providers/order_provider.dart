import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _loading = false;

  List<Order> get orders => _orders;
  bool get loading => _loading;

  Future<void> fetchOrders() async {
    _loading = true;
    notifyListeners();
    final response = await ApiService.get('/orders');
    _loading = false;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _orders = (data['data'] as List).map((o) => Order.fromJson(o)).toList();
    }
    notifyListeners();
  }

  Future<bool> updateStatus(int id, String status) async {
    final response = await ApiService.put('/orders/$id/status', {'status': status});
    if (response.statusCode == 200) {
      await fetchOrders();
      return true;
    }
    return false;
  }
}
