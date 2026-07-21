import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../data/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: Text('Profile'.tr(context))),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    user?.name.substring(0, 1).toUpperCase() ?? 'G',
                    style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Guest',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user?.email ?? 'guest@example.com',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                ),
              ],
            ),
          ),
          _buildSectionTitle('Account'.tr(context)),
          _buildTile(context, Icons.shopping_bag, 'My Orders'.tr(context), AppRoutes.orderDetails, {'orderId': 1}),
          _buildTile(context, Icons.favorite, 'Wishlist'.tr(context), AppRoutes.wishlist),
          _buildTile(context, Icons.location_on, 'Addresses'.tr(context), AppRoutes.addresses),
          _buildTile(context, Icons.credit_card, 'Payment Methods'.tr(context), AppRoutes.paymentMethods),
          _buildTile(context, Icons.star, 'My Reviews'.tr(context), AppRoutes.reviews),
          _buildSectionTitle('Preferences'.tr(context)),
          _buildTile(context, Icons.language, 'Language'.tr(context), AppRoutes.languageSettings),
          _buildTile(context, Icons.attach_money, 'Currency'.tr(context), AppRoutes.currency),
          _buildTile(context, Icons.notifications, 'Notification Settings'.tr(context), AppRoutes.notificationSettings),
          _buildSectionTitle('Security'.tr(context)),
          _buildTile(context, Icons.security, 'Security'.tr(context), AppRoutes.security),
          _buildSectionTitle('Support'.tr(context)),
          _buildTile(context, Icons.help, 'Help Center'.tr(context), AppRoutes.helpCenter),
          _buildTile(context, Icons.question_answer, 'FAQ'.tr(context), AppRoutes.faq),
          _buildTile(context, Icons.contact_support, 'Contact Support'.tr(context), AppRoutes.contactSupport),
          _buildTile(context, Icons.privacy_tip, 'Privacy Policy'.tr(context), AppRoutes.privacyPolicy),
          _buildTile(context, Icons.description, 'Terms & Conditions'.tr(context), AppRoutes.terms),
          _buildTile(context, Icons.info, 'About'.tr(context), null),
          ListTile(
            leading: Icon(auth.isAuthenticated ? Icons.logout : Icons.login, color: auth.isAuthenticated ? Colors.red : AppTheme.primaryColor),
            title: Text(auth.isAuthenticated ? 'Logout'.tr(context) : 'Login'.tr(context), style: TextStyle(color: auth.isAuthenticated ? Colors.red : AppTheme.primaryColor)),
            onTap: () async {
              if (auth.isAuthenticated) {
                await auth.logout();
              }
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, String? route, [Map<String, dynamic>? args]) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: route != null ? () => Navigator.pushNamed(context, route, arguments: args) : null,
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile'.tr(context))),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: InputDecoration(labelText: 'Name')),
            SizedBox(height: 16),
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 16),
            TextField(controller: _phone, decoration: InputDecoration(labelText: 'Phone')),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Save'.tr(context))),
          ],
        ),
      ),
    );
  }
}

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Addresses'.tr(context))),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              title: Text('Home'.tr(context)),
              subtitle: Text('123 Main St, New York, 10001'.tr(context)),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Methods'.tr(context))),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Icon(Icons.credit_card, color: AppTheme.primaryColor),
              title: Text('Visa ending in 4242'.tr(context)),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
          Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet, color: AppTheme.primaryColor),
              title: Text('Wallet Balance: \$50.00'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
    );
  }
}

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Reviews'.tr(context))),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Great product!'.tr(context)),
              subtitle: Text('Wireless Headphones - 5 stars'.tr(context)),
            ),
          );
        },
      ),
    );
  }
}
