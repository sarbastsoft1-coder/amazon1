<?php

use App\Http\Controllers\Api\Admin\DashboardController;
use App\Http\Controllers\Api\Admin\AdminProductController;
use App\Http\Controllers\Api\Admin\SellerController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\SpApiController;
use App\Http\Controllers\Api\StoreController;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Public Routes
Route::get('/products', [ProductController::class, 'index']);
Route::get('/products/{product}', [ProductController::class, 'show']);
Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/categories/{category}', [CategoryController::class, 'show']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    Route::get('/stores', [StoreController::class, 'index']);
    Route::get('/stores/{store}', [StoreController::class, 'show']);
    Route::post('/stores', [StoreController::class, 'store']);
    Route::put('/stores/{store}', [StoreController::class, 'update']);

    Route::post('/categories', [CategoryController::class, 'store'])->middleware('role:admin');

    Route::post('/products', [ProductController::class, 'store'])->middleware('role:seller');
    Route::put('/products/{product}', [ProductController::class, 'update'])->middleware('role:seller');
    Route::delete('/products/{product}', [ProductController::class, 'destroy'])->middleware('role:seller');

    Route::get('/orders', [OrderController::class, 'index']);
    Route::get('/orders/{order}', [OrderController::class, 'show']);
    Route::post('/orders', [OrderController::class, 'store'])->middleware('role:buyer');
    Route::put('/orders/{order}/status', [OrderController::class, 'updateStatus']);

    Route::prefix('sp-api')->middleware('role:seller')->group(function () {
        Route::post('/credentials', [SpApiController::class, 'saveCredentials']);
        Route::post('/products/{product}/sync', [SpApiController::class, 'syncProduct']);
        Route::get('/pricing', [SpApiController::class, 'getPricing']);
    });

    Route::prefix('admin')->middleware('role:admin')->group(function () {
        Route::get('/dashboard', [DashboardController::class, 'dashboard']);
        Route::get('/stats', [DashboardController::class, 'stats']);
        Route::get('/recent-orders', [DashboardController::class, 'recentOrders']);
        Route::get('/pending-approvals', [DashboardController::class, 'pendingApprovals']);
        Route::get('/activities', [DashboardController::class, 'activities']);
        Route::get('/notifications', [DashboardController::class, 'notifications']);
        Route::get('/users', [DashboardController::class, 'users']);
        Route::get('/stores', [DashboardController::class, 'stores']);

        Route::get('/sellers', [SellerController::class, 'index']);
        Route::get('/sellers/{store}', [SellerController::class, 'show']);
        Route::post('/sellers/{store}/approve', [SellerController::class, 'approve']);
        Route::post('/sellers/{store}/reject', [SellerController::class, 'reject']);
        Route::post('/sellers/{store}/suspend', [SellerController::class, 'suspend']);
        Route::delete('/sellers/{store}', [SellerController::class, 'destroy']);

        Route::get('/products', [AdminProductController::class, 'index']);
        Route::get('/products/{product}', [AdminProductController::class, 'show']);
        Route::post('/products/{product}/approve', [AdminProductController::class, 'approve']);
        Route::post('/products/{product}/reject', [AdminProductController::class, 'reject']);
        Route::delete('/products/{product}', [AdminProductController::class, 'destroy']);
    });
});
