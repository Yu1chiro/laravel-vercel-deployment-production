# Installasi Tailwind Css 3 
```bash 
npm install -D tailwindcss@3 postcss autoprefixer
```
# For deploy production on vercel :

1. Bagian models/ salin user.php copy all
2. Bagian providers/ non atkfikasn ->registration pada Fillament/AdminPanelProvider.php
3. Agar dashboard fillament kamu lebih cepat jangan lupa gunakan variabel ->spa()
4. Copy all AppServicesProvider.php untuk deploy ke vercel
5. Copy all vercel.json karena ini sudh fix untuk production versi php tidak perlu dirubah ini sudh versi terbaru.

# Jalankan perintah berikut di terminal sebelum git push
```bash
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
npm run build

```
