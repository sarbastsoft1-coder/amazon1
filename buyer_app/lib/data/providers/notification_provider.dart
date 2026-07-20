import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final Map<String, bool> _settings = {
    'orders': true,
    'offers': true,
    'auctions': true,
    'promotions': false,
    'messages': true,
  };

  NotificationProvider() {
    _loadSettings();
  }

  Map<String, bool> get settings => Map.unmodifiable(_settings);

  bool isEnabled(String key) => _settings[key] ?? false;

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in _settings.keys) {
        final value = prefs.getBool('notification_$key');
        if (value != null) {
          _settings[key] = value;
        }
      }
      notifyListeners();
      if (NotificationService.isInitialized && NotificationService.permissionGranted) {
        await subscribeToAll();
      }
    } catch (e) {
      debugPrint('NotificationProvider loadSettings error: $e');
    }
  }

  Future<void> _saveSetting(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notification_$key', value);
    } catch (e) {
      debugPrint('NotificationProvider saveSetting error: $e');
    }
  }

  Future<void> toggle(String key) async {
    if (!NotificationService.isInitialized || !NotificationService.permissionGranted) {
      debugPrint('Cannot toggle notifications: not initialized or permission denied');
      return;
    }
    try {
      final current = _settings[key] ?? false;
      final newValue = !current;
      _settings[key] = newValue;
      notifyListeners();
      await _saveSetting(key, newValue);

      if (newValue) {
        await NotificationService.subscribeToTopic(key);
      } else {
        await NotificationService.unsubscribeFromTopic(key);
      }
    } catch (e) {
      debugPrint('NotificationProvider toggle error: $e');
    }
  }

  Future<void> subscribeToAll() async {
    for (final key in _settings.keys) {
      try {
        if (_settings[key]!) {
          await NotificationService.subscribeToTopic(key);
        } else {
          await NotificationService.unsubscribeFromTopic(key);
        }
      } catch (e) {
        debugPrint('NotificationProvider subscribeToAll error: $e');
      }
    }
  }
}
