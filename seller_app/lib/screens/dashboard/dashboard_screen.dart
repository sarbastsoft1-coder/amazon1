import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Gradient app bar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A1F36), Color(0xFF2D3561)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: AppTheme.accentGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.store_rounded, color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back,',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'TechStore Official',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildSummaryCards(),
                  const SizedBox(height: 28),
                  _buildSectionTitle(context, 'Quick Actions'),
                  const SizedBox(height: 12),
                  _buildQuickActions(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle(context, 'Recent Orders'),
                  const SizedBox(height: 12),
                  _buildRecentOrders(),
                  const SizedBox(height: 28),
                  _buildSectionTitle(context, 'Inventory Alerts'),
                  const SizedBox(height: 12),
                  _buildInventoryAlerts(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final items = [
      {
        'title': "Today's Orders",
        'value': '12',
        'icon': Icons.shopping_bag_rounded,
        'gradient': const [Color(0xFFFF9900), Color(0xFFFFB84D)],
        'change': '+18%',
      },
      {
        'title': 'Revenue',
        'value': '\$1,250',
        'icon': Icons.trending_up_rounded,
        'gradient': const [Color(0xFF00C48C), Color(0xFF00E6A0)],
        'change': '+12%',
      },
      {
        'title': 'Pending',
        'value': '5',
        'icon': Icons.hourglass_top_rounded,
        'gradient': const [Color(0xFF4A90D9), Color(0xFF6BB5FF)],
        'change': '-3%',
      },
      {
        'title': 'Low Stock',
        'value': '3',
        'icon': Icons.inventory_rounded,
        'gradient': const [Color(0xFFFF4757), Color(0xFFFF6B7A)],
        'change': '+1',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.45,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final gradientColors = item['gradient'] as List<Color>;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradientColors),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors[0].withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(item['icon'] as IconData, color: Colors.white, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: gradientColors[0].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['change'] as String,
                      style: TextStyle(
                        color: gradientColors[0],
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['value'] as String,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(color: AppTheme.mutedTextColor, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'label': 'Add Product', 'icon': Icons.add_box_rounded, 'route': AppRoutes.addProduct, 'color': const Color(0xFFFF9900)},
      {'label': 'Orders', 'icon': Icons.receipt_long_rounded, 'route': AppRoutes.orders, 'color': const Color(0xFF4A90D9)},
      {'label': 'SP-API', 'icon': Icons.cloud_sync_rounded, 'route': AppRoutes.spApi, 'color': const Color(0xFF00C48C)},
      {'label': 'Analytics', 'icon': Icons.analytics_rounded, 'route': AppRoutes.analytics, 'color': const Color(0xFF9B59B6)},
      {'label': 'Messages', 'icon': Icons.chat_bubble_rounded, 'route': AppRoutes.messages, 'color': const Color(0xFFFF6B6B)},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final action = actions[index];
          final color = action['color'] as Color;
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, action['route'] as String),
            child: SizedBox(
              width: 72,
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: color.withValues(alpha: 0.15)),
                    ),
                    child: Icon(action['icon'] as IconData, color: color, size: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['label'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentOrders() {
    return Column(
      children: [
        _buildOrderTile('ORD-001', 'Pending', '\$99.99', const Color(0xFFFFAA00), Icons.hourglass_top_rounded),
        _buildOrderTile('ORD-002', 'Shipped', '\$199.99', const Color(0xFF4A90D9), Icons.local_shipping_rounded),
        _buildOrderTile('ORD-003', 'Delivered', '\$79.99', const Color(0xFF00C48C), Icons.check_circle_rounded),
      ],
    );
  }

  Widget _buildOrderTile(String orderNumber, String status, String total, Color statusColor, IconData statusIcon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(orderNumber, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Text(
            total,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryAlerts() {
    return Column(
      children: [
        _buildAlertTile('Wireless Headphones', 'Only 2 left in stock', const Color(0xFFFFAA00)),
        _buildAlertTile('Smart Watch Pro', 'Out of stock!', const Color(0xFFFF4757)),
      ],
    );
  }

  Widget _buildAlertTile(String product, String alert, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.warning_amber_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(alert, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppTheme.mutedTextColor.withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}
