<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use App\Models\Store;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    public function run(): void
    {
        $admin = User::create([
            'name' => 'Admin User',
            'email' => 'admin@example.com',
            'password' => Hash::make('password'),
            'role' => 'admin',
        ]);

        $seller = User::create([
            'name' => 'Seller User',
            'email' => 'seller@example.com',
            'password' => Hash::make('password'),
            'role' => 'seller',
        ]);

        $buyer = User::create([
            'name' => 'Buyer User',
            'email' => 'buyer@example.com',
            'password' => Hash::make('password'),
            'role' => 'buyer',
        ]);

        $store = Store::create([
            'user_id' => $seller->id,
            'name' => 'Demo Store',
            'slug' => 'demo-store',
            'description' => 'A demo store for testing.',
        ]);

        $electronics = Category::create([
            'name' => 'Electronics',
            'slug' => 'electronics',
        ]);

        Category::create([
            'name' => 'Phones',
            'slug' => 'phones',
            'parent_id' => $electronics->id,
        ]);

        Category::create([
            'name' => 'Laptops',
            'slug' => 'laptops',
            'parent_id' => $electronics->id,
        ]);

        $fashion = Category::create([
            'name' => 'Fashion',
            'slug' => 'fashion',
        ]);

        Product::create([
            'store_id' => $store->id,
            'category_id' => $electronics->id,
            'name' => 'Wireless Headphones',
            'slug' => 'wireless-headphones',
            'description' => 'High-quality wireless headphones with noise cancellation.',
            'price' => 99.99,
            'compare_price' => 129.99,
            'stock' => 50,
            'sku' => 'WH-001',
            'images' => ['https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600&auto=format&fit=crop'],
            'amazon_asin' => 'B08HMWZBQP',
        ]);

        Product::create([
            'store_id' => $store->id,
            'category_id' => $fashion->id,
            'name' => 'Running Shoes',
            'slug' => 'running-shoes',
            'description' => 'Comfortable running shoes for everyday training.',
            'price' => 79.99,
            'stock' => 30,
            'sku' => 'RS-001',
            'images' => ['https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop'],
        ]);

        Product::create([
            'store_id' => $store->id,
            'category_id' => $electronics->id,
            'name' => 'Smart Watch',
            'slug' => 'smart-watch',
            'description' => 'Feature-rich smartwatch with health tracking and notifications.',
            'price' => 199.99,
            'compare_price' => 249.99,
            'stock' => 25,
            'sku' => 'SW-001',
            'images' => ['https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=600&auto=format&fit=crop'],
        ]);

        Product::create([
            'store_id' => $store->id,
            'category_id' => $fashion->id,
            'name' => 'Classic Sunglasses',
            'slug' => 'classic-sunglasses',
            'description' => 'Timeless UV400 polarized sunglasses.',
            'price' => 45.00,
            'stock' => 100,
            'sku' => 'SG-002',
            'images' => ['https://images.unsplash.com/photo-1511499767150-a48a237f0083?q=80&w=600&auto=format&fit=crop'],
        ]);

        $order = Order::create([
            'user_id' => $buyer->id,
            'store_id' => $store->id,
            'order_number' => 'ORD-' . strtoupper(Str::random(8)),
            'status' => 'pending',
            'subtotal' => 99.99,
            'tax' => 10.00,
            'shipping' => 0.00,
            'total' => 109.99,
            'shipping_address' => [
                'name' => 'Buyer User',
                'address' => '123 Main St',
                'city' => 'New York',
                'zip' => '10001',
            ],
            'billing_address' => [
                'name' => 'Buyer User',
                'address' => '123 Main St',
                'city' => 'New York',
                'zip' => '10001',
            ],
        ]);

        OrderItem::create([
            'order_id' => $order->id,
            'product_id' => Product::first()->id,
            'quantity' => 1,
            'price' => 99.99,
            'total' => 99.99,
        ]);
    }
}
