import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/seller.dart';
import '../providers/sellers_provider.dart';

class SellerDetailScreen extends StatefulWidget {
  final int sellerId;

  const SellerDetailScreen({super.key, required this.sellerId});

  @override
  State<SellerDetailScreen> createState() => _SellerDetailScreenState();
}

class _SellerDetailScreenState extends State<SellerDetailScreen> {
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SellersProvider>().loadSeller(widget.sellerId);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SellersProvider>();
    final seller = provider.selectedSeller;

    return Scaffold(
      appBar: AppBar(title: const Text('Seller Details')),
      body: provider.loading || seller == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(seller),
                  const SizedBox(height: 24),
                  _buildActions(context, provider, seller),
                  const SizedBox(height: 24),
                  _buildKycDocuments(seller),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(Seller seller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(seller.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Slug: ${seller.slug}'),
            const SizedBox(height: 8),
            Text('Status: ${seller.status.toUpperCase()}'),
            const SizedBox(height: 8),
            Text('Active: ${seller.isActive ? 'Yes' : 'No'}'),
            const SizedBox(height: 8),
            if (seller.kycSubmittedAt != null) Text('KYC Submitted: ${seller.kycSubmittedAt}'),
            if (seller.kycReviewedAt != null) Text('KYC Reviewed: ${seller.kycReviewedAt}'),
            if (seller.kycNotes != null && seller.kycNotes!.isNotEmpty)
              Text('Notes: ${seller.kycNotes}'),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, SellersProvider provider, Seller seller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (seller.status == 'pending')
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Review Notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            if (seller.status == 'pending') ...[
              ElevatedButton.icon(
                onPressed: () => _approve(provider, seller.id),
                icon: const Icon(Icons.check),
                label: const Text('Approve'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              ElevatedButton.icon(
                onPressed: () => _reject(provider, seller.id),
                icon: const Icon(Icons.close),
                label: const Text('Reject'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
            if (seller.status == 'approved')
              ElevatedButton.icon(
                onPressed: () => _suspend(provider, seller.id),
                icon: const Icon(Icons.pause),
                label: const Text('Suspend'),
              ),
            ElevatedButton.icon(
              onPressed: () => _delete(context, provider, seller.id),
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKycDocuments(Seller seller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('KYC Documents', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (seller.kycDocuments.isEmpty)
          const Text('No KYC documents submitted.'),
        ...seller.kycDocuments.map((doc) => Card(
              child: ListTile(
                leading: const Icon(Icons.description),
                title: Text(doc.documentType),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${doc.status}'),
                    if (doc.adminNotes != null) Text('Notes: ${doc.adminNotes}'),
                  ],
                ),
                trailing: _KycStatusChip(status: doc.status),
              ),
            )),
      ],
    );
  }

  Future<void> _approve(SellersProvider provider, int id) async {
    final ok = await provider.approveSeller(id, notes: _notesController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Seller approved.' : 'Failed to approve seller.')));
    }
  }

  Future<void> _reject(SellersProvider provider, int id) async {
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide rejection notes.')));
      return;
    }
    final ok = await provider.rejectSeller(id, notes: _notesController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Seller rejected.' : 'Failed to reject seller.')));
    }
  }

  Future<void> _suspend(SellersProvider provider, int id) async {
    final ok = await provider.suspendSeller(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Seller suspended.' : 'Failed to suspend seller.')));
    }
  }

  Future<void> _delete(BuildContext screenContext, SellersProvider provider, int id) async {
    final confirmed = await showDialog<bool>(
      context: screenContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Seller'),
        content: const Text('Are you sure you want to delete this seller? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      final ok = await provider.deleteSeller(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Seller deleted.' : 'Failed to delete seller.')));
        if (ok) Navigator.of(context).pop();
      }
    }
  }
}

class _KycStatusChip extends StatelessWidget {
  final String status;

  const _KycStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status.toUpperCase()),
      backgroundColor: color.withAlpha(26),
      labelStyle: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
    );
  }
}
