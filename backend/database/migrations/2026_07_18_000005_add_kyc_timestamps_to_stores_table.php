<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('stores', function (Blueprint $table) {
            $table->timestamp('kyc_submitted_at')->nullable()->after('status');
            $table->timestamp('kyc_reviewed_at')->nullable()->after('kyc_submitted_at');
            $table->text('kyc_notes')->nullable()->after('kyc_reviewed_at');
        });
    }

    public function down(): void
    {
        Schema::table('stores', function (Blueprint $table) {
            $table->dropColumn(['kyc_submitted_at', 'kyc_reviewed_at', 'kyc_notes']);
        });
    }
};
