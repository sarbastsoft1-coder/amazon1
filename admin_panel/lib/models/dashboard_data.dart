class DashboardStats {
  final double todaySales;
  final int todayOrders;
  final double totalRevenue;
  final int totalBuyers;
  final int totalSellers;
  final int totalUsers;
  final int totalProducts;
  final int totalOrders;
  final int activeAuctions;
  final int pendingApprovals;
  final String systemHealth;

  DashboardStats({
    required this.todaySales,
    required this.todayOrders,
    required this.totalRevenue,
    required this.totalBuyers,
    required this.totalSellers,
    required this.totalUsers,
    required this.totalProducts,
    required this.totalOrders,
    required this.activeAuctions,
    required this.pendingApprovals,
    required this.systemHealth,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      todaySales: (json['today_sales'] ?? 0).toDouble(),
      todayOrders: json['today_orders'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      totalBuyers: json['total_buyers'] ?? 0,
      totalSellers: json['total_sellers'] ?? 0,
      totalUsers: json['total_users'] ?? 0,
      totalProducts: json['total_products'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      activeAuctions: json['active_auctions'] ?? 0,
      pendingApprovals: json['pending_approvals'] ?? 0,
      systemHealth: json['system_health'] ?? 'Unknown',
    );
  }
}

class PendingApprovals {
  final int storesCount;
  final int productsCount;
  final List<PendingStore> stores;
  final List<PendingProduct> products;

  PendingApprovals({
    required this.storesCount,
    required this.productsCount,
    required this.stores,
    required this.products,
  });

  factory PendingApprovals.fromJson(Map<String, dynamic> json) {
    return PendingApprovals(
      storesCount: json['stores_count'] ?? 0,
      productsCount: json['products_count'] ?? 0,
      stores: (json['stores'] as List? ?? [])
          .map((s) => PendingStore.fromJson(s as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List? ?? [])
          .map((p) => PendingProduct.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PendingStore {
  final int id;
  final String name;
  final String? ownerName;
  final String createdAt;

  PendingStore({
    required this.id,
    required this.name,
    this.ownerName,
    required this.createdAt,
  });

  factory PendingStore.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>?;
    return PendingStore(
      id: json['id'],
      name: json['name'],
      ownerName: owner?['name'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

class PendingProduct {
  final int id;
  final String name;
  final String? storeName;
  final String createdAt;

  PendingProduct({
    required this.id,
    required this.name,
    this.storeName,
    required this.createdAt,
  });

  factory PendingProduct.fromJson(Map<String, dynamic> json) {
    final store = json['store'] as Map<String, dynamic>?;
    return PendingProduct(
      id: json['id'],
      name: json['name'],
      storeName: store?['name'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

class Activity {
  final String type;
  final String message;
  final String createdAt;

  Activity({
    required this.type,
    required this.message,
    required this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      type: json['type'] ?? 'info',
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class AppNotification {
  final String id;
  final String message;
  final bool read;
  final String createdAt;

  AppNotification({
    required this.id,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      read: json['read'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class NotificationSummary {
  final int unreadCount;
  final List<AppNotification> items;

  NotificationSummary({
    required this.unreadCount,
    required this.items,
  });

  factory NotificationSummary.fromJson(Map<String, dynamic> json) {
    return NotificationSummary(
      unreadCount: json['unread_count'] ?? 0,
      items: (json['items'] as List? ?? [])
          .map((n) => AppNotification.fromJson(n as Map<String, dynamic>))
          .toList(),
    );
  }
}
