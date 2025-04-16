import 'dart:convert';

import 'package:ai_work_assistant/app/data/study_plan.dart';

class CompleteStudyPlan {
  final String studyPlanId; // To link with UserSurvey
  final String studyPlanTitle; // To link with UserSurvey
  final List<String> attachedFiles; // To link with UserSurvey
  final List<DateTime> studySessions; // Exact date & time for each session
  final Duration estimatedStudyDuration; // Expected duration per session
  final List<String> topicNames; // Overall topics user will study
  final List<StudyPlan> studyPlanPatches; // Each session's study breakdown

  CompleteStudyPlan({
    required this.studyPlanId,
    required this.studyPlanTitle,
    required this.attachedFiles,
    required this.studySessions,
    required this.estimatedStudyDuration,
    required this.topicNames,
    required this.studyPlanPatches,
  });

  /// Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'studyPlanId': studyPlanId,
      'studyPlanTitle': studyPlanTitle,
      'attachedFiles': attachedFiles,
      'studySessions': studySessions.map((s) => s.toIso8601String()).toList(),
      'estimatedStudyDuration': estimatedStudyDuration.inMinutes,
      'topicNames': topicNames,
      'studyPlanPatches': studyPlanPatches.map((p) => p.toMap()).toList(),
    };
  }

  /// Convert Map to object
  factory CompleteStudyPlan.fromMap(Map<String, dynamic> map) {
    return CompleteStudyPlan(
      studyPlanId: map['studyPlanId'],
      studyPlanTitle: map['studyPlanTitle'],
      attachedFiles: map['attachedFiles'],
      studySessions:
          List<String>.from(
            map['studySessions'],
          ).map((s) => DateTime.parse(s)).toList(),
      estimatedStudyDuration: Duration(
        minutes: map['estimatedStudyDuration'] as int,
      ),
      topicNames: List<String>.from(map['topicNames']).map((e) => e).toList(),
      studyPlanPatches:
          List<Map<String, dynamic>>.from(
            map['studyPlanPatches'],
          ).map((p) => StudyPlan.fromMap(p)).toList(),
    );
  }

  Map<String, dynamic> toMapDatabase() {
    return {
      'studyPlanId': studyPlanId,
      'studyPlanTitle': studyPlanTitle,
      'attachedFiles': jsonEncode(attachedFiles),
      'studySession': jsonEncode(
        studySessions.map((e) => e.toIso8601String()).toList(),
      ),
      'estimatedStudyDuration': estimatedStudyDuration.inMinutes,
      'topicNames': jsonEncode(topicNames),
    };
  }

  factory CompleteStudyPlan.fromMapDatabase(
    Map<String, dynamic> map,
    List<StudyPlan> studyPlanPatches,
  ) {
    return CompleteStudyPlan(
      studyPlanId: map['studyPlanId'],
      studyPlanTitle: map['studyPlanTitle'] ?? "oldEntries",
      attachedFiles:
          map['attachedFiles'] != null
              ? List<String>.from(json.decode(map['attachedFiles']))
              : ["Introduction to System Security & Communication"],

      studySessions:
          List<String>.from(
            jsonDecode(map['studySession']),
          ).map((e) => DateTime.parse(e)).toList(),
      estimatedStudyDuration: Duration(minutes: map['estimatedStudyDuration']),
      topicNames: List<String>.from(jsonDecode(map['topicNames'])),
      studyPlanPatches:
          studyPlanPatches, // populate separately from studyPlanTable
    );
  }

  List<int> getAlarmIds() {
    return studySessions
        .map((e) => e.millisecondsSinceEpoch.remainder(1000000))
        .toList();
  }
}
