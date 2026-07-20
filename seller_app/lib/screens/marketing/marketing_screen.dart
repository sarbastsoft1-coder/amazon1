import 'package:flutter/material.dart';
import '../../config/theme.dart';

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMarketingTile('Coupons', Icons.local_offer),
          _buildMarketingTile('Discount Campaigns', Icons.percent),
          _buildMarketingTile('Flash Sales', Icons.flash_on),
          _buildMarketingTile('Featured Products', Icons.star),
          _buildMarketingTile('Promotions', Icons.campaign),
        ],
      ),
    );
  }

  Widget _buildMarketingTile(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.secondaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
