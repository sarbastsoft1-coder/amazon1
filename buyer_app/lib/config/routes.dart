import 'package:flutter/material.dart';
import '../views/screens/auctions/auctions_screen.dart';
import '../views/screens/auth/forgot_password_screen.dart';
import '../views/screens/auth/language_screen.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/onboarding_screen.dart';
import '../views/screens/auth/otp_screen.dart';
import '../views/screens/auth/register_screen.dart';
import '../views/screens/auth/reset_password_screen.dart';
import '../views/screens/auth/splash_screen.dart';
import '../views/screens/cart/cart_screen.dart';
import '../views/screens/cart/checkout_screen.dart';
import '../views/screens/cart/order_success_screen.dart';
import '../views/screens/categories/categories_screen.dart';
import '../views/screens/home/main_screen.dart';
import '../views/screens/messages/messages_screen.dart';
import '../views/screens/notifications/notifications_screen.dart';
import '../views/screens/orders/orders_screen.dart';
import '../views/screens/product/product_details_screen.dart';
import '../views/screens/product/product_list_screen.dart';
import '../views/screens/product/search_screen.dart';
import '../views/screens/profile/profile_screen.dart';
import '../views/screens/profile/settings_screens.dart';
import '../views/screens/profile/support_screens.dart';
import '../views/screens/wishlist/wishlist_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String language = '/language';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String resetPassword = '/reset-password';
  static const String main = '/main';
  static const String productDetails = '/product-details';
  static const String productList = '/product-list';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String orderDetails = '/order-details';
  static const String trackOrder = '/track-order';
  static const String categories = '/categories';
  static const String categoryProducts = '/category-products';
  static const String auctions = '/auctions';
  static const String auctionDetails = '/auction-details';
  static const String wishlist = '/wishlist';
  static const String notifications = '/notifications';
  static const String messages = '/messages';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String addresses = '/addresses';
  static const String paymentMethods = '/payment-methods';
  static const String reviews = '/reviews';
  static const String languageSettings = '/language-settings';
  static const String currency = '/currency';
  static const String notificationSettings = '/notification-settings';
  static const String security = '/security';
  static const String changePassword = '/change-password';
  static const String helpCenter = '/help-center';
  static const String faq = '/faq';
  static const String contactSupport = '/contact-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String terms = '/terms';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case language:
        return MaterialPageRoute(builder: (_) => LanguageScreen());
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
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case productDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => ProductDetailsScreen(productId: args?['productId'] ?? 0));
      case productList:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => ProductListScreen(title: args?['title'] ?? 'Products'));
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case orderSuccess:
        return MaterialPageRoute(builder: (_) => const OrderSuccessScreen());
      case orderDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: args?['orderId'] ?? 0));
      case trackOrder:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => TrackOrderScreen(orderId: args?['orderId'] ?? 0));
      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case categoryProducts:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => CategoryProductsScreen(categoryId: args?['categoryId'] ?? 0, title: args?['title'] ?? 'Category'));
      case auctions:
        return MaterialPageRoute(builder: (_) => const AuctionsScreen());
      case auctionDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => ProductDetailsScreen(productId: args?['productId'] ?? 0));
      case wishlist:
        return MaterialPageRoute(builder: (_) => const WishlistScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case messages:
        return MaterialPageRoute(builder: (_) => const MessagesScreen());
      case chat:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => ChatScreen(sellerName: args?['sellerName'] ?? 'Seller'));
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case addresses:
        return MaterialPageRoute(builder: (_) => const AddressesScreen());
      case paymentMethods:
        return MaterialPageRoute(builder: (_) => const PaymentMethodsScreen());
      case reviews:
        return MaterialPageRoute(builder: (_) => const ReviewsScreen());
      case languageSettings:
        return MaterialPageRoute(builder: (_) => LanguageSettingsScreen());
      case currency:
        return MaterialPageRoute(builder: (_) => CurrencyScreen());
      case notificationSettings:
        return MaterialPageRoute(builder: (_) => NotificationSettingsScreen());
      case security:
        return MaterialPageRoute(builder: (_) => const SecurityScreen());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case helpCenter:
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());
      case faq:
        return MaterialPageRoute(builder: (_) => const FaqScreen());
      case contactSupport:
        return MaterialPageRoute(builder: (_) => const ContactSupportScreen());
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case terms:
        return MaterialPageRoute(builder: (_) => const TermsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
