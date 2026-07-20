<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\SpApiCredential;
use App\Services\AmazonSpApiService;
use Illuminate\Http\Request;

class SpApiController extends Controller
{
    protected AmazonSpApiService $spApi;

    public function __construct(AmazonSpApiService $spApi)
    {
        $this->spApi = $spApi;
    }

    public function saveCredentials(Request $request)
    {
        $data = $request->validate([
            'store_id' => 'required|exists:stores,id',
            'marketplace_id' => 'required|string',
            'refresh_token' => 'required|string',
            'client_id' => 'required|string',
            'client_secret' => 'required|string',
            'aws_access_key' => 'required|string',
            'aws_secret_key' => 'required|string',
            'role_arn' => 'required|string',
        ]);

        $store = \App\Models\Store::findOrFail($data['store_id']);
        $this->authorize('update', $store);

        $credential = SpApiCredential::updateOrCreate(
            ['store_id' => $data['store_id']],
            $data
        );

        return response()->json($credential);
    }

    public function syncProduct(Request $request, Product $product)
    {
        $this->authorize('update', $product->store);

        $credential = SpApiCredential::where('store_id', $product->store_id)->first();

        if (! $credential) {
            return response()->json(['message' => 'SP-API credentials not configured'], 422);
        }

        $this->spApi->syncProduct($product, $credential);

        return response()->json($product->fresh());
    }

    public function getPricing(Request $request)
    {
        $data = $request->validate([
            'store_id' => 'required|exists:stores,id',
            'asin' => 'required|string',
        ]);

        $store = \App\Models\Store::findOrFail($data['store_id']);
        $this->authorize('update', $store);

        $credential = SpApiCredential::where('store_id', $data['store_id'])->first();

        if (! $credential) {
            return response()->json(['message' => 'SP-API credentials not configured'], 422);
        }

        $pricing = $this->spApi->getProductPricing($credential, $data['asin']);

        return response()->json($pricing);
    }
}
