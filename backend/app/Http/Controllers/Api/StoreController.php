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
            'description' => 'required|string',
            'phone' => 'required|string|max:255',
            'address' => 'nullable|string',
        ]);

        $user = $request->user();
        $user->update([
            'phone' => $data['phone'],
            'address' => $data['address'] ?? null,
        ]);

        $storeData = [
            'name' => $data['name'],
            'description' => $data['description'],
            'slug' => Str::slug($data['name']),
            'user_id' => $user->id,
        ];

        $store = Store::create($storeData);

        return response()->json($store->load('owner'), 201);
    }

    public function update(Request $request, Store $store)
    {
        $this->authorize('update', $store);

        $data = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'description' => 'sometimes|required|string',
            'phone' => 'sometimes|required|string|max:255',
            'address' => 'nullable|string',
            'is_active' => 'sometimes|boolean',
        ]);

        $user = $request->user();
        $userUpdate = [];
        if (isset($data['phone'])) {
            $userUpdate['phone'] = $data['phone'];
        }
        if (array_key_exists('address', $data)) {
            $userUpdate['address'] = $data['address'];
        }
        if (!empty($userUpdate)) {
            $user->update($userUpdate);
        }

        $storeData = [];
        if (isset($data['name'])) {
            $storeData['name'] = $data['name'];
            $storeData['slug'] = Str::slug($data['name']);
        }
        if (isset($data['description'])) {
            $storeData['description'] = $data['description'];
        }
        if (isset($data['is_active'])) {
            $storeData['is_active'] = $data['is_active'];
        }

        if (!empty($storeData)) {
            $store->update($storeData);
        }

        return response()->json($store->load('owner'));
    }
}
