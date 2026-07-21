import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../data/providers/language_provider.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇮🇶'},
    {'code': 'ckb', 'name': 'کوردی (سۆرانی)', 'flag': '☀️'},
    {'code': 'ku', 'name': 'Kurdî (Badînî)', 'flag': '☀️'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Language'.tr(context))),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          return ListTile(
            leading: Text(lang['flag']!, style: TextStyle(fontSize: 24)),
            title: Text(lang['name']!),
            onTap: () {
              context.read<LanguageProvider>().setLanguage(lang['code']!);
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          );
        },
      ),
    );
  }
}
