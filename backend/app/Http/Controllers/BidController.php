<?php

namespace App\Http\Controllers;

use App\Models\Bid;
use App\Models\Product;
use Illuminate\Http\Request;

class BidController extends Controller
{
    public function store(Request $request, Product $product)
    {
        $request->validate([
            'amount' => 'required|numeric',
        ]);

        if (!$product->is_auction) {
            return response()->json(['message' => 'This product is not an auction.'], 400);
        }

        if ($product->auction_end_time && $product->auction_end_time->isPast()) {
            return response()->json(['message' => 'This auction has already ended.'], 400);
        }

        $highestBid = $product->highest_bid;
        
        if ($request->amount <= $highestBid) {
            return response()->json([
                'message' => 'Your bid must be higher than the current highest bid.',
                'highest_bid' => $highestBid
            ], 400);
        }

        $bid = $product->bids()->create([
            'user_id' => $request->user()->id,
            'amount' => $request->amount,
        ]);

        return response()->json([
            'message' => 'Bid placed successfully!',
            'bid' => $bid,
            'highest_bid' => $product->highest_bid,
        ], 201);
    }
}
