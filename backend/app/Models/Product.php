<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'store_id',
        'category_id',
        'name',
        'slug',
        'description',
        'price',
        'compare_price',
        'stock',
        'sku',
        'images',
        'is_active',
        'status',
        'admin_notes',
        'amazon_asin',
        'amazon_price',
        'amazon_fees',
        'synced_with_amazon',
        'is_auction',
        'auction_end_time',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'compare_price' => 'decimal:2',
        'amazon_price' => 'decimal:2',
        'amazon_fees' => 'decimal:2',
        'images' => 'array',
        'is_active' => 'boolean',
        'synced_with_amazon' => 'boolean',
        'is_auction' => 'boolean',
        'auction_end_time' => 'datetime',
    ];

    protected $appends = [
        'highest_bid',
    ];

    public function store()
    {
        return $this->belongsTo(Store::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    public function bids()
    {
        return $this->hasMany(Bid::class);
    }

    public function getHighestBidAttribute()
    {
        $highest = $this->bids()->max('amount');
        return $highest ?: $this->price;
    }
}
