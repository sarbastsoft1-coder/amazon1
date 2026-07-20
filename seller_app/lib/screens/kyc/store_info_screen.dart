import 'package:flutter/material.dart';
import '../../config/routes.dart';

class StoreInfoScreen extends StatefulWidget {
  const StoreInfoScreen({super.key});

  @override
  State<StoreInfoScreen> createState() => _StoreInfoScreenState();
}

class _StoreInfoScreenState extends State<StoreInfoScreen> {
  final _storeName = TextEditingController();
  final _description = TextEditingController();
  final _address = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Information')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Store Details', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Provide your store information for approval.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            TextField(controller: _storeName, decoration: const InputDecoration(labelText: 'Store Name')),
            const SizedBox(height: 16),
            TextField(controller: _description, decoration: const InputDecoration(labelText: 'Store Description'), maxLines: 3),
            const SizedBox(height: 16),
            TextField(controller: _address, decoration: const InputDecoration(labelText: 'Store Address'), maxLines: 2),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading ? const CircularProgressIndicator() : const Text('Submit for Approval'),
            ),
          ],
        ),
      ),
    );
  }
}
