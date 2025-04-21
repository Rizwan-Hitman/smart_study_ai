import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as developer;
import 'package:ai_work_assistant/app/data/complet_study_plan.dart';
import 'package:ai_work_assistant/app/data/study_plan_content.dart';
import 'package:ai_work_assistant/app/routes/app_pages.dart';
import 'package:ai_work_assistant/services/database_service.dart';
import 'package:ai_work_assistant/services/gemini_service.dart';
import 'package:ai_work_assistant/utills/colors.dart';
import 'package:ai_work_assistant/utills/common_methods.dart';
import 'package:ai_work_assistant/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CompleteStudyPlanController extends GetxController {
  //TODO: Implement CompleteStudyPlanController

  late CompleteStudyPlan completeStudyPlan;
  var allowBackButton = true.obs;
  DatabaseHelper database = DatabaseHelper();
  var isErrorOccured = false.obs;
  var errorMessage = "".obs;
  var isLoading = false.obs;
  late List<StudyContent> studyContentList;
  bool redirectToHome = false;

  @override
  void onInit() {
    super.onInit();
    completeStudyPlan = CompleteStudyPlan.fromMap(
      Get.arguments["completeStudyPlan"] as Map<String, dynamic>,
    );
    redirectToHome = Get.arguments["redirectToHome"] ?? false;
  }

  Future<bool> backButtonHandler() async {
    if (redirectToHome) {
      await Get.toNamed(Routes.HOME);
      return false;
    }
    return allowBackButton.value;
  }

  Future<String> generateContent(
    List<String> topicsCovered,
    int topicIndex,
    String studyPlanId,
  ) async {
    allowBackButton.value = false;
    final String studyPlanTitle = completeStudyPlan.studyPlanTitle;
    final Duration studyPlanDuration = completeStudyPlan.estimatedStudyDuration;
    final String attachedFilePath =
        completeStudyPlan.attachedFiles[0]; // fixed name

    print("📎 Attached file: $attachedFilePath");

    final String studyContentPrompt = """
       🧠 You are an intelligent assistant helping students review their study plans.

        ## Study Plan Overview

        - Title: $studyPlanTitle  
        - Topics Covered: ${topicsCovered.join(', ')}  
        - Duration: ${studyPlanDuration.inMinutes} minutes  
        - Attached File: (Use this as the primary content source. If insufficient, generate content from your knowledge.)

      - Content should be wrapped in normal markdown syntax. Keep sentences concise and properly formatted.
    - Headings (H1-H3) should follow standard markdown syntax (# H1, ## H2, ### H3). Use them to structure the content logically.
    - Bold (*text) and Italic (*text) should be used where necessary to emphasize key points.
    - Links ([text](URL)) should be clearly structured, using simple URLs.
    - Lists should be formatted correctly:
    - Ordered lists (1. Item) should contain at least three points.
    - Unordered lists (- Item) should use dashes (-) and maintain uniform indentation.
    - Code Blocks should be enclosed with triple backticks () and specify the programming language (e.g., dart for Dart code). Keep indentation clean and consistent.
    - Blockquotes (> Text) should be used for important notes or callouts.
    - Tables should be formatted using | Column 1 | Column 2 | syntax, with proper alignment.
    - Make sure the output is structured, readable, and follows best markdown practices. Format everything cleanly, keeping it simple yet visually appealing."
      """;

    GeminiService geminiService = GeminiService();

    try {
      // ✅ Correctly read the file bytes
      Uint8List fileBytes = await File(attachedFilePath).readAsBytes();

      // For testing purposes only
      // await Get.showOverlay(
      // asyncFunction: () async {
      // await Future.delayed(const Duration(seconds: 4));

      final response = await Get.showOverlay(
        asyncFunction: () async {
          return await geminiService.callGeminiApi(
            fileBytes,
            Schema.object(
              properties: {
                "response": Schema.array(
                  items: Schema.object(
                    properties: {
                      "topicTitle": Schema.string(
                        nullable: false,
                        description: "The title of the topic being discussed",
                      ),
                      "topicContent": Schema.string(
                        nullable: false,
                        description:
                            "The detailed content for this topic, starting with its heading",
                      ),
                    },
                    requiredProperties: ["topicTitle", "topicContent"],
                  ),
                  description:
                      "A list of topic objects with titles and their respective content",
                ),
              },
              requiredProperties: ["response"],
            ),
            studyContentPrompt,
          );
        },
        loadingWidget: loadingWidget("Generating content..."),
      );
      // Send to Gemini
      allowBackButton.value = true;
      return response!;
    } catch (e) {
      allowBackButton.value = true;
      print("❌ Error reading file or calling API: $e");
      return "Error";
    }
  }

  Center loadingWidget(String loadingMessage) {
    return Center(
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.threeArchedCircle(
              color: AppColors.textColor,
              size: SizeConfig.blockSizeHorizontal * 40,
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 80,
              padding: EdgeInsets.only(
                top: SizeConfig.blockSizeHorizontal * 20,
              ),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,

                  softWrap: true,
                  overflow: TextOverflow.clip,
                  loadingMessage,
                  style: TextStyle(
                    color: AppColors.textColor,

                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ).asGlass(frosted: false, blurX: 15, blurY: 10),
    );
  }

  void generateContentAndSaveToDatabase(
    List<String> topicsCovered,
    int topicIndex,
    String studyPlanId,
  ) async {
    final bool isConnected = await Get.showOverlay(
      asyncFunction: () async {
        return await InternetConnectionChecker.instance.hasConnection;
      },
      loadingWidget: loadingWidget("Checking internet connection..."),
    );

    if (isConnected) {
      final response = await generateContent(
        topicsCovered,
        topicIndex,
        studyPlanId,
      );
      if (response == "Error") {
        isErrorOccured.value = true;
        errorMessage.value =
            "An Error occured while generating content, Please try again.";
        Get.snackbar(
          "Server Error",
          errorMessage.value,
          duration: const Duration(seconds: 3),
        );
        developer.log("❌ Error generating content");
        return;
      } else {
        List<Map<String, dynamic>> responseMapList =
            List<Map<String, dynamic>>.from(jsonDecode(response)["response"]);

        List<StudyContent> studyContentListLocal = [];

        for (var i = 0; i < responseMapList.length; i++) {
          studyContentListLocal.add(
            StudyContent(
              topicTitle: responseMapList[i]["topicTitle"],
              topicContent: responseMapList[i]["topicContent"],
              topicIndex: topicIndex,
              studyPlanId: studyPlanId,
            ),
          );
        }
        developer.log("✅ Study Plan Content List: $studyContentListLocal");
        // Save to database
        for (int i = 0; i < studyContentListLocal.length; i++) {
          StudyContent studyContent = studyContentListLocal[i];
          await database.insertStudyContent(studyContent);
        }

        studyContentList = await database.fetchStudyContentList(
          studyPlanId,
          topicIndex,
        );

        await goToStudyContent(topicIndex);
      }
    } else {
      isErrorOccured.value = true;
      errorMessage.value =
          "Content is not generated, Please check your internet connection.";
      CommonMethods.showScaffoldMessenger("No Internet Connection");
    }
  }

  Future<bool> isStudyContentExist(studyPlanId, topicIndex) async {
    StudyContent? response = await Get.showOverlay(
      asyncFunction: () async {
        await Future.delayed(Duration(seconds: 1));
        return await database.fetchSingleStudyContent(studyPlanId, topicIndex);
      },
      loadingWidget: loadingWidget("Verifying content..."),
    );
    print("checking database for existing study plan content");
    print("Study Plan Content: $response");

    if (response == null) {
      print("Study Plan Content not found");
      return false;
    } else {
      studyContentList = await database.fetchStudyContentList(
        studyPlanId,
        topicIndex,
      );
      print("Study Plan Content found");
      await goToStudyContent(topicIndex);
      return true;
    }
  }

  Future<void> goToStudyContent(int topicIndex) async {
    Get.toNamed(
      Routes.STUDY_CONTENT,
      arguments: {
        "studyContent": jsonEncode(
          studyContentList.map((studyContent) => studyContent.toMap()).toList(),
        ),
        "sessionNumber": topicIndex,
      },
    );
  }
}
