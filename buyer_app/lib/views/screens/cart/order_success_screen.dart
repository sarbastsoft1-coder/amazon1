import 'package:flutter/material.dart';
import '../../../config/routes.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              Text('Order Placed!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Thank you for your purchase. You will receive a confirmation email shortly.', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false),
                child: const Text('Continue Shopping'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false),
                child: const Text('View Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
