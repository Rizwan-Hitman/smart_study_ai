import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommonMethods {
  static void showScaffoldMessenger(String message) {
    Get.rawSnackbar(
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(10),
      backgroundColor: Colors.black87,
      borderRadius: 8,
      duration: Duration(seconds: 2),
      isDismissible: false,
      forwardAnimationCurve: Curves.easeOut,
      animationDuration: Duration(milliseconds: 10),
    );
  }

  static hideScaffoldMessenger(BuildContext context) {
    Get.rawSnackbar().close();
  }

  static int hoursFormat(int hours) {
    if (hours > 12) {
      return hours - 12;
    } else {
      return hours;
    }
  }

  static String formattedDuration(int duration) {
    int totalMinutes = duration;
    String formattedDuration =
        totalMinutes >= 60
            ? "${totalMinutes ~/ 60} hour${totalMinutes ~/ 60 > 1 ? 's' : ''}"
                "${totalMinutes % 60 > 0 ? ' ${totalMinutes % 60} min' : ''}"
            : "$totalMinutes min";
    return formattedDuration;
  }

  static String toDateString(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  static List<String> getPreferredDates(
    List<String> preferredDays,
    DateTime start,
    DateTime end,
  ) {
    List<String> matchedDates = [];
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    for (
      DateTime date = start;
      date.isBefore(end.add(Duration(days: 1)));
      date = date.add(Duration(days: 1))
    ) {
      String dayName = DateFormat('EEEE').format(date);
      if (preferredDays.contains(dayName)) {
        matchedDates.add(formatter.format(date));
      }
    }

    return matchedDates;
  }

  static int calculateDuration(TimeOfDay from, TimeOfDay to) {
    int fromMinutes = from.hour * 60 + from.minute;
    int toMinutes = to.hour * 60 + to.minute;

    // Handle cases where 'to' is on the next day
    if (toMinutes < fromMinutes) {
      toMinutes += 24 * 60; // Add 24 hours to 'to' time
    }

    return (toMinutes - fromMinutes).clamp(
      0,
      24 * 60,
    ); // Ensure within valid range
  }

  static String generateRandomId() {
    final random = Random.secure();
    final List<int> bytes = List.generate(
      32,
      (_) => random.nextInt(256),
    ); // 16 random bytes
    return base64Url.encode(
      Uint8List.fromList(bytes),
    ); // Convert to base64 URL-safe string
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MMMM-dd EEEE hh:mm a').format(dateTime);
  }
}
