import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class UserSurvey {
  // final String studyCategory; // Education, Programming, Custom, etc.
  // final String customSubject; // If "Custom" is selected
  final Duration targetDuration; // E.g., 30 days
  final Duration dailyStudyDuration; // E.g., 2 hours per day
  final List<String> preferredDays; // E.g., ["Monday", "Wednesday"]
  final List<String> preferredDates; // E.g., ["Monday", "Wednesday"]
  final TimeOfDay dailyAvailabilityTime; // Preferred time for notifications
  final List<String> attachedFiles; // PDF or image paths
  final String studyPlanId; // Education, Programming, Custom, etc.

  UserSurvey({
    // required this.studyCategory,
    // this.customSubject = "",
    required this.targetDuration,
    required this.dailyStudyDuration,
    required this.preferredDays,
    required this.preferredDates,
    required this.dailyAvailabilityTime,
    required this.attachedFiles,
    required this.studyPlanId,
  });

  /// Convert object to Map (for storing in DB/API)
  Map<String, dynamic> toMap() {
    return {
      // 'studyCategory': studyCategory,
      // 'customSubject': customSubject,
      'targetDuration': targetDuration.inDays,
      'dailyStudyDuration': dailyStudyDuration.inMinutes,
      'preferredDays': preferredDays,
      'preferredDates': preferredDates,
      'dailyAvailabilityTime': {
        'hour': dailyAvailabilityTime.hour,
        'minute': dailyAvailabilityTime.minute,
      },
      'attachedFiles': attachedFiles,
      'studyPlanId': studyPlanId,
    };
  }

  /// Convert Map to object (retrieving from DB/API)
  factory UserSurvey.fromMap(Map<String, dynamic> map) {
    return UserSurvey(
      // studyCategory: map['studyCategory'],
      // customSubject: map['customSubject'] ?? "",
      targetDuration: Duration(days: map['targetDuration'] as int),
      dailyStudyDuration: Duration(minutes: map['dailyStudyDuration'] as int),
      preferredDays: List<String>.from(map['preferredDays']),
      preferredDates: List<String>.from(map['preferredDates']),
      dailyAvailabilityTime: TimeOfDay(
        hour: map['dailyAvailabilityTime']['hour'],
        minute: map['dailyAvailabilityTime']['minute'],
      ),
      attachedFiles: List<String>.from(map['attachedFiles']),
      studyPlanId: map['studyPlanId'],
    );
  }

  Map<String, dynamic> toMapDatabase() {
    return {
      // 'studyCategory': studyCategory,
      // 'customSubject': customSubject,
      'targetDuration': targetDuration.inDays,
      'dailyStudyDuration': dailyStudyDuration.inMinutes,
      'preferredDays': jsonEncode(preferredDays),
      'preferredDates': jsonEncode(preferredDates),
      'dailyAvailabilityTime':
          '${dailyAvailabilityTime.hour}:${dailyAvailabilityTime.minute}',
      'attachedFiles': jsonEncode(attachedFiles),
      'studyPlanId': studyPlanId,
    };
  }

  factory UserSurvey.fromMapDatabase(Map<String, dynamic> map) {
    final timeParts = (map['dailyAvailabilityTime'] as String).split(':');
    return UserSurvey(
      // studyCategory: map['studyCategory'],
      // customSubject: map['customSubject'],
      targetDuration: Duration(days: map['targetDuration']),
      dailyStudyDuration: Duration(minutes: map['dailyStudyDuration']),
      preferredDays: List<String>.from(jsonDecode(map['preferredDays'])),
      preferredDates: List<String>.from(jsonDecode(map['preferredDates'])),
      dailyAvailabilityTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      attachedFiles: List<String>.from(jsonDecode(map['attachedFiles'])),
      studyPlanId: map['studyPlanId'],
    );
  }
}
