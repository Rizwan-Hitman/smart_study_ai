class StudyPlanData {
  List<String> topics;
  List<String> importantTopics;
  List<List<String>> studyPatches;

  StudyPlanData({
    required this.topics,
    required this.importantTopics,
    required this.studyPatches,
  });

  Map<String, dynamic> toMap() {
    return {
      "topics": topics,
      "importantTopics": importantTopics,
      "studyPatches": studyPatches,
    };
  }

  factory StudyPlanData.fromMap(Map<String, dynamic> map) {
    return StudyPlanData(
      topics: List<String>.from(map["topics"]),
      importantTopics: List<String>.from(map["importantTopics"]),
      studyPatches:
          (map["studyPatches"] as List)
              .map((session) => List<String>.from(session as List))
              .toList(),
    );
  }
}
