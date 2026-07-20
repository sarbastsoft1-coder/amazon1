<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Store extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'slug',
        'description',
        'logo',
        'is_active',
        'status',
        'kyc_submitted_at',
        'kyc_reviewed_at',
        'kyc_notes',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'kyc_submitted_at' => 'datetime',
        'kyc_reviewed_at' => 'datetime',
    ];

    public function owner()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function products()
    {
        return $this->hasMany(Product::class);
    }

    public function kycDocuments()
    {
        return $this->hasMany(KycDocument::class);
    }
}
