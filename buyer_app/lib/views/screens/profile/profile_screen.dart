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
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
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
                    style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Guest',
                        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'guest@example.com',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile),
                ),
              ],
            ),
          ),
          _buildSectionTitle('Account'),
          _buildTile(context, Icons.shopping_bag, 'My Orders', AppRoutes.orderDetails, {'orderId': 1}),
          _buildTile(context, Icons.favorite, 'Wishlist', AppRoutes.wishlist),
          _buildTile(context, Icons.location_on, 'Addresses', AppRoutes.addresses),
          _buildTile(context, Icons.credit_card, 'Payment Methods', AppRoutes.paymentMethods),
          _buildTile(context, Icons.star, 'My Reviews', AppRoutes.reviews),
          _buildSectionTitle('Preferences'),
          _buildTile(context, Icons.language, 'Language', AppRoutes.languageSettings),
          _buildTile(context, Icons.attach_money, 'Currency', AppRoutes.currency),
          _buildTile(context, Icons.notifications, 'Notification Settings', AppRoutes.notificationSettings),
          _buildSectionTitle('Security'),
          _buildTile(context, Icons.security, 'Security', AppRoutes.security),
          _buildSectionTitle('Support'),
          _buildTile(context, Icons.help, 'Help Center', AppRoutes.helpCenter),
          _buildTile(context, Icons.question_answer, 'FAQ', AppRoutes.faq),
          _buildTile(context, Icons.contact_support, 'Contact Support', AppRoutes.contactSupport),
          _buildTile(context, Icons.privacy_tip, 'Privacy Policy', AppRoutes.privacyPolicy),
          _buildTile(context, Icons.description, 'Terms & Conditions', AppRoutes.terms),
          _buildTile(context, Icons.info, 'About', null),
          ListTile(
            leading: Icon(auth.isAuthenticated ? Icons.logout : Icons.login, color: auth.isAuthenticated ? Colors.red : AppTheme.primaryColor),
            title: Text(auth.isAuthenticated ? 'Logout' : 'Login', style: TextStyle(color: auth.isAuthenticated ? Colors.red : AppTheme.primaryColor)),
            onTap: () async {
              if (auth.isAuthenticated) {
                await auth.logout();
              }
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
          ),
          const SizedBox(height: 24),
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

  Widget _buildTile(BuildContext context, IconData icon, String title, String? route, [Map<String, dynamic>? args]) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
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
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 16),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save')),
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
      appBar: AppBar(title: const Text('Addresses')),
      body: ListView(
        children: const [
          Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              title: Text('Home'),
              subtitle: Text('123 Main St, New York, 10001'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: ListView(
        children: const [
          Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Icon(Icons.credit_card, color: AppTheme.primaryColor),
              title: Text('Visa ending in 4242'),
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
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reviews')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return const Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Great product!'),
              subtitle: Text('Wireless Headphones - 5 stars'),
            ),
          );
        },
      ),
    );
  }
}
