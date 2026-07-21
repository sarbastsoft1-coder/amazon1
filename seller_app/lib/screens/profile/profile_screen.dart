import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.secondaryColor,
                  child: Text('S', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Seller Store', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('seller@example.com', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildSectionTitle('Store'),
          _buildTile(context, Icons.store, 'Store Information', null),
          _buildTile(context, Icons.account_balance, 'Bank Account', null),
          _buildTile(context, Icons.local_shipping, 'Shipping Settings', null),
          _buildSectionTitle('Preferences'),
          _buildTile(context, Icons.notifications, 'Notification Settings', null),
          _buildTile(context, Icons.language, 'Language', null),
          _buildSectionTitle('Support'),
          _buildTile(context, Icons.help, 'Help Center', null),
          _buildTile(context, Icons.privacy_tip, 'Privacy Policy', null),
          _buildTile(context, Icons.description, 'Terms & Conditions', null),
          _buildTile(context, Icons.info, 'About', null),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, String? route) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.secondaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
    );
  }
}
