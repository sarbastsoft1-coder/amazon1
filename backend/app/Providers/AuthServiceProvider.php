<?php

namespace App\Providers;

use App\Models\Order;
use App\Models\Store;
use App\Policies\OrderPolicy;
use App\Policies\StorePolicy;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    protected $policies = [
        Store::class => StorePolicy::class,
        Order::class => OrderPolicy::class,
    ];

    public function boot(): void
    {
        $this->registerPolicies();
    }
}
