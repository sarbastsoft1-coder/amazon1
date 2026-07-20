<?php

namespace App\Services;

use Aws\S3\S3Client;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

class S3StorageService
{
    protected S3Client $client;
    protected string $bucket;

    public function __construct()
    {
        $this->client = new S3Client([
            'version' => 'latest',
            'region' => config('filesystems.disks.s3.region'),
            'credentials' => [
                'key' => config('filesystems.disks.s3.key'),
                'secret' => config('filesystems.disks.s3.secret'),
            ],
        ]);
        $this->bucket = config('filesystems.disks.s3.bucket');
    }

    public function upload(UploadedFile $file, string $path = 'uploads'): string
    {
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
