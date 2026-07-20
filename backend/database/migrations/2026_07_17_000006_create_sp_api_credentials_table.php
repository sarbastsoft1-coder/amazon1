<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('sp_api_credentials', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->onDelete('cascade');
            $table->string('marketplace_id');
            $table->text('refresh_token');
            $table->string('client_id');
            $table->text('client_secret');
            $table->string('aws_access_key');
            $table->text('aws_secret_key');
            $table->string('role_arn');
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sp_api_credentials');
    }
};
