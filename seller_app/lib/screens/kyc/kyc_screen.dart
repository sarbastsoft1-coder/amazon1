import 'package:flutter/material.dart';
import '../../config/routes.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final _businessName = TextEditingController();
  final _taxId = TextEditingController();
  final _ownerName = TextEditingController();
  final _phone = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (mounted) Navigator.pushNamed(context, AppRoutes.storeInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Verification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Verification', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Please provide your business details for verification.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            TextField(controller: _businessName, decoration: const InputDecoration(labelText: 'Business Name')),
            const SizedBox(height: 16),
            TextField(controller: _taxId, decoration: const InputDecoration(labelText: 'Tax ID / VAT Number')),
            const SizedBox(height: 16),
            TextField(controller: _ownerName, decoration: const InputDecoration(labelText: 'Owner Full Name')),
            const SizedBox(height: 16),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading ? const CircularProgressIndicator() : const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
