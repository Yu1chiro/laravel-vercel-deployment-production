# Setup New Project Laravel + Fillament
```bash
composer create-project laravel/laravel nama-project
composer require filament/filament:"^3.3" -W
php artisan filament:install --panels
```

# Installasi Tailwind Css 3 

# setup vite config 
```bash
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
});

```
# Add app css from src 
```bash
/* App css for tailwind init  */
@tailwind base;
@tailwind components;
@tailwind utilities;
```
# setup tailwind config 
```bash
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./resources/**/*.blade.php",
    "./resources/**/*.js",
    "./resources/**/*.vue",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```
```bash 
npm install -D tailwindcss@3 postcss autoprefixer
npx tailwindcss init -p
```
# For deploy production on vercel :

1. Bagian models/ salin user.php copy all
```bash
<?php

namespace App\Models;

// 1. Panggil class yang dibutuhkan Filament
use Filament\Models\Contracts\FilamentUser;
use Filament\Panel;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

// 2. Tambahkan "implements FilamentUser" di sini
class User extends Authenticatable implements FilamentUser
{
    use HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    // 3. Tambahkan fungsi sakti ini.
    // Fungsi ini yang bertugas membuka pintu gerbang di Production.
    public function canAccessPanel(Panel $panel): bool
    {
     return $this->email === 'yukasan2005@gmail.com';
        //gunakan return true ini opsional for fast access nonatkfikasn fungsi registration
        // return true; 
    }
}
```
2. Bagian providers/ non atkfikasn ->registration pada Fillament/AdminPanelProvider.php
3. Agar dashboard fillament kamu lebih cepat jangan lupa gunakan variabel ->spa()
4. Copy all AppServicesProvider.php untuk deploy ke vercel
```bash
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

```
5. Copy all vercel.json karena ini sudh fix untuk production versi php tidak perlu dirubah ini sudh versi terbaru.
```bash
{
    "version": 2,
    "framework": null,
    "functions": {
        "api/index.php": { "runtime": "vercel-php@0.7.1" }
    },
    "routes": [
        {
            "src": "/(build|assets|css|js|images|storage|favicon.ico|robots.txt)(.*)",
            "dest": "/public/$1$2"
        },
        { "src": "/(.*)", "dest": "/api/index.php" }
    ],
    "public": true,
    "buildCommand": "vite build",
    "outputDirectory": "public",
    "env": {
        "APP_ENV": "production",
        "APP_DEBUG": "true",
        "APP_URL": "",
        "APP_CONFIG_CACHE": "/tmp/config.php",
        "APP_EVENTS_CACHE": "/tmp/events.php",
        "APP_PACKAGES_CACHE": "/tmp/packages.php",
        "APP_ROUTES_CACHE": "/tmp/routes.php",
        "APP_SERVICES_CACHE": "/tmp/services.php",
        "VIEW_COMPILED_PATH": "/tmp",
        "CACHE_STORE": "array",
        "LOG_CHANNEL": "stderr",
        "SESSION_DRIVER": "cookie",
        "DB_CONNECTION": "pgsql",
        "DB_HOST": "",
        "DB_PORT": "5432",
        "DB_DATABASE": "",
        "DB_USERNAME": ""
    }
}
```
# Jalankan perintah berikut di terminal sebelum git push
```bash
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
npm run build
```
# Jika menggunakan fillament kamu bisa gunakan perintah berikut sebelum set to production
```bash
php artisan filament:optimize-clear
```
