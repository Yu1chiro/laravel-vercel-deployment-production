<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class ImageKitService
{
    /**
     * Upload mentah ke ImageKit tanpa SDK & tanpa GD.
     * Sangat aman untuk Vercel/Deployment.
     */
    public static function upload($file, string $fileName = 'upload'): ?string
    {
        try {
            // 1. Ambil konten file (Binary) menggunakan method get() yang lebih stabil
            $fileContent = $file->get();
            $base64 = base64_encode($fileContent);

            // 2. Siapkan nama file unik
            $extension = $file->getClientOriginalExtension();
            $fullFileName = $fileName . '_' . time() . '.' . $extension;

            // 3. Ambil Private Key dari config
            $privateKey = config('services.imagekit.private_key');

            // 4. Kirim via Laravel Http Client dengan format Multipart
            // ImageKit mengharuskan Private Key diletakkan di bagian Username (Basic Auth)
            $response = Http::withBasicAuth($privateKey, '')
                ->asMultipart()
                ->post('https://upload.imagekit.io/api/v1/files/upload', [
                    [
                        'name'     => 'file',
                        'contents' => $base64,
                    ],
                    [
                        'name'     => 'fileName',
                        'contents' => $fullFileName,
                    ],
                    [
                        'name'     => 'useUniqueFileName',
                        'contents' => 'true',
                    ],
                    [
                        'name'     => 'folder',
                        'contents' => '/users',
                    ],
                ]);

            // 5. Cek apakah request berhasil
            if ($response->successful()) {
                $result = $response->json();
                return $result['url']; // URL CDN ImageKit yang akan disimpan di DB
            }

            Log::error('ImageKit Upload Failed: ' . $response->body());
            return null;

        } catch (\Exception $e) {
            Log::error('ImageKit Exception: ' . $e->getMessage());
            return null;
        }
    }
}