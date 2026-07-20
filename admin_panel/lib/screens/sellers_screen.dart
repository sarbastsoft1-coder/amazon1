import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sellers_provider.dart';
import 'seller_detail_screen.dart';

class SellersScreen extends StatefulWidget {
  const SellersScreen({super.key});

  @override
  State<SellersScreen> createState() => _SellersScreenState();
}

class _SellersScreenState extends State<SellersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SellersProvider>().loadSellers();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SellersProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Sellers')),
      body: Column(
        children: [
          _buildFilterTabs(provider),
          Expanded(
            child: provider.loading && provider.sellers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : provider.sellers.isEmpty
                    ? const Center(child: Text('No sellers found.'))
                    : ListView.builder(
                        itemCount: provider.sellers.length,
                        itemBuilder: (context, index) {
                          final seller = provider.sellers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(seller.name.isNotEmpty ? seller.name[0] : 'S'),
                            ),
                            title: Text(seller.name),
                            subtitle: Text('Status: ${seller.status}'),
                            trailing: _StatusChip(status: seller.status),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SellerDetailScreen(sellerId: seller.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(SellersProvider provider) {
    final tabs = ['all', 'pending', 'approved', 'rejected'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        children: tabs.map((tab) {
          final isSelected = provider.statusFilter == tab;
          return ChoiceChip(
            label: Text(tab[0].toUpperCase() + tab.substring(1)),
            selected: isSelected,
            onSelected: (_) => provider.loadSellers(status: tab),
          );
        }).toList(),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

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
