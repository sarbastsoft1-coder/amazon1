<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class CategoryController extends Controller
{
    public function index()
    {
        return response()->json(Category::with('children')->whereNull('parent_id')->get());
    }

    public function show(Category $category)
    {
        return response()->json($category->load('children', 'products'));
    }

    public function store(Request $request)
    {
        $request->user()->isAdmin();

        $data = $request->validate([
            'name' => 'required|string|max:255',
            'parent_id' => 'nullable|exists:categories,id',
        ]);

        $data['slug'] = Str::slug($data['name']);

        $category = Category::create($data);

        return response()->json($category, 201);
    }
}
