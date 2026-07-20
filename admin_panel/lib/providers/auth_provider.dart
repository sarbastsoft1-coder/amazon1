import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _loading = false;

  User? get user => _user;
  bool get loading => _loading;
  bool get isAuthenticated => _token != null;

  Future<bool> loadToken() async {
    _loading = true;
    notifyListeners();
    _token = await ApiService.getToken();
    if (_token != null) await fetchUser();
    _loading = false;
    notifyListeners();
    return _token != null;
  }

  Future<void> fetchUser() async {
    final response = await ApiService.get('/me');
    if (response.statusCode == 200) {
      _user = User.fromJson(jsonDecode(response.body));
    } else {
      _token = null;
      await ApiService.removeToken();
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await ApiService.post('/login', {'email': email, 'password': password});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      await ApiService.setToken(_token!);
      _user = User.fromJson(data['user']);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await ApiService.post('/logout', {});
    _token = null;
    _user = null;
    await ApiService.removeToken();
    notifyListeners();
  }
}
