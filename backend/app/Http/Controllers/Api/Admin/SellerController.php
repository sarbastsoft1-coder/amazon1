<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Store;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class SellerController extends Controller
{
    public function index(Request $request)
    {
        $status = $request->input('status', 'all');
        $query = Store::with('owner')->whereHas('owner', function ($q) {
            $q->where('role', 'seller');
        });

        if (in_array($status, ['pending', 'approved', 'rejected'])) {
            $query->where('status', $status);
        }

        return response()->json($query->orderBy('created_at', 'desc')->paginate(20));
    }

    public function show(Store $store)
    {
        $store->load(['owner', 'kycDocuments.reviewer']);

        return response()->json([
            'id' => $store->id,
            'name' => $store->name,
            'slug' => $store->slug,
            'description' => $store->description,
            'logo' => $store->logo,
            'is_active' => $store->is_active,
            'status' => $store->status,
            'kyc_submitted_at' => $store->kyc_submitted_at?->toIso8601String(),
            'kyc_reviewed_at' => $store->kyc_reviewed_at?->toIso8601String(),
            'kyc_notes' => $store->kyc_notes,
            'created_at' => $store->created_at->toIso8601String(),
            'owner' => $store->owner,
            'kyc_documents' => $store->kycDocuments->map(function ($doc) {
                return [
                    'id' => $doc->id,
                    'document_type' => $doc->document_type,
                    'file_path' => $doc->file_path,
                    'status' => $doc->status,
                    'admin_notes' => $doc->admin_notes,
                    'reviewed_at' => $doc->reviewed_at?->toIso8601String(),
                    'reviewer' => $doc->reviewer,
                ];
            }),
        ]);
    }

    public function approve(Request $request, Store $store)
    {
        $validated = $request->validate([
            'notes' => ['nullable', 'string', 'max:1000'],
        ]);

        $store->update([
            'status' => 'approved',
            'is_active' => true,
            'kyc_reviewed_at' => now(),
            'kyc_notes' => $validated['notes'] ?? null,
        ]);

        $store->kycDocuments()
            ->where('status', 'pending')
            ->update([
                'status' => 'approved',
                'reviewed_by' => $request->user()->id,
                'reviewed_at' => now(),
            ]);

        return response()->json(['message' => 'Seller approved successfully.', 'store' => $store]);
    }

    public function reject(Request $request, Store $store)
    {
        $validated = $request->validate([
            'notes' => ['required', 'string', 'max:1000'],
        ]);

        $store->update([
            'status' => 'rejected',
            'is_active' => false,
            'kyc_reviewed_at' => now(),
            'kyc_notes' => $validated['notes'],
        ]);

        $store->kycDocuments()
            ->where('status', 'pending')
            ->update([
                'status' => 'rejected',
                'reviewed_by' => $request->user()->id,
                'reviewed_at' => now(),
                'admin_notes' => $validated['notes'],
            ]);

        return response()->json(['message' => 'Seller rejected successfully.', 'store' => $store]);
    }

    public function suspend(Request $request, Store $store)
    {
        $store->update([
            'is_active' => false,
            'status' => $store->status === 'approved' ? 'suspended' : $store->status,
        ]);

        return response()->json(['message' => 'Seller suspended successfully.', 'store' => $store]);
    }

    public function destroy(Store $store)
    {
        $store->delete();

        return response()->json(['message' => 'Seller deleted successfully.']);
    }
}
