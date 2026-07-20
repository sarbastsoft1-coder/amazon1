# Amazon Project

Full-stack e-commerce platform with Flutter frontend apps, Laravel REST API, PostgreSQL, Redis, S3, and Amazon Selling Partner API (SP-API) integration.

## Architecture

```text
                Flutter Buyer App
                       |
                Flutter Seller App
                       |
            Flutter Web Admin Panel
                       |
               Laravel REST API
                       |
      +----------------+----------------+
      |                |                |
 PostgreSQL        Redis Cache       Amazon SP-API
      |                |                |
      +---------- Storage (S3) ---------+
```

## Project Structure

```
amazon/
├── backend/          # Laravel REST API
├── buyer_app/        # Flutter buyer mobile app
├── seller_app/       # Flutter seller mobile app
├── admin_panel/      # Flutter web admin panel
├── docker-compose.yml
└── README.md
```

## Requirements

- PHP 8.2+
- Composer
- Node.js (for Laravel assets if needed)
- PostgreSQL 16
- Redis 7
- Flutter SDK 3.x
- Docker & Docker Compose (optional)
- AWS account with S3 bucket
- Amazon Selling Partner API credentials

## Backend Setup

### Option 1: With Docker

1. Start services:
   ```bash
   docker-compose up -d postgres redis
   ```

2. Install PHP dependencies:
   ```bash
   cd backend
   composer install
   ```

3. Copy environment file and configure:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. Run migrations and seeders:
   ```bash
   php artisan migrate:fresh --seed
   ```

5. Start the development server:
   ```bash
   php artisan serve
   ```

### Option 2: Without Docker (Local SQLite for quick testing)

1. Update `backend/.env`:
   ```env
   DB_CONNECTION=sqlite
   DB_DATABASE=/absolute/path/to/backend/database/database.sqlite
   CACHE_STORE=file
   SESSION_DRIVER=file
   ```

2. Run migrations and seeders:
   ```bash
   php artisan migrate:fresh --seed
   php artisan serve
   ```

## API Documentation

All API endpoints are prefixed with `/api` and require authentication via Sanctum token, except `POST /api/register` and `POST /api/login`.

### Authentication
- `POST /api/register` - Register a new user (role: buyer, seller, admin)
- `POST /api/login` - Login and receive token
- `POST /api/logout` - Logout current user
- `GET /api/me` - Get current user

### Stores
- `GET /api/stores`
- `GET /api/stores/{store}`
- `POST /api/stores`
- `PUT /api/stores/{store}`

### Categories
- `GET /api/categories`
- `GET /api/categories/{category}`
- `POST /api/categories` (admin)

### Products
- `GET /api/products`
- `GET /api/products/{product}`
- `POST /api/products` (seller)
- `PUT /api/products/{product}` (seller)
- `DELETE /api/products/{product}` (seller)

### Orders
- `GET /api/orders`
- `GET /api/orders/{order}`
- `POST /api/orders` (buyer)
- `PUT /api/orders/{order}/status`

### Amazon SP-API (seller)
- `POST /api/sp-api/credentials` - Save SP-API credentials
- `POST /api/sp-api/products/{product}/sync` - Sync product with Amazon
- `GET /api/sp-api/pricing` - Get Amazon pricing for ASIN

### Admin
- `GET /api/admin/stats`
- `GET /api/admin/recent-orders`
- `GET /api/admin/users`
- `GET /api/admin/stores`

## Flutter Apps Setup

### Buyer App

```bash
cd buyer_app
flutter pub get
flutter run
```

For Android emulator, the API base URL is `http://10.0.2.2:8000/api`.
For physical device, update `lib/services/api_service.dart` with your machine IP.

### Seller App

```bash
cd seller_app
flutter pub get
flutter run
```

### Admin Panel (Web)

```bash
cd admin_panel
flutter pub get
flutter run -d chrome
```

For web, the API base URL is `http://localhost:8000/api`.

## Demo Accounts

After seeding, the following accounts are available:

| Email               | Password | Role   |
|---------------------|----------|--------|
| admin@example.com   | password | admin  |
| seller@example.com  | password | seller |
| buyer@example.com   | password | buyer  |

## AWS S3 Configuration

Update `backend/.env` with your S3 credentials:

```env
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=your-bucket
AWS_URL=https://your-bucket.s3.amazonaws.com
```

## Amazon SP-API Configuration

1. Register your application in Amazon Seller Central.
2. Complete OAuth authorization to get a refresh token.
3. Save credentials via the seller app or API endpoint.

## Docker Compose Services

- `postgres` - PostgreSQL database on port 5432
- `redis` - Redis cache on port 6379
- `backend` - Laravel API on port 8000

Start all services:

```bash
docker-compose up -d
```

## Testing

Run Laravel tests:

```bash
cd backend
php artisan test
```

## Notes

- The project uses Laravel Sanctum for API authentication.
- Redis is used for caching and sessions.
- S3 is used for file uploads (product images, store logos).
- SP-API integration is scaffolded and requires real Amazon credentials to function.
- The Flutter apps use Provider for state management.

## License

This project is for demonstration purposes.
