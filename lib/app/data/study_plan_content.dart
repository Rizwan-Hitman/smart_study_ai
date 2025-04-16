import 'dart:convert';

class StudyContent {
  final String topicTitle;
  final String topicContent;
  final int topicIndex; // Topics planned for this session
  final String studyPlanId; // Exact date & time of the session

  StudyContent({
    required this.topicTitle,
    required this.topicContent,
    required this.topicIndex,
    required this.studyPlanId,
  });

  /// Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'topicTitle': topicTitle,
      'topicContent': topicContent,
      'topicIndex': topicIndex,
      'studyPlanId': studyPlanId,
    };
  }

  /// Convert Map to object
  factory StudyContent.fromMap(Map<String, dynamic> map) {
    return StudyContent(
      topicTitle: map['topicTitle'],
      topicContent: map['topicContent'],
      studyPlanId: map['studyPlanId'],
      topicIndex: map['topicIndex'],
    );
  }

  Map<String, dynamic> toMapDatabase() {
    return {
      'topicTitle': topicTitle,
      'topicContent': topicContent, // store as string
      'topicIndex': topicIndex,
      'studyPlanId': studyPlanId,
    };
  }

  factory StudyContent.fromMapDatabase(Map<String, dynamic> map) {
    return StudyContent(
      topicTitle: map['topicTitle'],
      topicContent: map['topicContent'],
      topicIndex: map['topicIndex'],
      studyPlanId: map['studyPlanId'],
    );
  }
}
