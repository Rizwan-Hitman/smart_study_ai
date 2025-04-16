import 'dart:convert';
import 'dart:math';

import 'package:ai_work_assistant/app/data/study_plan_content.dart';
import 'package:ai_work_assistant/services/database_service.dart';
import 'package:get/get.dart';

class StudyContentController extends GetxController {
  //TODO: Implement StudyContentController

  DatabaseHelper databse = DatabaseHelper();
  RxList<StudyContent> studyContentList = <StudyContent>[].obs;
  late int sessionNumber;
  @override
  void onInit() {
    super.onInit();
    List<Map<String, dynamic>> studyContentMapList =
        List<Map<String, dynamic>>.from(
          jsonDecode(Get.arguments["studyContent"]),
        ).toList();

    sessionNumber = Get.arguments["sessionNumber"];

    studyContentList.value =
        studyContentMapList.map((e) => StudyContent.fromMap(e)).toList();
  }
}
