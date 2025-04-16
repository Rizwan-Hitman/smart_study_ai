import 'package:get/get.dart';
import 'package:ai_work_assistant/services/database_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

// Initialize Local Notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point') // ✅ Required for AlarmManager
Future<void> triggerAlarm(int id) async {
  print("triggering an alarm with id $id");

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    "alarm_channel",
    "Alarm Notifications",
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    id,
    "Alarm",
    "Time to do something!",
    details,
  );
}

class AlarmTestController extends GetxController {
  Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);
  final DatabaseHelper dbHelper = DatabaseHelper();
  RxList<Map<String, dynamic>> alarms = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAlarms();
    testAlarm();
    // cancelAlarm();
  }

  Future<void> pickDateTime(BuildContext context) async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    selectedDateTime.value = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  Future<void> scheduleNotification() async {
    var alarmPermission = await Permission.scheduleExactAlarm.status;
    alarmPermission.isDenied
        ? await Permission.scheduleExactAlarm.request()
        : print("alarm permission already granted");
    var notificationPermission = await Permission.notification.status;
    notificationPermission.isDenied
        ? await Permission.notification.request()
        : print("notification permission already granted");
    if (selectedDateTime.value == null) return;

    int alarmId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await dbHelper.insertAlarm(selectedDateTime.value!, alarmId);
    print("Selected date time ${selectedDateTime.value}");

    AndroidAlarmManager.oneShotAt(
      selectedDateTime.value!,
      alarmId,
      triggerAlarm,
      exact: true,
      wakeup: true,
    );

    fetchAlarms();
    Get.snackbar("Alarm Scheduled", "Alarm set for ${selectedDateTime.value}");
  }

  Future<void> fetchAlarms() async {
    alarms.value = await dbHelper.getAlarms();
  }

  void testAlarm() {
    int alarmId = 123;
    DateTime triggerTime = DateTime.now().add(Duration(seconds: 10));
    print("Auto alarm time : $triggerTime");

    AndroidAlarmManager.oneShotAt(
      triggerTime,
      alarmId,
      triggerAlarm,
      exact: true,
    );
  }

  void cancelAlarm() {
    AndroidAlarmManager.cancel(123);
  }
}
