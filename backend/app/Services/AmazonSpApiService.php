<?php

namespace App\Services;

use App\Models\Product;
use App\Models\SpApiCredential;
use GuzzleHttp\Client;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

class AmazonSpApiService
{
    protected Client $http;

    public function __construct()
    {
        $this->http = new Client();
    }

    public function getAccessToken(SpApiCredential $credential): string
    {
        $cacheKey = 'sp_api_token_' . $credential->id;

        return Cache::remember($cacheKey, 3300, function () use ($credential) {
            $response = $this->http->post('https://api.amazon.com/auth/o2/token', [
                'form_params' => [
                    'grant_type' => 'refresh_token',
                    'refresh_token' => $credential->refresh_token,
                    'client_id' => $credential->client_id,
                    'client_secret' => $credential->client_secret,
                ],
            ]);

            $data = json_decode($response->getBody()->getContents(), true);

            return $data['access_token'];
        });
    }

    public function getMarketplaceUrl(string $marketplaceId): string
    {
        $endpoints = [
            'ATVPDKIKX0DER' => 'https://sellingpartnerapi-na.amazon.com',
            'A1F83G8C2IMDMH' => 'https://sellingpartnerapi-eu.amazon.com',
            'A1VC38T7YXB528' => 'https://sellingpartnerapi-fe.amazon.com',
        ];

        return $endpoints[$marketplaceId] ?? 'https://sellingpartnerapi-na.amazon.com';
    }

    public function getProductPricing(SpApiCredential $credential, string $asin)
    {
        try {
            $token = $this->getAccessToken($credential);
            $baseUrl = $this->getMarketplaceUrl($credential->marketplace_id);

            $response = $this->http->get($baseUrl . '/products/pricing/v0/price', [
                'headers' => [
                    'x-amz-access-token' => $token,
                ],
                'query' => [
                    'MarketplaceId' => $credential->marketplace_id,
                    'Asins' => $asin,
                    'ItemType' => 'Asin',
                ],
            ]);

            return json_decode($response->getBody()->getContents(), true);
        } catch (\Throwable $e) {
            Log::error('Amazon SP-API pricing error: ' . $e->getMessage());
            return null;
        }
    }

    public function syncProduct(Product $product, SpApiCredential $credential): void
    {
        if (! $product->amazon_asin) {
            return;
        }

        $pricing = $this->getProductPricing($credential, $product->amazon_asin);

        if (! empty($pricing['payload']['Offers'][0])) {
            $offer = $pricing['payload']['Offers'][0];
            $product->update([
                'amazon_price' => $offer['BuyingPrice']['ListingPrice']['Amount'] ?? null,
                'synced_with_amazon' => true,
            ]);
        }
    }

    public function createReport(SpApiCredential $credential, string $reportType, array $params = [])
    {
        try {
            $token = $this->getAccessToken($credential);
            $baseUrl = $this->getMarketplaceUrl($credential->marketplace_id);

            $response = $this->http->post($baseUrl . '/reports/2021-06-30/reports', [
                'headers' => [
                    'x-amz-access-token' => $token,
                    'Content-Type' => 'application/json',
                ],
                'json' => array_merge([
                    'reportType' => $reportType,
                    'marketplaceIds' => [$credential->marketplace_id],
                ], $params),
            ]);

            return json_decode($response->getBody()->getContents(), true);
        } catch (\Throwable $e) {
            Log::error('Amazon SP-API report error: ' . $e->getMessage());
            return null;
        }
    }
}
