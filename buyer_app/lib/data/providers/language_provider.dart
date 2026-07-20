import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadLanguage() async {
    final code = await ApiService.getLanguage();
    _locale = Locale(code ?? 'en');
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    await ApiService.setLanguage(code);
    _locale = Locale(code);
    notifyListeners();
  }
}
