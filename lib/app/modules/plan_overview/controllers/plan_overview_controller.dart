import 'package:ai_work_assistant/app/data/complet_study_plan.dart';
import 'package:ai_work_assistant/app/data/study_plan_data.dart';
import 'package:ai_work_assistant/app/routes/app_pages.dart';
import 'package:ai_work_assistant/services/alarm_service.dart';
import 'package:ai_work_assistant/services/database_service.dart';
import 'package:ai_work_assistant/utills/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class PlanOverviewController extends GetxController {
  //TODO: Implement PlanOverviewController

  final count = 0.obs;
  late Map<String, dynamic> mapStudyPlanData;
  late Map<String, dynamic> mapCompleteStudyPlan;
  late StudyPlanData studyPlanData;
  late CompleteStudyPlan completeStudyPlan;
  RxBool backButtonPressed = false.obs;
  DatabaseHelper database = DatabaseHelper();
  var studyPlanIdList = <int>[];
  @override
  void onInit() {
    super.onInit();
    mapStudyPlanData =
        Get.arguments['mapStudyPlanData'] as Map<String, dynamic>;
    mapCompleteStudyPlan =
        Get.arguments['mapCompleteStudyPlan'] as Map<String, dynamic>;
    studyPlanData = StudyPlanData.fromMap(mapStudyPlanData);
    completeStudyPlan = CompleteStudyPlan.fromMap(mapCompleteStudyPlan);
  }

  bool backButtonHandle(BuildContext context) {
    if (backButtonPressed.value) {
      CommonMethods.hideScaffoldMessenger(context);
      return true;
    } else {
      backButtonPressed.value = true;
      CommonMethods.showScaffoldMessenger("Press back again to exit");
      Future.delayed(
        Duration(seconds: 1),
        () => backButtonPressed.value = false,
      );
      return false;
    }
  }

  Future<void> saveAllStudyPlanToDatabase() async {
    studyPlanIdList = await database.insertAllStudyPlan(completeStudyPlan);

    print("Study plan saved to database");
    print("Study plan id length ${studyPlanIdList.length}");
    print(
      "complete study plan sessions length ${completeStudyPlan.studySessions.length}",
    );
  }

  Future<void> setStudyPlanNotifications() async {
    AlarmService alarmService = AlarmService();
    String studyPlanTitle = completeStudyPlan.studyPlanTitle;
    List<String> studyPlanTitleReminderList = [
      "$studyPlanTitle session is starting now.",
      "Back to learning! '$studyPlanTitle', A new session awaits.",
    ];
    List<String> studyPlanMessageReminderList = [
      "Session {sessionNumber}: Let's focus on $studyPlanTitle",
      "Reminder: Study Plan '$studyPlanTitle' — Session {sessionNumber}",
      "Stay consistent! Dive into Session {sessionNumber} of '$studyPlanTitle'.",
    ];
    if (completeStudyPlan.studySessions.length == studyPlanIdList.length) {
      for (int i = 0; i < completeStudyPlan.studySessions.length; i++) {
        await alarmService.scheduleNotification(
          studyPlanIdList[i],
          completeStudyPlan.studySessions[i],
          studyPlanTitleReminderList[i == 0 ? 0 : 1],
          studyPlanMessageReminderList[i == 0
                  ? 0
                  : i % 2 == 0
                  ? 1
                  : 2]
              .replaceAll("{sessionNumber}", "${i + 1}"),
        );
        print("Alarm set with ID: ${studyPlanIdList[i]}");
      }

      print("Study plan notifications set");
    } else {
      print("Study plan ID list and study sessions length mismatch");
    }

    // alarmService.scheduleNotification(id, scheduledTime)
  }

  Future<void> goToHome() async {
    await Get.offAllNamed(Routes.HOME);
  }

  Future<void> goToCompleteStudyPlan() async {
    developer.log("completeStudyPlan: ${completeStudyPlan.toMap()}");

    Get.offAllNamed(
      Routes.COMPLETE_STUDY_PLAN,
      arguments: {
        "completeStudyPlan": completeStudyPlan.toMap(),
        "redirectToHome": true,
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
