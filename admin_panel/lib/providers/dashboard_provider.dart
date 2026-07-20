import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/dashboard_data.dart' as models;
import '../models/user.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  models.DashboardStats _stats = models.DashboardStats(
    todaySales: 0,
    todayOrders: 0,
    totalRevenue: 0,
    totalBuyers: 0,
    totalSellers: 0,
    totalUsers: 0,
    totalProducts: 0,
    totalOrders: 0,
    activeAuctions: 0,
    pendingApprovals: 0,
    systemHealth: 'Unknown',
  );
  models.PendingApprovals _pendingApprovals = models.PendingApprovals(
    storesCount: 0,
    productsCount: 0,
    stores: [],
    products: [],
  );
  List<models.Activity> _activities = [];
  models.NotificationSummary _notifications = models.NotificationSummary(
    unreadCount: 0,
    items: [],
  );
  List<dynamic> _recentOrders = [];
  List<User> _users = [];
  bool _loading = false;
  String? _error;

  models.DashboardStats get stats => _stats;
  models.PendingApprovals get pendingApprovals => _pendingApprovals;
  List<models.Activity> get activities => _activities;
  models.NotificationSummary get notifications => _notifications;
  List<dynamic> get recentOrders => _recentOrders;
  List<User> get users => _users;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadDashboard() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/dashboard');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _stats = models.DashboardStats.fromJson(data['stats'] as Map<String, dynamic>);
        _pendingApprovals = models.PendingApprovals.fromJson(data['pending_approvals'] as Map<String, dynamic>);
        _activities = (data['recent_activities'] as List)
            .map((a) => models.Activity.fromJson(a as Map<String, dynamic>))
            .toList();
        _notifications = models.NotificationSummary.fromJson(data['notifications'] as Map<String, dynamic>);
        _recentOrders = data['recent_orders'] as List? ?? [];
      } else {
        _error = 'Failed to load dashboard: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading dashboard: $e';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadStats() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/admin/stats');
      if (response.statusCode == 200) {
        _stats = models.DashboardStats.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        _error = 'Failed to load stats: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading stats: $e';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadRecentOrders({int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/admin/recent-orders?page=$page&per_page=$perPage');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _recentOrders = data['data'] as List? ?? [];
      }
    } catch (e) {
      _error = 'Error loading recent orders: $e';
    }
    notifyListeners();
  }

  Future<void> loadUsers() async {
    _loading = true;
    notifyListeners();
    final response = await ApiService.get('/admin/users');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _users = (data['data'] as List).map((u) => User.fromJson(u)).toList();
    }
    _loading = false;
    notifyListeners();
  }
}
