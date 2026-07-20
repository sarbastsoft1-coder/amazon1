<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SpApiCredential extends Model
{
    use HasFactory;

    protected $fillable = [
        'store_id',
        'marketplace_id',
        'refresh_token',
        'client_id',
        'client_secret',
        'aws_access_key',
        'aws_secret_key',
        'role_arn',
        'is_active',
    ];

    protected $hidden = [
        'refresh_token',
        'client_secret',
        'aws_secret_key',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function store()
    {
        return $this->belongsTo(Store::class);
    }
}
