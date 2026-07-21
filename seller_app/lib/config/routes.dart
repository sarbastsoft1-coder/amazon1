import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/language_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/kyc/store_info_screen.dart';
import '../screens/main_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/products/products_screen.dart';
import '../screens/products/add_product_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/orders/order_details_screen.dart';
import '../screens/sp_api_screen.dart';
import '../screens/auctions/auctions_screen.dart';
import '../screens/customers/customers_screen.dart';
import '../screens/marketing/marketing_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String language = '/language';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String resetPassword = '/reset-password';
  static const String storeInfo = '/store-info';
  static const String main = '/main';
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';
  static const String spApi = '/sp-api';
  static const String auctions = '/auctions';
  static const String customers = '/customers';
  static const String marketing = '/marketing';
  static const String analytics = '/analytics';
  static const String wallet = '/wallet';
  static const String messages = '/messages';
  static const String chat = '/chat';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case language:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case otp:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case storeInfo:
        return MaterialPageRoute(builder: (_) => const StoreInfoScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case products:
        return MaterialPageRoute(builder: (_) => const ProductsScreen());
      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      case editProduct:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => AddProductScreen(productId: args?['productId']));
      case orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case orderDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: args?['orderId'] ?? 0));
      case spApi:
        return MaterialPageRoute(builder: (_) => const SpApiScreen());
      case auctions:
        return MaterialPageRoute(builder: (_) => const AuctionsScreen());
      case customers:
        return MaterialPageRoute(builder: (_) => const CustomersScreen());
      case marketing:
        return MaterialPageRoute(builder: (_) => const MarketingScreen());
      case analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
      case wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case messages:
        return MaterialPageRoute(builder: (_) => const MessagesScreen());
      case chat:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => ChatScreen(buyerName: args?['buyerName'] ?? 'Buyer'));
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
