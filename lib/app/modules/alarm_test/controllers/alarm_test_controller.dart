import 'package:get/get.dart';
import 'package:ai_work_assistant/services/database_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  Rx<SpeechToText> speechToText = SpeechToText().obs;
  RxBool speechEnabled = false.obs;
  Rx<String> lastWords = ''.obs;
  RxBool isListening = false.obs;

  Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);
  final DatabaseHelper dbHelper = DatabaseHelper();
  RxList<Map<String, dynamic>> alarms = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    fetchAlarms();
    testAlarm();
    await checkPermissionsAndInitialize();
  }

  /// Request permissions and initialize SpeechToText
  Future<void> checkPermissionsAndInitialize() async {
    PermissionStatus micPermission = await Permission.microphone.request();

    if (micPermission.isGranted) {
      try {
        speechEnabled.value = await speechToText.value.initialize(
          onStatus: statusListener,
          onError: errorListener,
        );

        print('Speech initialized: ${speechEnabled.value}');
      } catch (e) {
        print('Error initializing SpeechToText: $e');
        speechEnabled.value = false;
      }
    } else {
      print('Microphone permission not granted');
      speechEnabled.value = false;
    }
  }

  /// Start listening to speech
  void startListening() async {
    if (!speechEnabled.value) {
      print('Speech not initialized or not available');
      return;
    }
    isListening.value = true;

    await speechToText.value.listen(onResult: (onSpeechResult));
  }

  /// Stop listening
  void stopListening() async {
    isListening.value = false;
    await speechToText.value.stop();
  }

  /// Callback when speech recognition returns results
  void onSpeechResult(SpeechRecognitionResult result) {
    lastWords.value = result.recognizedWords;
  }

  /// Status listener
  void statusListener(String status) {
    if (status == 'notListening') {
      isListening.value = false;
    } else if (status == 'listening') {
      isListening.value = true;
    }
    print('Speech Status: $status');
  }

  /// Error listener
  void errorListener(SpeechRecognitionError error) async {
    print('Speech Error: ${error.errorMsg}');
    speechEnabled.value = false;
    try {
      speechEnabled.value = await speechToText.value.initialize(
        onStatus: statusListener,
        onError: errorListener,
      );

      print('Speech initialized: ${speechEnabled.value}');
    } catch (e) {
      print('Error initializing SpeechToText: $e');
      speechEnabled.value = false;
    }
    speechEnabled.value = true;
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
