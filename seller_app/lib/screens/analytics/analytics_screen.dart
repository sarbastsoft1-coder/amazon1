import 'package:flutter/material.dart';
import '../../config/theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAnalyticsTile('Sales Report', Icons.bar_chart),
          _buildAnalyticsTile('Revenue Report', Icons.attach_money),
          _buildAnalyticsTile('Product Performance', Icons.inventory),
          _buildAnalyticsTile('Customer Analytics', Icons.people),
          _buildAnalyticsTile('Order Statistics', Icons.receipt_long),
          _buildAnalyticsTile('Export Reports', Icons.download),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTile(String title, IconData icon) {
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
