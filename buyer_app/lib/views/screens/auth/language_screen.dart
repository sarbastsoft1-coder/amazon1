import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../data/providers/language_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  final List<Map<String, String>> languages = const [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
    {'code': 'ar', 'name': 'Arabic', 'flag': '🇸🇦'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Language')),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          return ListTile(
            leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
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
