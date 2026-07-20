<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $query = Order::with('items.product', 'store');

        if ($user->isBuyer()) {
            $query->where('user_id', $user->id);
        } elseif ($user->isSeller()) {
            $query->whereHas('store', fn ($q) => $q->where('user_id', $user->id));
        }

        return response()->json($query->orderBy('created_at', 'desc')->paginate(20));
    }

    public function show(Request $request, Order $order)
    {
        $this->authorize('view', $order);

        return response()->json($order->load('items.product', 'store', 'user'));
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'store_id' => 'required|exists:stores,id',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
            'shipping_address' => 'required|array',
            'billing_address' => 'required|array',
        ]);

        $user = $request->user();

        $order = DB::transaction(function () use ($data, $user) {
            $subtotal = 0;

            $order = Order::create([
                'user_id' => $user->id,
                'store_id' => $data['store_id'],
                'order_number' => 'ORD-' . strtoupper(Str::random(8)),
                'status' => 'pending',
                'shipping_address' => $data['shipping_address'],
                'billing_address' => $data['billing_address'],
                'subtotal' => 0,
                'tax' => 0,
                'shipping' => 0,
                'total' => 0,
            ]);

            foreach ($data['items'] as $item) {
                $product = Product::findOrFail($item['product_id']);
                $total = $product->price * $item['quantity'];
                $subtotal += $total;

                $order->items()->create([
                    'product_id' => $product->id,
                    'quantity' => $item['quantity'],
                    'price' => $product->price,
                    'total' => $total,
                ]);

                $product->decrement('stock', $item['quantity']);
            }

            $tax = round($subtotal * 0.10, 2);
            $shipping = round($subtotal > 100 ? 0 : 10, 2);
            $total = $subtotal + $tax + $shipping;

            $order->update([
                'subtotal' => $subtotal,
                'tax' => $tax,
                'shipping' => $shipping,
                'total' => $total,
            ]);

            return $order;
        });

        return response()->json($order->load('items.product'), 201);
    }

    public function updateStatus(Request $request, Order $order)
    {
        $this->authorize('update', $order);

        $data = $request->validate([
            'status' => 'required|string|in:pending,processing,shipped,delivered,cancelled',
        ]);

        $order->update($data);

        return response()->json($order);
    }
}
