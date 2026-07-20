import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/cart_provider.dart';
import 'data/providers/language_provider.dart';
import 'data/providers/notification_provider.dart';
import 'data/providers/order_provider.dart';
import 'data/providers/product_provider.dart';
import 'data/providers/wishlist_provider.dart';
import 'data/services/notification_service.dart';
import 'core/navigator_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('NotificationService init skipped: $e');
  }
  runApp(const MyApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      NotificationService.processPendingInitialPayload();
    } catch (e) {
      debugPrint('NotificationService payload skipped: $e');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()..loadLanguage()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Amazon Buyer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
