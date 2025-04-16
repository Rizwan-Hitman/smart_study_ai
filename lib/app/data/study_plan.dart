import 'dart:convert';

class StudyPlan {
  final DateTime sessionDateTime; // Exact date & time of the session
  final Duration sessionDuration; // Duration of this session
  final List<String> topicsCovered; // Topics planned for this session
  final String studyPlanId; // Exact date & time of the session

  StudyPlan({
    required this.sessionDateTime,
    required this.sessionDuration,
    required this.topicsCovered,
    required this.studyPlanId,
  });

  /// Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'sessionDateTime': sessionDateTime.toIso8601String(),
      'sessionDuration': sessionDuration.inMinutes,
      'topicsCovered': topicsCovered,
      'studyPlanId': studyPlanId,
    };
  }

  /// Convert Map to object
  factory StudyPlan.fromMap(Map<String, dynamic> map) {
    return StudyPlan(
      sessionDateTime: DateTime.parse(map['sessionDateTime']),
      sessionDuration: Duration(minutes: map['sessionDuration'] as int),
      topicsCovered: List<String>.from(map['topicsCovered']),
      studyPlanId: map['studyPlanId'],
    );
  }

  Map<String, dynamic> toMapDatabase() {
    return {
      'sessionDateTime': sessionDateTime.toIso8601String(),
      'sessionDuration':
          sessionDuration.inMinutes.toString(), // store as string
      'topicsCovered': jsonEncode(topicsCovered),
      'studyPlanId': studyPlanId,
    };
  }

  factory StudyPlan.fromMapDatabase(Map<String, dynamic> map) {
    return StudyPlan(
      sessionDateTime: DateTime.parse(map['sessionDateTime']),
      sessionDuration: Duration(minutes: int.parse(map['sessionDuration'])),
      topicsCovered: List<String>.from(jsonDecode(map['topicsCovered'])),
      studyPlanId: map['studyPlanId'],
    );
  }
}
