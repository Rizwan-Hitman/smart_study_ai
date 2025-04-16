import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

// Initialize Local Notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point') // Needed for Android AlarmManager callback
Future<void> triggerNotification(int id) async {
  final prefs = await SharedPreferences.getInstance();

  String? title = prefs.getString('title_$id') ?? "Reminder";
  String? message = prefs.getString('message_$id') ?? "It's time!";

  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'study_channel_id',
    'Study Notifications',
    channelDescription: 'Channel for study reminders',
    importance: Importance.max,
    priority: Priority.high,
  );

  NotificationDetails details = NotificationDetails(android: androidDetails);
}

class AlarmService {
  static final AlarmService _instance = AlarmService._privateConstructor();

  factory AlarmService() {
    return _instance;
  }

  AlarmService._privateConstructor();
  Future<void> initialize() async {
    print("alarm service initalized");
  }

  Future<void> _checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('${pendingNotificationRequests.length} pending notification ');

    for (PendingNotificationRequest pendingNotificationRequest
        in pendingNotificationRequests) {
      print(
        pendingNotificationRequest.id.toString() +
            " " +
            (pendingNotificationRequest.payload ?? ""),
      );
    }
    print('NOW ' + tz.TZDateTime.now(tz.local).toString());
  }

  Future<void> scheduleNotification(
    int id,
    DateTime scheduledTime,
    String notificationTitle,
    String notificationMessage,
  ) async {
    print("Scheduling notification for id: $id at $scheduledTime");
    final location = tz.local;

    // Convert scheduledTime to TZDateTime
    tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, location);

    // Ensure the scheduled time is in the future
    if (tzScheduledTime.isBefore(tz.TZDateTime.now(location))) {
      print("Scheduled time is in the past. Skipping notification.");
      return;
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      notificationTitle,
      notificationMessage,
      // fix the timezone
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'study_channel',
          'Study Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),

      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    ); // Schedule the notification

    _checkPendingNotificationRequests();
    print("Notification scheduled successfully!");
  }
}
