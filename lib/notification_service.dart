import 'dart:io';

// no Flutter imports required here
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Firebase Messaging removed; keep only local notifications

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings iosInit =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(initSettings);

    // Create Android notification channel (required on Android 8.0+)
    const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
      'messages_channel_id',
      'Messages',
      description: 'Incoming chat and match notifications',
      importance: Importance.high,
    );
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(androidChannel);

    if (Platform.isIOS || Platform.isMacOS) {
      await _local
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    // Request platform notification permissions using local notifications only
    if (Platform.isAndroid) {
      // Android 13+ requires POST_NOTIFICATIONS runtime permission; handled by plugin channels
      // No explicit call needed here; apps should still show notifications when allowed.
    } else if (Platform.isIOS || Platform.isMacOS) {
      // Already requested above via DarwinInitializationSettings
    }

    _initialized = true;
  }

  Future<void> showHeadsUp({
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'messages_channel_id',
      'Messages',
      channelDescription: 'Incoming chat and match notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'ticker',
      category: AndroidNotificationCategory.message,
      styleInformation: BigTextStyleInformation(body),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final NotificationDetails details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _local.show(DateTime.now().millisecondsSinceEpoch ~/ 1000, title, body,
        details,
        payload: payload);
  }
}




