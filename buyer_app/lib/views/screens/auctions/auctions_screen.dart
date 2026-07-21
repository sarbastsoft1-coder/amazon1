import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../data/providers/product_provider.dart';
import '../../widgets/common/countdown_timer.dart';

class AuctionsScreen extends StatefulWidget {
  const AuctionsScreen({super.key});

  @override
  State<AuctionsScreen> createState() => _AuctionsScreenState();
}

class _AuctionsScreenState extends State<AuctionsScreen> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<ProductProvider>().products.isEmpty) {
        context.read<ProductProvider>().fetchHomeData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auctions'.tr(context)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Live'.tr(context)),
            Tab(text: 'Upcoming'.tr(context)),
            Tab(text: 'Closed'.tr(context))
          ],
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final live = provider.auctions.where((p) => p.status == 'live').toList();
          final upcoming = provider.auctions.where((p) => p.status == 'upcoming').toList();
          final closed = provider.auctions.where((p) => p.status == 'closed').toList();
          
          return TabBarView(
            controller: _tabController,
            children: [
              _buildAuctionList(live, 'live'),
              _buildAuctionList(upcoming, 'upcoming'),
              _buildAuctionList(closed, 'closed'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAuctionList(List<dynamic> items, String status) {
    if (items.isEmpty) {
      return Center(child: Text('No $status auctions found'.tr(context)));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.gavel, color: Colors.white),
            ),
            title: Text(product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Bid: \$${(product.currentBid ?? product.startingBid ?? 0).toStringAsFixed(2)}'),
                SizedBox(height: 4),
                AuctionCountdownTimer(auctionStart: product.auctionStart, auctionEnd: product.auctionEnd),
              ],
            ),
            isThreeLine: true,
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.auctionDetails, arguments: {'productId': product.id}),
          ),
        );
      },
    );
  }
}

