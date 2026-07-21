<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\Store;
use App\Services\S3StorageService;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $query = Product::with('store', 'category')->where('is_active', true);

        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->has('store_id')) {
            $query->where('store_id', $request->store_id);
        }

        if ($request->has('q')) {
            $query->where('name', 'like', '%' . $request->q . '%');
        }

        return response()->json($query->paginate(20));
    }

    public function show(Product $product)
    {
        return response()->json($product->load('store', 'category'));
    }

    public function store(Request $request)
    {
        try {
            $data = $request->validate([
                'store_id' => 'required|exists:stores,id',
                'category_id' => 'nullable|exists:categories,id',
                'name' => 'required|string|max:255',
                'description' => 'nullable|string',
                'price' => 'required|numeric|min:0',
                'compare_price' => 'nullable|numeric|min:0',
                'stock' => 'required|integer|min:0',
                'sku' => 'nullable|string|max:255',
                'amazon_asin' => 'nullable|string|max:255',
                'is_auction' => 'boolean',
                'auction_end_time' => 'nullable|date',
            ]);

            $store = Store::findOrFail($data['store_id']);
            $this->authorize('update', $store);

            $data['slug'] = Str::slug($data['name']);
            $data['images'] = [];

            if ($request->hasFile('images')) {
                $s3 = new S3StorageService();
                foreach ($request->file('images') as $image) {
                    $data['images'][] = $s3->upload($image, 'products');
                }
            }

            $product = Product::create($data);

            return response()->json($product, 201);
        } catch (\Illuminate\Validation\ValidationException $e) {
            throw $e;
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to create product',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function update(Request $request, Product $product)
    {
        $this->authorize('update', $product->store);

        $data = $request->validate([
            'category_id' => 'nullable|exists:categories,id',
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'price' => 'sometimes|numeric|min:0',
            'compare_price' => 'nullable|numeric|min:0',
            'stock' => 'sometimes|integer|min:0',
            'sku' => 'nullable|string|max:255',
            'amazon_asin' => 'nullable|string|max:255',
            'is_active' => 'sometimes|boolean',
            'is_auction' => 'sometimes|boolean',
            'auction_end_time' => 'nullable|date',
        ]);

        if (isset($data['name'])) {
            $data['slug'] = Str::slug($data['name']);
        }

        if ($request->hasFile('images')) {
            $s3 = new S3StorageService();
            $images = $product->images ?? [];
            foreach ($request->file('images') as $image) {
                $images[] = $s3->upload($image, 'products');
            }
            $data['images'] = $images;
        }

        $product->update($data);

        return response()->json($product);
    }

    public function destroy(Product $product)
    {
        $this->authorize('update', $product->store);
        $product->delete();

        return response()->json(['message' => 'Product deleted']);
    }
}
