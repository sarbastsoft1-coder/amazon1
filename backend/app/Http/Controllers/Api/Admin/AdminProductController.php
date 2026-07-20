<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class AdminProductController extends Controller
{
    public function index(Request $request)
    {
        $status = $request->input('status', 'all');
        $query = Product::with('store', 'category');

        if (in_array($status, ['pending', 'approved', 'rejected'])) {
            $query->where('status', $status);
        }

        return response()->json($query->orderBy('created_at', 'desc')->paginate(20));
    }

    public function show(Product $product)
    {
        $product->load('store', 'category');

        return response()->json($product);
    }

    public function approve(Request $request, Product $product)
    {
        $validated = $request->validate([
            'notes' => ['nullable', 'string', 'max:1000'],
        ]);

        $product->update([
            'status' => 'approved',
            'is_active' => true,
            'admin_notes' => $validated['notes'] ?? null,
        ]);

        return response()->json(['message' => 'Product approved successfully.', 'product' => $product]);
    }

    public function reject(Request $request, Product $product)
    {
        $validated = $request->validate([
            'notes' => ['required', 'string', 'max:1000'],
        ]);

        $product->update([
            'status' => 'rejected',
            'is_active' => false,
            'admin_notes' => $validated['notes'],
        ]);

        return response()->json(['message' => 'Product rejected successfully.', 'product' => $product]);
    }

    public function destroy(Product $product)
    {
        $product->delete();

        return response()->json(['message' => 'Product deleted successfully.']);
    }
}
