import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/theme.dart';
import '../models/dashboard_data.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import 'login_screen.dart';
import 'products_screen.dart';
import 'sellers_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardProvider>().loadDashboard();
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          _NotificationBell(count: provider.notifications.unreadCount),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellersScreen())),
            icon: const Icon(Icons.store_outlined),
            tooltip: 'Sellers',
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductsScreen())),
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Products',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: provider.loading && provider.stats.totalUsers == 0
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(provider.stats),
                  const SizedBox(height: 32),
                  _buildChartsSection(provider.stats),
                  const SizedBox(height: 32),
                  _buildPendingApprovalsSection(provider.pendingApprovals),
                  const SizedBox(height: 32),
                  _buildActivitiesSection(provider.activities),
                  const SizedBox(height: 32),
                  _buildRecentOrdersSection(provider.recentOrders),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF3730A3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back,', style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text(
                  'Administrator',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(DashboardStats stats) {
    final items = [
      _StatItem('Today\'s Sales', '\$${stats.todaySales.toStringAsFixed(2)}', Icons.attach_money, const Color(0xFF10B981)),
      _StatItem('Today\'s Orders', stats.todayOrders.toString(), Icons.shopping_bag, const Color(0xFF3B82F6)),
      _StatItem('Total Revenue', '\$${stats.totalRevenue.toStringAsFixed(2)}', Icons.account_balance_wallet, const Color(0xFF8B5CF6)),
      _StatItem('Total Users', stats.totalUsers.toString(), Icons.people, const Color(0xFFF59E0B)),
      _StatItem('Buyers', stats.totalBuyers.toString(), Icons.person, const Color(0xFF14B8A6)),
      _StatItem('Sellers', stats.totalSellers.toString(), Icons.store, const Color(0xFF6366F1)),
      _StatItem('Products', stats.totalProducts.toString(), Icons.inventory, const Color(0xFFEC4899)),
      _StatItem('Orders', stats.totalOrders.toString(), Icons.receipt_long, const Color(0xFF06B6D4)),
      _StatItem('Pending Approvals', stats.pendingApprovals.toString(), Icons.pending_actions, const Color(0xFFEF4444)),
      _StatItem('System Health', stats.systemHealth, Icons.health_and_safety, const Color(0xFF22C55E)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 5
            : constraints.maxWidth > 800
                ? 4
                : constraints.maxWidth > 500
                    ? 2
                    : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => _StatCard(item: items[index]),
        );
      },
    );
  }

  Widget _buildChartsSection(DashboardStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: BarChart(
            BarChartData(
              barGroups: [
                _makeBar(0, stats.totalUsers.toDouble(), 'Users'),
                _makeBar(1, stats.totalBuyers.toDouble(), 'Buyers'),
                _makeBar(2, stats.totalSellers.toDouble(), 'Sellers'),
                _makeBar(3, stats.totalProducts.toDouble(), 'Products'),
                _makeBar(4, stats.totalOrders.toDouble(), 'Orders'),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final labels = ['Users', 'Buyers', 'Sellers', 'Products', 'Orders'];
                      if (value >= 0 && value < labels.length) {
                        return Text(labels[value.toInt()], style: const TextStyle(fontSize: 10));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true),
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _makeBar(int x, double y, String label) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppTheme.primaryColor,
          width: 20,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildPendingApprovalsSection(PendingApprovals pending) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pending Approvals', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ApprovalCard(
                title: 'Stores',
                count: pending.storesCount,
                items: pending.stores.map((s) => s.name).toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ApprovalCard(
                title: 'Products',
                count: pending.productsCount,
                items: pending.products.map((p) => p.name).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivitiesSection(List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activities', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, index) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(_activityIcon(activity.type), color: AppTheme.primaryColor),
                ),
                title: Text(activity.message, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(activity.createdAt, style: const TextStyle(fontSize: 12)),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _activityIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_cart;
      case 'user':
        return Icons.person_add;
      case 'product':
        return Icons.add_box;
      default:
        return Icons.info;
    }
  }

  Widget _buildRecentOrdersSection(List<dynamic> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Orders', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppTheme.backgroundColor),
              columns: const [
                DataColumn(label: Text('Order #')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Date')),
              ],
              rows: orders.map((o) {
                return DataRow(cells: [
                  DataCell(Text(o['order_number'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600))),
                  DataCell(Text(o['status'] ?? '')),
                  DataCell(Text('\$${o['total'] ?? '0'}')),
                  DataCell(Text(o['created_at'] ?? '')),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _StatItem(this.title, this.value, this.icon, this.color);
}

class _StatCard extends StatelessWidget {
  final _StatItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: item.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(item.title, style: const TextStyle(fontSize: 12, color: AppTheme.mutedTextColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final String title;
  final int count;
  final List<String> items;

  const _ApprovalCard({
    required this.title,
    required this.count,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(count.toString(), style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.take(5).map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('• $item', style: const TextStyle(fontSize: 13, color: AppTheme.mutedTextColor)),
              )),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final int count;

  const _NotificationBell({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
            // TODO: open notifications panel
          },
          icon: const Icon(Icons.notifications_outlined),
        ),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppTheme.errorColor,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count > 9 ? '9+' : count.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
