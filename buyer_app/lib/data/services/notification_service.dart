import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/routes.dart';
import '../../core/navigator_key.dart';
import 'api_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static bool _permissionGranted = false;

  static String? _pendingInitialPayload;

  static bool get isInitialized => _initialized;
  static bool get permissionGranted => _permissionGranted;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('Notification permission denied');
        _permissionGranted = false;
        return;
      }

      _permissionGranted = true;

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _createNotificationChannel();
      const iosSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          if (details.payload != null && details.payload!.isNotEmpty) {
            _handlePayload(details.payload!);
          }
        },
      );

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      final token = await _messaging.getToken();
      if (token != null) {
        await _saveToken(token);
        await _sendTokenToBackend(token);
      }

      _messaging.onTokenRefresh.listen((token) async {
        await _saveToken(token);
        await _sendTokenToBackend(token);
      });

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _pendingInitialPayload = jsonEncode(initialMessage.data);
      }

      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService initialization error: $e');
    }
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  static Future<void> _sendTokenToBackend(String token) async {
    try {
      await ApiService.post('/fcm-token', {'token': token});
    } catch (e) {
      debugPrint('NotificationService _sendTokenToBackend error: $e');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _showLocalNotification(
      title: notification.title ?? 'Notification',
      body: notification.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    _handlePayload(jsonEncode(message.data));
  }

  static void _handlePayload(String payload) {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>?;
      if (data == null) return;
      debugPrint('Notification payload: $data');

      final type = data['type'] as String?;
      final id = data['id'] as int? ?? 0;

      switch (type) {
        case 'order':
          navigatorKey.currentState?.pushNamed(AppRoutes.orderDetails, arguments: {'orderId': id});
          break;
        case 'auction':
          navigatorKey.currentState?.pushNamed(AppRoutes.auctionDetails, arguments: {'auctionId': id});
          break;
        case 'offer':
          navigatorKey.currentState?.pushNamed(AppRoutes.productList, arguments: {'title': 'Offers'});
          break;
        case 'message':
          final sellerName = data['seller_name'] as String? ?? 'Seller';
          navigatorKey.currentState?.pushNamed(AppRoutes.chat, arguments: {'sellerName': sellerName});
          break;
      }
    } catch (e) {
      debugPrint('NotificationService _handlePayload error: $e');
    }
  }

  static Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );
    await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  static int _notificationId = 0;

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      _notificationId++,
      title,
      body,
      details,
      payload: payload,
    );
  }

  static void processPendingInitialPayload() {
    if (_pendingInitialPayload != null) {
      _handlePayload(_pendingInitialPayload!);
      _pendingInitialPayload = null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e) {
      debugPrint('NotificationService subscribeToTopic error: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e) {
      debugPrint('NotificationService unsubscribeFromTopic error: $e');
    }
  }
}
