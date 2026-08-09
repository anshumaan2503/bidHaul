import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification.dart';
import 'notification_service.dart';

/// Live Push Notification Service for BidHaul.
/// Triggers real System Tray notifications when new bids are placed,
/// functioning even when the app is minimized or running in background.
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationService _backendNotificationService = NotificationService();

  Timer? _pollingTimer;
  final Set<String> _seenNotificationIds = {};
  bool _initialized = false;

  /// Initialize native notification channels
  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint('User clicked push notification: ${details.payload}');
        },
      );

      // Create Android High-Priority Notification Channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'bidhaul_live_bids',
        'BidHaul Live Bids & Contracts',
        description: 'Instant notification alerts when bids are placed on tenders.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(channel);
        await androidImplementation.requestNotificationsPermission();
      }

      _initialized = true;
      debugPrint('PushNotificationService initialized successfully.');
    } catch (e) {
      debugPrint('PushNotificationService init error: $e');
    }
  }

  /// Trigger a live System Tray notification
  Future<void> showSystemNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await initialize();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'bidhaul_live_bids',
      'BidHaul Live Bids & Contracts',
      channelDescription: 'Instant notification alerts when bids are placed on tenders.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'BidHaul Live Alert',
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF0B0F19),
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing system push notification: $e');
    }
  }

  /// Start live background/foreground polling for unread bids
  void startLiveBidPolling({Duration interval = const Duration(seconds: 10)}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(interval, (_) => _checkNewBidsAndNotify());
    // Initial check
    _checkNewBidsAndNotify();
  }

  /// Stop polling
  void stopLiveBidPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _checkNewBidsAndNotify() async {
    try {
      final List<NotificationModel> unreadList =
          await _backendNotificationService.getUnreadNotifications(page: 0, size: 10);

      for (final notif in unreadList) {
        if (!_seenNotificationIds.contains(notif.id)) {
          _seenNotificationIds.add(notif.id);

          // Trigger System Tray Notification!
          final int notificationId = notif.id.hashCode & 0x7FFFFFFF;
          await showSystemNotification(
            id: notificationId,
            title: notif.title.isNotEmpty ? notif.title : '🏷️ New Bid Received!',
            body: notif.message,
            payload: notif.referenceId,
          );
        }
      }
    } catch (_) {
      // Ignore background fetch errors silently
    }
  }
}
