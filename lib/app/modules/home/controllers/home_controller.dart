import 'dart:math';

import 'package:ai_work_assistant/app/data/complet_study_plan.dart';
import 'package:ai_work_assistant/app/data/study_plan.dart';
import 'package:ai_work_assistant/app/routes/app_pages.dart';
import 'package:ai_work_assistant/services/alarm_service.dart';
import 'package:ai_work_assistant/services/database_service.dart';
import 'package:ai_work_assistant/utills/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var backButtonPressed = false.obs;
  var completeStudyPlanList = <CompleteStudyPlan>[].obs;
  var selectedItemsIndexes = <int>[].obs;
  var selectedItemsStudyPlanIds = <String>[].obs;

  DatabaseHelper database = DatabaseHelper();
  var isItemSelect = false.obs;
  AlarmService alarmServcie = AlarmService();
  Map<int, int> studyPlanColorIndexMap = {};

  @override
  void onInit() async {
    super.onInit();
    completeStudyPlanList.value = await database.fetchCompleteStudyPlans();
    update();
  }

  void goToStudyPlanListView(CompleteStudyPlan completeStudyPlan) {
    Get.toNamed(
      Routes.COMPLETE_STUDY_PLAN,
      arguments: {"completeStudyPlan": completeStudyPlan.toMap()},
    );
  }

  int getStudyPlanColorIndex(String studyPlanId) {
    // Use hashCode or unique ID to ensure consistency
    if (!studyPlanColorIndexMap.containsKey(studyPlanId.hashCode)) {
      studyPlanColorIndexMap[studyPlanId.hashCode] = Random().nextInt(
        3,
      ); // Assuming 3 color options
    }
    return studyPlanColorIndexMap[studyPlanId.hashCode]!;
  }

  bool itemSelectionHandler(int index, bool isLongPress, String id) {
    if (isLongPress && !isItemSelect.value) {
      selectedItemsIndexes.add(index);
      selectedItemsStudyPlanIds.add(id);
      isItemSelect.value = true;
      print("index: $index");
      print("isLongPress: $isLongPress");
      print("isItemSelect: ${isItemSelect.value}");
      print("selectedItemsIndexes: $selectedItemsIndexes");
      return true;
    } else if (!isLongPress && isItemSelect.value) {
      if (selectedItemsIndexes.length == 1 &&
          selectedItemsIndexes.contains(index)) {
        selectedItemsIndexes.remove(index);
        selectedItemsStudyPlanIds.remove(id);
        isItemSelect.value = false;
        print("index: $index");
        print("isLongPress: $isLongPress");
        print("isItemSelect: ${isItemSelect.value}");
        print("selectedItemsIndexes: $selectedItemsIndexes");
        return true;
      } else if (selectedItemsIndexes.contains(index)) {
        selectedItemsIndexes.remove(index);
        selectedItemsStudyPlanIds.remove(id);
        return true;
      } else {
        selectedItemsIndexes.add(index);
        selectedItemsStudyPlanIds.add(id);
        print("index: $index");
        print("isLongPress: $isLongPress");
        print("isItemSelect: ${isItemSelect.value}");
        print("selectedItemsIndexes: $selectedItemsIndexes");
        return true;
      }
    } else if (isLongPress && isItemSelect.value) {
      if (selectedItemsIndexes.length == 1 &&
          selectedItemsIndexes.contains(index)) {
        selectedItemsIndexes.remove(index);
        selectedItemsStudyPlanIds.remove(id);
        isItemSelect.value = false;
        print("index: $index");
        print("isLongPress: $isLongPress");
        print("isItemSelect: ${isItemSelect.value}");
        print("selectedItemsIndexes: $selectedItemsIndexes");
        return true;
      } else {
        print("index: $index");
        print("isLongPress: $isLongPress");
        print("isItemSelect: ${isItemSelect.value}");
        print("selectedItemsIndexes: $selectedItemsIndexes");
        return false;
      }
    } else {
      print("index: $index");
      print("isLongPress: $isLongPress");
      print("isItemSelect: ${isItemSelect.value}");
      print("selectedItemsIndexes: $selectedItemsIndexes");
      return false;
    }
  }

  Future<void> deleteSelectedItems() async {
    await database.deletePlans(selectedItemsStudyPlanIds);
    selectedItemsIndexes.clear();
    selectedItemsStudyPlanIds.clear();
    isItemSelect.value = false;
    completeStudyPlanList.value = await database.fetchCompleteStudyPlans();
    update();
    CommonMethods.showScaffoldMessenger("Deleted Successfully");
  }

  void goToSurveyView() {
    Get.toNamed(Routes.SURVEY, arguments: {"isFromHome": true});
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
}
