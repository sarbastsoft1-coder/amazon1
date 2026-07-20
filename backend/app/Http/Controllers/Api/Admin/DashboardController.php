<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Product;
use App\Models\Store;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function dashboard(Request $request)
    {
        return response()->json([
            'stats' => $this->getStats(),
            'pending_approvals' => $this->getPendingApprovals(),
            'recent_activities' => $this->getRecentActivities(),
            'notifications' => $this->getNotifications($request->user()),
            'recent_orders' => $this->getRecentOrders(),
        ]);
    }

    public function stats()
    {
        return response()->json($this->getStats());
    }

    private function getStats(): array
    {
        $today = now()->startOfDay();
        $todaySales = Order::where('status', '!=', 'cancelled')
            ->whereDate('created_at', $today)
            ->sum('total');

        $todayOrders = Order::where('status', '!=', 'cancelled')
            ->whereDate('created_at', $today)
            ->count();

        $revenue = Order::where('status', '!=', 'cancelled')->sum('total');

        return [
            'today_sales' => (float) $todaySales,
            'today_orders' => $todayOrders,
            'total_revenue' => (float) $revenue,
            'total_buyers' => User::where('role', 'buyer')->count(),
            'total_sellers' => User::where('role', 'seller')->count(),
            'total_users' => User::count(),
            'total_products' => Product::count(),
            'total_orders' => Order::count(),
            'active_auctions' => 0,
            'pending_approvals' => Store::where('status', 'pending')->count() + Product::where('status', 'pending')->count(),
            'system_health' => 'Healthy',
        ];
    }

    public function pendingApprovals()
    {
        return response()->json($this->getPendingApprovals());
    }

    private function getPendingApprovals(): array
    {
        $stores = Store::with('owner')
            ->where('status', 'pending')
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get();

        $products = Product::with('store')
            ->where('status', 'pending')
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get();

        return [
            'stores_count' => Store::where('status', 'pending')->count(),
            'products_count' => Product::where('status', 'pending')->count(),
            'stores' => $stores,
            'products' => $products,
        ];
    }

    public function activities()
    {
        return response()->json($this->getRecentActivities());
    }

    private function getRecentActivities(): array
    {
        $orders = Order::with('user')
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get()
            ->map(function ($order) {
                return [
                    'type' => 'order',
                    'message' => "Order {$order->order_number} placed by " . ($order->user?->name ?? 'Guest'),
                    'created_at' => $order->created_at->toIso8601String(),
                ];
            });

        $users = User::orderBy('created_at', 'desc')
            ->limit(5)
            ->get()
            ->map(function ($user) {
                return [
                    'type' => 'user',
                    'message' => "New {$user->role} {$user->name} joined",
                    'created_at' => $user->created_at->toIso8601String(),
                ];
            });

        $products = Product::orderBy('created_at', 'desc')
            ->limit(5)
            ->get()
            ->map(function ($product) {
                return [
                    'type' => 'product',
                    'message' => "Product {$product->name} added",
                    'created_at' => $product->created_at->toIso8601String(),
                ];
            });

        return $orders->merge($users)->merge($products)
            ->sortByDesc('created_at')
            ->values()
            ->take(10)
            ->all();
    }

    public function notifications(Request $request)
    {
        return response()->json($this->getNotifications($request->user()));
    }

    private function getNotifications(User $user): array
    {
        $unreadCount = $user->unreadNotifications()->count();

        $items = $user->notifications()
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($notification) {
                return [
                    'id' => $notification->id,
                    'message' => $notification->data['message'] ?? 'Notification',
                    'read' => $notification->read_at !== null,
                    'created_at' => $notification->created_at->toIso8601String(),
                ];
            });

        return [
            'unread_count' => $unreadCount,
            'items' => $items,
        ];
    }

    public function recentOrders(Request $request)
    {
        $orders = Order::with('user', 'store')
            ->orderBy('created_at', 'desc')
            ->paginate($request->input('per_page', 10));

        return response()->json($orders);
    }

    private function getRecentOrders(): array
    {
        return Order::with('user', 'store')
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get()
            ->map(function ($order) {
                return [
                    'id' => $order->id,
                    'order_number' => $order->order_number,
                    'status' => $order->status,
                    'total' => (float) $order->total,
                    'created_at' => $order->created_at->toIso8601String(),
                    'customer' => $order->user?->name,
                ];
            })
            ->toArray();
    }

    public function users(Request $request)
    {
        return response()->json(
            User::orderBy('created_at', 'desc')->paginate(20)
        );
    }

    public function stores(Request $request)
    {
        return response()->json(
            Store::with('owner')->orderBy('created_at', 'desc')->paginate(20)
        );
    }
}
