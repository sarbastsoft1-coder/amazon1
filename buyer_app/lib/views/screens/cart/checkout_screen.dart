import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../data/models/address.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/providers/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _delivery = 'Standard';
  String _payment = 'Credit Card';
  final _coupon = TextEditingController();
  final _address = Address(
    name: 'Buyer User',
    address: '123 Main St',
    city: 'New York',
    state: 'NY',
    zip: '10001',
    phone: '+1234567890',
  );
  bool _placing = false;

  Future<void> _placeOrder() async {
    setState(() => _placing = true);
    final cart = context.read<CartProvider>();
    final items = cart.items.map((item) => {
      'product_id': item.product.id,
      'quantity': item.quantity,
    }).toList();

    final order = await context.read<OrderProvider>().placeOrder({
      'store_id': 1,
      'items': items,
      'shipping_address': _address.toJson(),
      'billing_address': _address.toJson(),
    });

    setState(() => _placing = false);

    if (order != null && mounted) {
      cart.clear();
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.orderSuccess, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final shipping = _delivery == 'Express' ? 15.0 : 5.0;
    final tax = cart.total * 0.10;
    final total = cart.total + shipping + tax;

    return Scaffold(
      appBar: AppBar(title: Text('Checkout'.tr(context))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Shipping Address'),
            Card(
              child: ListTile(
                leading: Icon(Icons.location_on, color: AppTheme.primaryColor),
                title: Text(_address.name),
                subtitle: Text('${_address.address}, ${_address.city}, ${_address.state} ${_address.zip}'),
                trailing: TextButton(onPressed: () {}, child: Text('Change'.tr(context))),
              ),
            ),
            _buildSectionTitle('Delivery Method'),
            Row(
              children: [
                _buildDeliveryOption('Standard', '\$5.00'),
                _buildDeliveryOption('Express', '\$15.00'),
              ],
            ),
            _buildSectionTitle('Payment Method'),
            Card(
              child: Column(
                children: ['Credit Card', 'PayPal', 'Amazon Pay', 'Wallet'].map((m) {
                  final selected = _payment == m;
                  return ListTile(
                    leading: Icon(_paymentIcon(m), color: AppTheme.primaryColor),
                    title: Text(m),
                    trailing: Icon(
                      selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: selected ? AppTheme.primaryColor : Colors.grey,
                    ),
                    onTap: () => setState(() => _payment = m),
                  );
                }).toList(),
              ),
            ),
            _buildSectionTitle('Coupon'),
            Row(
              children: [
                Expanded(child: TextField(controller: _coupon, decoration: InputDecoration(hintText: 'Enter coupon code'.tr(context)))),
                SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: Text('Apply'.tr(context))),
              ],
            ),
            _buildSectionTitle('Order Summary'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryRow('Subtotal', '\$${cart.total.toStringAsFixed(2)}'),
                    _buildSummaryRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
                    _buildSummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
                    Divider(),
                    _buildSummaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _placing ? null : _placeOrder,
            child: _placing ? CircularProgressIndicator() : Text('Place Order'.tr(context)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  IconData _paymentIcon(String method) {
    return switch (method) {
      'Credit Card' => Icons.credit_card,
      'PayPal' => Icons.account_balance_wallet,
      'Amazon Pay' => Icons.payment,
      'Wallet' => Icons.wallet,
      _ => Icons.payment,
    };
  }

  Widget _buildDeliveryOption(String name, String price) {
    final selected = _delivery == name;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _delivery = name),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.grey[200],
            border: Border.all(color: selected ? AppTheme.primaryColor : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: selected ? AppTheme.primaryColor : Colors.black)),
              Text(price),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18) : null),
          Text(value, style: isTotal ? TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryColor) : null),
        ],
      ),
    );
  }
}
