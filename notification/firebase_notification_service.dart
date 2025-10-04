import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// 🔥 Simple Firebase Messaging handler class
/// Handles: Foreground, Background, and Terminated notification states
class FirebaseNotificationService {
  // Singleton instance (so you can call it anywhere)
  static final FirebaseNotificationService _instance =
      FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;
  FirebaseNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool _initialized = false;

  /// ✅ Initialize Firebase Messaging (call this in main.dart)
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Request notification permission (especially for iOS)
    await _requestPermission();

    // Print the FCM Token (useful for debugging or testing)
    String? token = await _fcm.getToken();
    debugPrint('📱 FCM Token: $token');

    // 🔹 Handle messages while app is in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 [Foreground message received]');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
    });

    // 🔹 When user taps on notification (app in Background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🧭 [App opened from background]');
      debugPrint('Data: ${message.data}');
    });

    // 🔹 When app is launched from a notification (Terminated)
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🚀 [App opened from terminated]');
      debugPrint('Data: ${initialMessage.data}');
    }
  }

  /// 🧩 Subscribe to a topic (e.g., "news", "updates")
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
    debugPrint('✅ Subscribed to topic: $topic');
  }

  /// 🧩 Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
    debugPrint('🚫 Unsubscribed from topic: $topic');
  }

  /// 📱 Ask for user permission (iOS only)
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');
  }
}
