import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../data/providers/language_provider.dart';
import '../../../data/providers/notification_provider.dart';

class LanguageSettingsScreen extends StatelessWidget {
  LanguageSettingsScreen({super.key});

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'ar', 'name': 'Arabic'},
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.watch<LanguageProvider>().locale.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text('Language'.tr(context))),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          return ListTile(
            title: Text(lang['name']!),
            trailing: current == lang['code'] ? Icon(Icons.check, color: Colors.green) : null,
            onTap: () => context.read<LanguageProvider>().setLanguage(lang['code']!),
          );
        },
      ),
    );
  }
}

class CurrencyScreen extends StatelessWidget {
  CurrencyScreen({super.key});

  final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AED'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency'.tr(context))),
      body: ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(currencies[index]),
            trailing: index == 0 ? Icon(Icons.check, color: Colors.green) : null,
          );
        },
      ),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  NotificationSettingsScreen({super.key});

  final List<String> _topics = ['orders', 'offers', 'auctions', 'promotions', 'messages'];

  String _displayName(String topic) {
    return topic[0].toUpperCase() + topic.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Notification Settings'.tr(context))),
      body: ListView(
        children: _topics
            .map((topic) => SwitchListTile(
                  title: Text(_displayName(topic)),
                  subtitle: Text('Receive push notifications for $topic'),
                  value: provider.isEnabled(topic),
                  onChanged: (_) => provider.toggle(topic),
                ))
            .toList(),
      ),
    );
  }
}

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Security'.tr(context))),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'.tr(context)),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.changePassword),
          ),
          SwitchListTile(
            title: Text('Face ID / Fingerprint'.tr(context)),
            value: false,
            onChanged: null,
          ),
          SwitchListTile(
            title: Text('Two-Factor Authentication'.tr(context)),
            value: false,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password'.tr(context))),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _current, decoration: InputDecoration(labelText: 'Current Password'), obscureText: true),
            TextField(controller: _new, decoration: InputDecoration(labelText: 'New Password'), obscureText: true),
            TextField(controller: _confirm, decoration: InputDecoration(labelText: 'Confirm New Password'), obscureText: true),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Update Password'.tr(context))),
          ],
        ),
      ),
    );
  }
}
