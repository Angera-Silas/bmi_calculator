import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

/// Integrates with the platform's notification system (Sprint 2.3).
///
/// Wraps [FlutterLocalNotificationsPlugin] using inexact alarms to avoid battery
/// drain and exact-alarm permission requirements. Standardises timezone
/// resolution via [flutter_timezone].
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Setup the local notification plugin and the local timezone database.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 1. Initialise timezone database & locate current device location
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      // 2. Initialise plugin settings with local launcher icon
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
      );

      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _initialized = true;
      debugPrint(
          'NotificationService successfully initialised in $timeZoneName timezone.');
    } catch (e, stack) {
      debugPrint('NotificationService init failure: $e\n$stack');
    }
  }

  /// Triggered when the user taps a notification. Payload is passed along
  /// to handle route/action routing if necessary.
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped with payload: ${response.payload}');
    // Sprint 2.3 routes are local settings, no deep-link routes requested yet.
  }

  /// Request POST_NOTIFICATIONS permission on Android 13+.
  /// Returns true if granted or not needed (below SDK 33).
  static Future<bool> requestPermission() async {
    try {
      final androidImplementation =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final granted =
            await androidImplementation.requestNotificationsPermission();
        return granted ?? false;
      }
    } catch (e) {
      debugPrint('Permission request error: $e');
    }
    return false;
  }

  /// Schedules a timezone-aware local notification at [fireAt].
  ///
  /// Uses [AndroidScheduleMode.inexactAllowWhileIdle] to fire when in standby
  /// without requiring system-level exact alarm permissions.
  static Future<void> schedule({
    required int notificationId,
    required DateTime fireAt,
    required String title,
    required String body,
    String? payload,
    String channelId = 'smart_reminders',
    String channelName = 'Smart Reminders',
    String channelDesc =
        'Actionable prompts for health tracking and challenges',
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      final scheduledDate = tz.TZDateTime.from(fireAt, tz.local);

      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(body),
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _plugin.zonedSchedule(
        id: notificationId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Failed to schedule notification #$notificationId: $e');
    }
  }

  /// Cancels a specific pending notification.
  static Future<void> cancel(int notificationId) async {
    if (!_initialized) return;
    await _plugin.cancel(id: notificationId);
  }

  /// Cancels all scheduled notifications entirely.
  static Future<void> cancelAll() async {
    if (!_initialized) return;
    await _plugin.cancelAll();
  }
}
