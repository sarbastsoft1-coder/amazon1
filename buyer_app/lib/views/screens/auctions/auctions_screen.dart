import 'package:flutter/material.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';

class AuctionsScreen extends StatefulWidget {
  const AuctionsScreen({super.key});

  @override
  State<AuctionsScreen> createState() => _AuctionsScreenState();
}

class _AuctionsScreenState extends State<AuctionsScreen> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auctions'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Live'), Tab(text: 'Upcoming'), Tab(text: 'Closed')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAuctionList('live'),
          _buildAuctionList('upcoming'),
          _buildAuctionList('closed'),
        ],
      ),
    );
  }

  Widget _buildAuctionList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.gavel, color: Colors.white),
            ),
            title: Text('Auction Item ${index + 1}'),
            subtitle: Text('Current Bid: \$${(50 + index * 10).toStringAsFixed(2)}'),
            trailing: Chip(
              label: Text(status),
              backgroundColor: status == 'live' ? Colors.green[100] : Colors.grey[200],
            ),
            onTap: () => Navigator.pushNamed(context, AppRoutes.auctionDetails, arguments: {'auctionId': index}),
          ),
        );
      },
    );
  }
}
