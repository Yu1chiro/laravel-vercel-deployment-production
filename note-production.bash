# ===============================
# 0️⃣ LOGIN KE SERVER (DI LOCAL)
# ===============================
ssh user@ip_server
# login ke server via SSH
# pastikan user punya akses ke folder web (bukan root sembarangan)


# ===============================
# 1️⃣ MASUK KE DIREKTORI PROJECT
# ===============================
cd public_html
# masuk ke root website
# (Hostinger: public_html, VPS bisa /var/www/project)

ls
# cek file penting:
# - artisan
# - composer.json
# - .env.example
# kalau artisan tidak ada → salah folder


# ===============================
# 2️⃣ CEK ENVIRONMENT SERVER
# ===============================
php -v
# cek versi PHP
# pastikan sesuai requirement Laravel (>= 8.1)

composer -V
# cek apakah Composer terinstall
# kalau tidak ada → deploy STOP


# ===============================
# 3️⃣ CLONE PROJECT (PERTAMA KALI SAJA)
# ===============================
git clone https://github.com/username/repo.git .
# clone project ke folder ini
# tanda titik (.) artinya langsung ke public_html

# ⚠️ kalau pakai FTP:
# upload file project → pastikan strukturnya sama


# ===============================
# 4️⃣ SETUP FILE ENV (.env)
# ===============================
cp .env.example .env
# copy file env template

nano .env
# edit variabel penting:
# APP_NAME
# APP_ENV=production
# APP_DEBUG=false
# APP_URL=https://domainlu.com
# DB_DATABASE, DB_USERNAME, DB_PASSWORD
# CTRL+O → ENTER → CTRL+X


# ===============================
# 5️⃣ INSTALL DEPENDENCY (WAJIB PRODUCTION)
# ===============================
composer install --no-dev --optimize-autoloader
# --no-dev → buang package development
# --optimize-autoloader → performa production lebih cepat
# JANGAN pakai "composer install" biasa di production


# ===============================
# 6️⃣ GENERATE APP KEY
# ===============================
php artisan key:generate
# generate APP_KEY untuk enkripsi session & data
# error di sini = hampir pasti permission storage/cache


# ===============================
# 7️⃣ SET PERMISSION (PALING SERING JADI MASALAH)
# ===============================
chmod -R 775 storage bootstrap/cache
# Laravel butuh write access ke:
# - log
# - cache
# - session
# - compiled views

# kalau shared hosting rewel:
# chmod -R 777 storage bootstrap/cache
# (gunakan hanya jika perlu)


# ===============================
# 8️⃣ BACKUP DATABASE (SEBELUM MIGRATE)
# ===============================
# DISARANKAN sebelum migrate production
mysqldump -u db_user -p db_name > backup_before_migrate.sql
# backup database manual via SSH
# ini penyelamat kalau migrate error


# ===============================
# 9️⃣ MIGRATE DATABASE (PRODUCTION)
# ===============================
php artisan migrate --force
# jalankan migration TANPA hapus data
# --force wajib karena APP_ENV=production

# ❌ JANGAN PERNAH:
# php artisan migrate:fresh
# di production (DATA HILANG TOTAL)


# ===============================
# 🔟 STORAGE SYMLINK
# ===============================
php artisan storage:link
# hubungkan storage → public
# wajib kalau ada upload gambar / file


# ===============================
# 1️⃣1️⃣ CLEAR CACHE & OPTIMIZE
# ===============================
php artisan config:clear
# hapus cache config lama

php artisan route:clear
# hapus cache route

php artisan view:clear
# hapus cache blade

php artisan cache:clear
# hapus cache aplikasi

php artisan optimize
# rebuild cache untuk production (AMAN & DISARANKAN)


# ===============================
# 1️⃣2️⃣ SECURITY CHECK
# ===============================
php artisan env
# pastikan:
# APP_ENV = production
# APP_DEBUG = false
# kalau debug true → BAHAYA (info server bocor)

# pastikan file .env:
# - tidak ada di public folder
# - tidak bisa diakses via browser


# ===============================
# 1️⃣3️⃣ FRONTEND ASSET (VITE)
# ===============================
# RECOMMENDED WORKFLOW:
# - npm run build DI LOCAL
# - upload folder public/build ke server
# - JANGAN build di shared hosting kecuali terpaksa


# ===============================
# 1️⃣4️⃣ SANITY CHECK (TES CEPAT)
# ===============================
php artisan --version
# pastikan Laravel bisa jalan

php artisan route:list
# pastikan route ke-load tanpa error

# buka website:
# - login
# - CRUD
# - upload file


# ===============================
# 1️⃣5️⃣ CEK LOG JIKA ERROR
# ===============================
tail -f storage/logs/laravel.log
# lihat error real di production
# ini tempat pertama kalau muncul 500 error
