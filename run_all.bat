@echo off
echo Starting Backend Server...
start cmd /k "cd backend && php artisan serve"

echo Starting Buyer App...
start cmd /k "cd buyer_app && flutter run -d chrome"

echo Starting Seller App...
start cmd /k "cd seller_app && flutter run -d chrome"

echo Starting Admin Panel...
start cmd /k "cd admin_panel && flutter run -d chrome"

echo All processes have been launched in separate windows!
