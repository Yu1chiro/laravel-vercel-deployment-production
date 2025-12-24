
🚀 Instalasi Awal
1. Create Project Laravel & Install Filament
```bash
composer create-project laravel/laravel nama-project
composer require filament/filament:"^3.3" -W
php artisan filament:install --panels
```

🎨 Setup Tailwind CSS 3
2. Konfigurasi Vite
Edit file vite.config.js:
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
3. Setup App CSS
Edit file resources/css/app.css:
```bash
@tailwind base;
@tailwind components;
@tailwind utilities;
```
4. Konfigurasi Tailwind
Edit file tailwind.config.js:
```bash
@type {import('tailwindcss').Config} 
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
5. Install Dependencies Tailwind
```bash
npm install -D tailwindcss@3 postcss autoprefixer
npx tailwindcss init -p
```
🌐 Deploy ke Production (Vercel)
6. Update User Model
Edit file app/Models/User.php:
```bash
<?php

namespace App\Models;

use Filament\Models\Contracts\FilamentUser;
use Filament\Panel;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

// 2. Tambahkan "implements FilamentUser"
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

    // 3. Fungsi untuk akses panel di Production
    public function canAccessPanel(Panel $panel): bool
    {
        return $this->email === 'admin@gmail.com';
        
        // Opsional: gunakan return true untuk fast access tanpa validasi email
        // return true; 
    }
}
```
7. Konfigurasi Admin Panel Provider

Buka file app/Providers/Filament/AdminPanelProvider.php
Non-aktifkan ->registration() jika tidak diperlukan
Tambahkan ->spa() untuk performa lebih cepat

8. Update App Service Provider
Edit file app/Providers/AppServiceProvider.php:

```bash
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
       
        if($this->app->environment('production')) {
            URL::forceScheme('https');
        }
    }
}
```
9. Konfigurasi Vercel
Buat file vercel.json di root project:
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
10. Persiapan Sebelum Deploy
Jalankan perintah berikut sebelum git push:
```bash
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache
php artisan filament:cache-components
php artisan icons:cache
```
# Build assets
```bash
npm run build
```
# Clear Filament cache (opsional)
```bash
php artisan filament:optimize-clear
```

# Note :
Pastikan email di canAccessPanel() diganti sesuai kebutuhan
Jangan lupa set environment variables di Vercel dashboard
Versi PHP di vercel.json sudah fix, tidak perlu diubah
Konfigurasi ini sudah teruji untuk production