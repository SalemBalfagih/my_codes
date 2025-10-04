import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 🔥 Firebase Topic Notification Service (no UI)
/// Handles Foreground, Background, and Terminated notifications
class FirebaseTopicNotificationService {
  // Singleton
  static final FirebaseTopicNotificationService _instance =
      FirebaseTopicNotificationService._internal();
  factory FirebaseTopicNotificationService() => _instance;
  FirebaseTopicNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize the service
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Request permission (iOS)
    await _requestPermission();

    // Initialize local notifications (for foreground display)
    await _initLocalNotifications();

    // Listen for messages
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Handle messages when app is terminated
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) _onMessageOpenedApp(initialMessage);
  }

  /// Request permission (iOS)
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');
  }

  /// Initialize local notifications (optional, for foreground)
  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _localNotifications.initialize(initSettings);
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
    debugPrint('✅ Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
    debugPrint('🚫 Unsubscribed from topic: $topic');
  }

  /// Handle foreground messages
  void _onMessageReceived(RemoteMessage message) async {
    debugPrint('📩 Message from topic: ${message.from}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    // Show a local notification
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'topic_channel',
          'Topic Notifications',
          channelDescription: 'Notifications from Firebase topics',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// Handle notification clicks (Background / Terminated)
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('🧭 Notification clicked');
    debugPrint('Data: ${message.data}');

    // Example: navigate to a specific screen based on message data
    // if (message.data['screen'] == 'match') {
    //   Get.to(() => MatchDetailsScreen(id: message.data['match_id']));
    // }
  }
}
