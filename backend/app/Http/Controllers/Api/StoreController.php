<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Store;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class StoreController extends Controller
{
    public function index()
    {
        return response()->json(Store::with('owner')->where('is_active', true)->paginate(20));
    }

    public function show(Store $store)
    {
        return response()->json($store->load('owner', 'products'));
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $data['slug'] = Str::slug($data['name']);
        $data['user_id'] = $request->user()->id;

        $store = Store::create($data);

        return response()->json($store, 201);
    }

    public function update(Request $request, Store $store)
    {
        $this->authorize('update', $store);

        $data = $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
            'is_active' => 'sometimes|boolean',
        ]);

        if (isset($data['name'])) {
            $data['slug'] = Str::slug($data['name']);
        }

        $store->update($data);

        return response()->json($store);
    }
}
