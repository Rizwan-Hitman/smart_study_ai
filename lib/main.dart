import 'package:ai_work_assistant/app/routes/app_pages.dart';
import 'package:ai_work_assistant/firebase_options.dart';
import 'package:ai_work_assistant/services/alarm_service.dart';
import 'package:ai_work_assistant/services/database_service.dart';
import 'package:ai_work_assistant/services/remoteconfig_services.dart';
import 'package:ai_work_assistant/utills/app_variables.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Top-level function for handling background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  developer.log("Received a message in background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize Local Notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  try {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    bool? isNewUser = sharedPreferences.getBool('isNewUser');
    if (isNewUser != null) {
      AppVariables.isNewUser = isNewUser;
    } else {
      AppVariables.isNewUser = true;
      await sharedPreferences.setBool('isNewUser', true);
    }
  } catch (e) {
    developer.log("Error initializing SharedPreferences: $e");
    AppVariables.isNewUser = false; // Fallback value
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await AndroidAlarmManager.initialize();
  await AlarmService().initialize();
  RemoteConfigService().initialize();
  await DatabaseHelper.instance.database;

  // 1. Initialize timezone database
  tz.initializeTimeZones();

  // 2. Get user's timezone from native device
  final String localTimeZone = await FlutterTimezone.getLocalTimezone();

  // 3. Set it for tz package
  tz.setLocalLocation(tz.getLocation(localTimeZone));
  print(tz.local);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    observer.analytics.setAnalyticsCollectionEnabled(kReleaseMode);

    return GetMaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
