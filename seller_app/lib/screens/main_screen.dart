import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'dashboard/dashboard_screen.dart';
import 'orders/orders_screen.dart';
import 'products/products_screen.dart';
import 'profile/profile_screen.dart';
import 'wallet/wallet_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    ProductsScreen(),
    OrdersScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  final _items = const [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.inventory_2_rounded, label: 'Products'),
    _NavItem(icon: Icons.receipt_long_rounded, label: 'Orders'),
    _NavItem(icon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (i) => _buildItem(i)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int i) {
    final item = _items[i];
    final isSelected = _index == i;
    return Semantics(
      label: item.label,
      selected: isSelected,
      child: Tooltip(message: item.label, child: _buildNavItem(item, isSelected, i)),
    );
  }

  Widget _buildNavItem(_NavItem item, bool isSelected, int i) {
    return InkWell(
      onTap: () => setState(() => _index = i),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.secondaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isSelected ? AppTheme.secondaryColor : AppTheme.mutedTextColor,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected ? AppTheme.secondaryColor : AppTheme.mutedTextColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
