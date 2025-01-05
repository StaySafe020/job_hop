import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './notification_model.dart';

class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  factory NotificationHandler() {
    return _instance;
  }

  NotificationHandler._internal();

  Future<void> initialize() async {
    // Request permission
    await _requestPermissions();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Handle different notification scenarios
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessageStatic);

    // Check for initial message
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification permissions granted');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    print('Handling foreground message: ${message.messageId}');
    
    NotificationModel notification = NotificationModel(
      id: message.messageId ?? DateTime.now().toString(),
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      type: message.data['type'] ?? 'general',
      timestamp: DateTime.now(),
      data: message.data,
    );

    // Show local notification
    await _showLocalNotification(notification);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('Handling background message: ${message.messageId}');
    // Handle navigation based on notification type
    _handleNotificationNavigation(message.data);
  }

  static Future<void> _handleBackgroundMessageStatic(RemoteMessage message) async {
    print('Handling static background message: ${message.messageId}');
  }

  void _handleInitialMessage(RemoteMessage message) {
    print('Handling initial message: ${message.messageId}');
    _handleNotificationNavigation(message.data);
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'job_application':
        // Navigate to application details
        break;
      case 'new_message':
        // Navigate to chat
        break;
      case 'job_update':
        // Navigate to job details
        break;
      default:
        // Navigate to notifications list
        break;
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    if (response.payload != null) {
      Map<String, dynamic> data = {};
      // Parse payload and handle navigation
      _handleNotificationNavigation(data);
    }
  }

  Future<void> _showLocalNotification(NotificationModel notification) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: notification.id,
    );
  }

  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  void subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  void unsubscribeFromTopic(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}