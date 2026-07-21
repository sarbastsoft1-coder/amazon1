import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import '../../../config/routes.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 100, color: Colors.green),
              SizedBox(height: 24),
              Text('Order Placed!'.tr(context), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Thank you for your purchase. You will receive a confirmation email shortly.'.tr(context), textAlign: TextAlign.center),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false),
                child: Text('Continue Shopping'.tr(context)),
              ),
              SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false),
                child: Text('View Orders'.tr(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
