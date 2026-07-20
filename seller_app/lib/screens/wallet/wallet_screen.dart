import 'package:flutter/material.dart';
import '../../config/theme.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppTheme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Balance', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    const Text('\$5,250.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Withdraw'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Recent Transactions'),
            _buildTransactionTile('Order Payment', '+\$99.99', '2026-07-18'),
            _buildTransactionTile('Withdrawal', '-\$500.00', '2026-07-17'),
            _buildTransactionTile('Order Payment', '+\$199.99', '2026-07-16'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTransactionTile(String title, String amount, String date) {
    final isPositive = amount.startsWith('+');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: isPositive ? Colors.green : Colors.red)),
      ),
    );
  }
}
