import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:ai_work_assistant/app/data/complet_study_plan.dart';
import 'package:ai_work_assistant/app/data/study_plan.dart';
import 'package:ai_work_assistant/app/data/study_plan_data.dart';
import 'package:ai_work_assistant/app/data/user_survey.dart';
import 'package:ai_work_assistant/app/routes/app_pages.dart';
import 'package:ai_work_assistant/services/database_service.dart';
import 'package:ai_work_assistant/services/gemini_service.dart';
import 'package:ai_work_assistant/utills/app_variables.dart';
import 'package:ai_work_assistant/utills/colors.dart';
import 'package:ai_work_assistant/utills/common_methods.dart';
import 'package:ai_work_assistant/utills/remoteconfig_variables.dart';
import 'package:ai_work_assistant/utills/size_config.dart';
import 'package:ai_work_assistant/utills/widgets.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:from_to_time_picker/generated/intl/messages_en.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyController extends GetxController {
  var currentStep = 0.obs;
  var studyCategory = ''.obs;
  // var customSubject = ''.obs;
  var targetDuration = 0.obs; // Default 0 days
  var dailyStudyDuration = 30.obs; // Default 0 mins
  var preferredDays = <String>[].obs;
  var attachedFiles = <String>[].obs;
  var dailyAvailabilityTime = TimeOfDay.now().obs;
  var selectedStartDate =
      DateTime.now().obs; // Selected end date (default: today)
  var selectedEndDate =
      DateTime.now().obs; // Selected end date (default: today)
  var fromTime = TimeOfDay(hour: 12, minute: 0).obs;
  var toTime = TimeOfDay(hour: 12, minute: 0).obs;
  var finalizingSurvey = false.obs;
  var loadingMessage = "Loading".obs;
  var attachedFilesName = <String>[].obs;
  var studyPlanTitle = "".obs;
  RxBool isGeneratingStudyTopics = false.obs;
  RxBool isShowStudyContent = false.obs;
  late BuildContext context;
  late List<String> preferredDates;
  late StudyPlanData studyPlanData;
  late CompleteStudyPlan completeStudyPlan;
  late Map<String, dynamic> mapStudyPlanData;
  late Map<String, dynamic> mapCompleteStudyPlan;
  late String studyPlanId;
  late UserSurvey userSurvey;
  var isNewUser = true.obs;
  var isFromHome = false.obs;
  DatabaseHelper database = DatabaseHelper();
  var backButtonPressed = false.obs;

  @override
  void onInit() {
    super.onInit();
    isNewUser.value = AppVariables.isNewUser;
    isFromHome.value =
        Get.arguments != null
            ? Get.arguments["isFromHome"] != null
                ? isFromHome.value = true
                : isFromHome.value = false
            : isFromHome.value = false;
    var now = DateTime.now();
    fromTime = TimeOfDay(hour: now.hour, minute: now.minute).obs;
    var toDateTime = now.add(Duration(minutes: 30));
    toTime = TimeOfDay(hour: toDateTime.hour, minute: toDateTime.minute).obs;
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool backButtonHandle(BuildContext context) {
    if (backButtonPressed.value || isFromHome.value && currentStep.value == 0) {
      if (isFromHome.value) {
        goToHomeView();
        return false;
      }
      CommonMethods.hideScaffoldMessenger(context);
      return true;
    } else {
      if (currentStep.value > 0) {
        prevStep();
        return false;
      }
      backButtonPressed.value = true;
      CommonMethods.showScaffoldMessenger("Press back again to exit");
      Future.delayed(
        Duration(seconds: 1),
        () => backButtonPressed.value = false,
      );
      return false;
    }
  }

  // Getter to calculate the total days between start and selected end date
  int get totalStudyDays =>
      CommonMethods.getPreferredDates(
        preferredDays,
        selectedStartDate.value,
        selectedEndDate.value,
      ).length;
  int get totalDays =>
      selectedEndDate.value.difference(selectedStartDate.value).inDays +
      (selectedEndDate.value.day == selectedStartDate.value.day ? 0 : 1);

  void generatePlan() async {
    isGeneratingStudyTopics.value = true;
    final bool isConnected =
        await InternetConnectionChecker.instance.hasConnection;
    if (isConnected) {
      print('Device is connected to the internet');

      studyPlanId = CommonMethods.generateRandomId();
      print("studyPlanID $studyPlanId");
      try {
        // Set generating state to true

        // Ensure preferredDates are generated correctly
        preferredDates = CommonMethods.getPreferredDates(
          preferredDays,
          selectedStartDate.value,
          selectedEndDate.value,
        );

        // Ensure the study plan data is generated correctly
        Map<String, dynamic> response = await generateStudyPlanData();
        if (response["response"] == "error") {
          CommonMethods.showScaffoldMessenger(
            "An Error occurred, Please try again.",
          );
          throw Exception('Error in generating study plan data');
        } else {
          List<List<String>> decoded =
              (response['studyPatches'] as List)
                  .map<List<String>>((e) => List<String>.from(e))
                  .toList();

          developer.log(
            "This is decoded studyPatches: $decoded and its type is ${decoded.runtimeType}",
          );

          decoded =
              decoded
                  .map((innerList) => List<String>.from(innerList).toList())
                  .toList();
          List<String> allTopics =
              List<List<String>>.from(decoded).expand((e) => e).toList();

          allTopics.addAll(List<String>.from(response['importantTopics']));
          allTopics.toSet().toList();

          response['topics'] = allTopics;

          studyPlanData = StudyPlanData.fromMap(response);
          studyPlanTitle.value = response['studyPlanTitle'];
          print("studyPlanTitle : ${studyPlanTitle.value}");

          // Check if studyPlanData or topics are invalid
          if (studyPlanData == null || studyPlanData.topics.isEmpty) {
            CommonMethods.showScaffoldMessenger(
              "An Error occurred, Please try again.",
            );
            throw Exception('Study plan data is empty or null');
          }

          // Add a condition to regenerate the response if studyPlanPatches length is not equal to study days
          // if (studyPlanData.studyPatches.length != preferredDates.length)
          // {
          // print(
          //   "Mismatch between studyPlanPatches (${studyPlanData.studyPatches.length}) and study days (${preferredDates.length}). Regenerating response...",
          // );
          // isGeneratingStudyTopics.value = true;
          // response = await generateStudyPlanData();
          // List<List<String>> decoded =
          //     (response['studyPatches'] as List)
          //         .map<List<String>>((e) => List<String>.from(e))
          //         .toList();

          // developer.log(
          //   "This is decoded studyPatches: $decoded and its type is ${decoded.runtimeType}",
          // );

          // decoded =
          //     decoded
          //         .map((innerList) => List<String>.from(innerList).toList())
          //         .toList();
          // List<String> allTopics =
          //     List<List<String>>.from(decoded).expand((e) => e).toList();

          // allTopics.addAll(List<String>.from(response['importantTopics']));
          // allTopics.toSet().toList();

          // response['topics'] = allTopics;

          // studyPlanData = StudyPlanData.fromMap(response);
          // studyPlanTitle.value = response['studyPlanTitle'];
          // print("Regenerated studyPlanTitle : ${studyPlanTitle.value}");

          // // Check again after regeneration
          // if (studyPlanData == null || studyPlanData.topics.isEmpty) {
          //   CommonMethods.showScaffoldMessenger(
          //     "An Error occurred, Please try again.",
          //   );
          //   throw Exception(
          //     'Study plan data is empty or null after regeneration',
          //   );
          // }
          // if (studyPlanData.studyPatches.length != preferredDates.length) {
          //   CommonMethods.showScaffoldMessenger(
          //     "An Error occurred, Please try again.",
          //   );

          //   throw Exception(
          //     'Study plan patches still do not match the number of study days after regeneration',
          //   );
          // } else {
          // Generate the study plan

          if (studyPlanData.studyPatches.length != preferredDates.length) {
            int studyPatchesLength = studyPlanData.studyPatches.length;
            int preferredDatesLength = preferredDates.length;
            while (studyPatchesLength < preferredDatesLength) {
              preferredDates.removeLast();
              preferredDatesLength = preferredDates.length;
              developer.log("removing last date: $preferredDatesLength");
            }
          } else if (studyPlanData.studyPatches.length <
              preferredDates.length) {}

          List<StudyPlan> studyPlan = getStudyPlan(studyPlanData);

          if (studyPlan.isEmpty) {
            throw Exception('Study plan is empty after generation');
          }

          // Ensure the study sessions are correctly parsed
          List<DateTime> studySessions =
              preferredDates
                  .map(
                    (date) => DateTime.parse(
                      "${date} ${fromTime.value.hour}:${fromTime.value.minute.toString().padLeft(2, "0")}:00",
                    ),
                  )
                  .toList();

          // Create the complete study plan object
          completeStudyPlan = CompleteStudyPlan(
            studyPlanTitle: studyPlanTitle.value,
            studyPlanId: studyPlanId,
            estimatedStudyDuration: Duration(minutes: dailyStudyDuration.value),
            studySessions: studySessions,
            topicNames: studyPlanData.topics,
            studyPlanPatches: studyPlan,
            attachedFiles: attachedFiles,
          );

          // Convert to map for API or storage
          mapCompleteStudyPlan = completeStudyPlan.toMap();
          mapStudyPlanData = studyPlanData.toMap();

          // Update state to show the generated study content
          isGeneratingStudyTopics.value = false;
          isShowStudyContent.value = true;
          print("showStudyContent : ${isShowStudyContent.value}");
          // }
          // } else {
          //   // Generate the study plan
          //   List<StudyPlan> studyPlan = getStudyPlan(studyPlanData);

          //   if (studyPlan.isEmpty) {
          //     throw Exception('Study plan is empty after generation');
          //   }

          //   // Ensure the study sessions are correctly parsed
          //   List<DateTime> studySessions =
          //       preferredDates
          //           .map(
          //             (date) => DateTime.parse(
          //               "${date} ${fromTime.value.hour}:${fromTime.value.minute.toString().padLeft(2, "0")}:00",
          //             ),
          //           )
          //           .toList();

          //   // Create the complete study plan object
          //   completeStudyPlan = CompleteStudyPlan(
          //     studyPlanTitle: studyPlanTitle.value,
          //     studyPlanId: studyPlanId,
          //     estimatedStudyDuration: Duration(
          //       minutes: dailyStudyDuration.value,
          //     ),
          //     studySessions: studySessions,
          //     topicNames: studyPlanData.topics,
          //     studyPlanPatches: studyPlan,
          //     attachedFiles: attachedFiles,
          //   );

          //   // Convert to map for API or storage
          //   mapCompleteStudyPlan = completeStudyPlan.toMap();
          //   mapStudyPlanData = studyPlanData.toMap();

          //   // Update state to show the generated study content
          //   isGeneratingStudyTopics.value = false;
          //   isShowStudyContent.value = true;
          //   print("showStudyContent : ${isShowStudyContent.value}");
          // }
        }
      } catch (e, stackTrace) {
        // Handle any errors and log them
        isGeneratingStudyTopics.value = false;
        isShowStudyContent.value = false;
        CommonMethods.showScaffoldMessenger(
          "An Error occurred, Please try again.",
        );

        // Log the error (you can customize this for your logging needs)
        print('Error generating study plan: $e');
        print('Stack trace: $stackTrace');

        // You can display an error message or alert to the user here
        print(
          "An error occurred while generating your study plan. Please try again.",
        );
      }
    } else {
      print('Device is not connected to the internet');
      Get.defaultDialog(
        // barrierDismissible: false,
        title: "",
        backgroundColor: Colors.transparent,
        content: noConnectionWidget(),
      );
      isGeneratingStudyTopics.value = false;
    }
  }

  List<StudyPlan> getStudyPlan(StudyPlanData studyPlanData) {
    List<StudyPlan> studyPlan = <StudyPlan>[];

    // Get the minimum length to avoid out-of-bounds access
    int iterationLength = studyPlanData.studyPatches.length;
    int preferredDatesLength = preferredDates.length;

    // Ensure the iteration length doesn't exceed the preferredDates length
    int safeIterationLength =
        (iterationLength < preferredDatesLength)
            ? iterationLength
            : preferredDatesLength;

    for (var i = 0; i < safeIterationLength; i++) {
      studyPlan.add(
        StudyPlan(
          sessionDateTime: DateTime.parse(
            "${preferredDates[i]} ${fromTime.value.hour}:${fromTime.value.minute.toString().padLeft(2, "0")}:00",
          ),
          sessionDuration: Duration(minutes: dailyStudyDuration.value),
          topicsCovered: studyPlanData.studyPatches[i],
          studyPlanId: studyPlanId,
        ),
      );
    }

    // If there are more study patches than dates, log a message or handle as needed
    if (iterationLength > preferredDatesLength) {
      developer.log(
        "Warning: More study patches than preferred dates. Some topics may not have assigned dates.",
      );
    }

    developer.log("This is the StudyPlan: ${studyPlan[0].toMap()}");
    return studyPlan;
  }

  Future<Map<String, dynamic>> generateStudyPlanData() async {
    try {
      print("attachedFile path : ${attachedFiles[0]}");
      Uint8List fileBytes = await File(attachedFiles[0]).readAsBytes();
      String prompt = """
You will be provided with a file containing study material. Your task is to carefully read and extract **only the topic names** from the table of contents, if available.

- **Do not include any lecture numbers**, subtopics, illustrations, or any additional content.
- Only return the names of the topics from the table of contents. If there are references to lectures (e.g., "Lecture No. 1", "Lecture No. 2", etc.), **exclude them from the response**.

After extracting the topics, you must categorize them into two groups: **important topics** and **non-important topics**.

### Key Instructions:
1. **Session Count Must Equal Study Days**:
   - You are provided with **${preferredDates!.length} total study days**.
   - You must create exactly **${preferredDates!.length} study sessions**, with **one session per day**.
   - The length of the `studyPatches` list must **strictly equal the number of study days**. Do not create more or fewer sessions than the number of days.

2. **Balance Topics Across Sessions**:
   - Distribute topics as evenly as possible across the ${preferredDates!.length} sessions.
   - Ensure each session fits within the daily limit of **${dailyStudyDuration!} minutes**.
   - Each session should be utilized fully without exceeding the allotted time.

3. **Adjust to Time Limits**:
   - It is **not necessary to complete all topics** if the total number cannot fit within the provided study days and available daily time.
   - Focus on **fitting as many topics as possible** into the time available, with priority given to important topics.

4. **Maximize Topic Coverage**:
   - Prioritize important topics when assigning to sessions.
   - Cover as many topics as possible without skipping unless absolutely necessary due to time constraints.
   - Try not to leave any unused time in sessions if additional topics can fit.

5. **Efficient Time Usage**:
   - If a topic doesn't fit in the current session, move it to the next.
   - Avoid overloading any session, especially the last one.

6. **Important Topics First**:
   - All important topics must be included in the session distribution if possible.
   - Important topics should be prioritized during the planning to ensure their inclusion.

### Output Schema:
Respond strictly using the following keys:
- `"studyPlanTitle"`: A meaningful title (Do **not** include the words "Study Plan").
- `"topics"`: A list of extracted topic names **only**.
- `"importantTopics"`: A prioritized list of important topics selected from the extracted topics.
- `"studyPatches"`: A list with **exactly ${preferredDates!.length} sublists**, each representing one study session for a day. The topics should be distributed evenly and efficiently across these sessions.

**Ensure**:
- The number of sessions in `studyPatches` equals **${preferredDates!.length}** — not more, not less.
- The distribution strictly respects the daily time limit and session count.
- Topics are adjusted to fit within the provided time frame. Completing all topics is **not mandatory**.
""";

      GeminiService geminiService = GeminiService(
        preferredDates: preferredDates,
        dailyStudyDuration: Duration(minutes: dailyStudyDuration.value),
      );
      String? response = await geminiService.callGeminiApi(
        fileBytes,
        GeminiService.studyPlanDataSchema,
        prompt,
        // geminiService.promptForStudyPlanData(),
      );

      developer.log("This is response ${response}");
      return jsonDecode(response!)['response'];
    } catch (e) {
      developer.log('Error occured :$e');
      return {"response": "error"};
    } finally {
      isGeneratingStudyTopics.value = false;
    }
  }

  void pickFile() async {
    await FilePicker.platform.clearTemporaryFiles();
    // await Permission.manageExternalStorage.request();

    if (true) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        String originalPath = result.files.single.path!;
        String fileName = p.basename(originalPath);

        // Get app directory
        Directory appDir = await getApplicationDocumentsDirectory();
        String newPath = p.join(appDir.path, fileName);

        // Copy the file
        File originalFile = File(originalPath);
        File copiedFile = await originalFile.copy(newPath);

        attachedFiles.insert(0, copiedFile.path); // Now this path is persistent
        attachedFilesName.value = result.names.map((e) => e ?? "").toList();

        print("✅ File copied and saved at: ${copiedFile.path}");
      } else {
        CommonMethods.showScaffoldMessenger(
          "Please select a content material to continue",
        );
      }
    } else {
      CommonMethods.showScaffoldMessenger(
        "Please provide storage permission to upload file",
      );
    }
  }

  void updateAvailability(TimeOfDay from, TimeOfDay to) {
    fromTime.value = from;
    toTime.value = to;
    dailyStudyDuration.value = CommonMethods.calculateDuration(from, to);
    dailyAvailabilityTime.value = from;
  }

  void updateFromTime(TimeOfDay from) {
    dailyStudyDuration.value = CommonMethods.calculateDuration(
      from,
      toTime.value,
    );
    fromTime.value = from;
    dailyAvailabilityTime.value = from;
  }

  void updateToTime(TimeOfDay to) {
    dailyStudyDuration.value = CommonMethods.calculateDuration(
      fromTime.value,
      to,
    );
    toTime.value = to;
  }

  void nextStep(BuildContext context) {
    print("show currentStep ${currentStep.value}");
    if (currentStep.value == 0) {
      if (studyCategory.value == "") {
        CommonMethods.showScaffoldMessenger(
          "Please select one fron the following categories.",
        );
      } else {
        currentStep.value++;
      }
    } else if (currentStep.value == 1) {
      if (preferredDays.isEmpty) {
        CommonMethods.showScaffoldMessenger(
          "Please provide preferred study days.",
        );
      } else {
        currentStep.value++;
      }
    } else if (currentStep.value == 2) {
      if (totalStudyDays == 0) {
        CommonMethods.showScaffoldMessenger("Study Days Cannot be zero.");
      } else {
        currentStep.value++;
      }
    } else if (currentStep.value == 3) {
      if (dailyStudyDuration.value > 30) {
        CommonMethods.showScaffoldMessenger(
          "Study duration can not be more then 30 mins.",
        );
      } else if (dailyStudyDuration.value == 0) {
        CommonMethods.showScaffoldMessenger(
          "Please provide study duration time.",
        );
      } else {
        currentStep.value++;
      }
    } else if (currentStep.value == 4) {
      if (attachedFiles.isEmpty) {
        CommonMethods.showScaffoldMessenger("Please attach a study material.");
      } else {
        finalizingSurvey.value = true;
      }
    }
  }

  void setUserSurvey() {
    userSurvey = UserSurvey(
      // studyCategory: studyCategory.value,
      targetDuration: Duration(days: targetDuration.value),
      dailyStudyDuration: Duration(minutes: dailyStudyDuration.value),
      preferredDays: preferredDays,
      preferredDates: preferredDates,
      dailyAvailabilityTime: dailyAvailabilityTime.value,
      attachedFiles: attachedFiles,
      studyPlanId: studyPlanId,
    );
  }

  // Function to update selected end date
  void updateEndDate(DateTime newDate) {
    selectedEndDate.value = newDate;
  }

  void prevStep() {
    print("show currentStep ${currentStep.value}");
    if (currentStep.value == 0) {
      goToHomeView();
    } else if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToHomeView() {
    Get.offNamed(Routes.HOME);
  }

  void setVariablesToDefault() async {
    finalizingSurvey.value = false;
    isShowStudyContent.value = false;
  }

  Future<void> goToStudyPlanOverview() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    bool? isNewUser = sharedPreferences.getBool('isNewUser');
    if (isNewUser != null) {
      AppVariables.isNewUser = false;
      sharedPreferences.setBool('isNewUser', false);
    }
    setUserSurvey();
    print("This is userSurvey: ${userSurvey.toMap()}");
    await database.insertUserSurvey(userSurvey);

    developer.log("This is studyPlanData: $mapStudyPlanData");
    developer.log("This is CompleteStudyPlan: $mapCompleteStudyPlan");
    // Get.toNamed(
    Get.offAllNamed(
      Routes.PLAN_OVERVIEW,
      arguments: {
        'mapStudyPlanData': mapStudyPlanData,
        'mapCompleteStudyPlan': mapCompleteStudyPlan,
      },
    );
  }
}
