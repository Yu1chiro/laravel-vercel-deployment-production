<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL; // Import di atas


class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

public function boot(): void
{
    // Paksa HTTPS jika di production (Vercel)
    if($this->app->environment('production')) {
        URL::forceScheme('https');
    }
}

}
