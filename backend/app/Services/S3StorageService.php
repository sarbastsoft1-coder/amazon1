<?php

namespace App\Services;

use Aws\S3\S3Client;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

class S3StorageService
{
    protected ?S3Client $client = null;
    protected string $bucket;
    protected bool $enabled = false;

    public function __construct()
    {
        $key = config('filesystems.disks.s3.key');
        if (!empty($key) && $key !== 'your-aws-key' && $key !== 'your-key') {
            $this->client = new S3Client([
                'version' => 'latest',
                'region' => config('filesystems.disks.s3.region'),
                'credentials' => [
                    'key' => $key,
                    'secret' => config('filesystems.disks.s3.secret'),
                ],
            ]);
            $this->bucket = config('filesystems.disks.s3.bucket');
            $this->enabled = true;
        }
    }

    public function upload(UploadedFile $file, string $path = 'uploads'): string
    {
        if (!$this->enabled) {
            return 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=600&auto=format&fit=crop';
        }

        $filePath = $path . '/' . uniqid() . '_' . $file->getClientOriginalName();

        $this->client->putObject([
            'Bucket' => $this->bucket,
            'Key' => $filePath,
            'Body' => fopen($file->getRealPath(), 'r'),
            'ContentType' => $file->getMimeType(),
            'ACL' => 'public-read',
        ]);

        return $this->url($filePath);
    }

    public function uploadFromMemory(string $content, string $filePath, string $contentType = 'application/octet-stream'): string
    {
        $this->client->putObject([
            'Bucket' => $this->bucket,
            'Key' => $filePath,
            'Body' => $content,
            'ContentType' => $contentType,
            'ACL' => 'public-read',
        ]);

        return $this->url($filePath);
    }

    public function url(string $path): string
    {
        return config('filesystems.disks.s3.url') . '/' . $path;
    }

    public function delete(string $path): bool
    {
        $this->client->deleteObject([
            'Bucket' => $this->bucket,
            'Key' => $path,
        ]);

        return true;
    }
}
