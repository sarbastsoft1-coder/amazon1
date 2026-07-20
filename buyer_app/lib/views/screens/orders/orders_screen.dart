import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../data/providers/order_provider.dart';
import '../../../data/providers/auth_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 7, vsync: this);

  final _tabs = const ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Returned', 'All'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().isAuthenticated) {
        context.read<OrderProvider>().fetchOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: !context.watch<AuthProvider>().isAuthenticated ? null : TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: !context.watch<AuthProvider>().isAuthenticated 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Please login to view your orders', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: const Text('Login'),
                  ),
                ],
              ),
            )
          : provider.loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                final orders = tab == 'All'
                    ? provider.orders
                    : provider.orders.where((o) => o.status.toLowerCase() == tab.toLowerCase()).toList();
                if (orders.isEmpty) return const Center(child: Text('No orders'));
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _statusColor(order.status),
                          child: Icon(_statusIcon(order.status), color: Colors.white),
                        ),
                        title: Text(order.orderNumber),
                        subtitle: Text('Status: ${order.status.toUpperCase()}\n${order.createdAt.toString().split(' ')[0]}'),
                        trailing: Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                        onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetails, arguments: {'orderId': order.id}),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
    );
  }

  Color _statusColor(String status) {
    return switch (status.toLowerCase()) {
      'pending' => Colors.orange,
      'processing' => Colors.blue,
      'shipped' => Colors.purple,
      'delivered' => Colors.green,
      'cancelled' => Colors.red,
      'returned' => Colors.grey,
      _ => AppTheme.primaryColor,
    };
  }

  IconData _statusIcon(String status) {
    return switch (status.toLowerCase()) {
      'pending' => Icons.hourglass_empty,
      'processing' => Icons.settings,
      'shipped' => Icons.local_shipping,
      'delivered' => Icons.check_circle,
      'cancelled' => Icons.cancel,
      'returned' => Icons.undo,
      _ => Icons.receipt,
    };
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #$orderId', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.headphones, color: AppTheme.primaryColor),
                title: Text('Wireless Headphones'),
                subtitle: Text('Quantity: 1'),
                trailing: Text('\$99.99'),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.location_on, color: AppTheme.primaryColor),
                title: Text('Shipping Address'),
                subtitle: Text('123 Main St, New York, 10001'),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.trackOrder, arguments: {'orderId': orderId}),
                child: const Text('Track Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackOrderScreen extends StatelessWidget {
  final int orderId;
  const TrackOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'Order Placed', 'subtitle': 'Pending', 'completed': true},
      {'title': 'Processing', 'subtitle': 'Preparing your order', 'completed': true},
      {'title': 'Shipped', 'subtitle': 'On the way', 'completed': false},
      {'title': 'Delivered', 'subtitle': 'Expected soon', 'completed': false},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #$orderId', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...steps.map((s) => _buildStep(s['title'] as String, s['subtitle'] as String, s['completed'] as bool)),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String subtitle, bool completed) {
    return ListTile(
      leading: Icon(completed ? Icons.check_circle : Icons.radio_button_unchecked, color: completed ? Colors.green : Colors.grey, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
