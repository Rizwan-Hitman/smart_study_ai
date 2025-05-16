import 'package:ai_work_assistant/utills/app_variables.dart';
import 'package:get/get.dart';

import '../modules/alarm_test/bindings/alarm_test_binding.dart';
import '../modules/alarm_test/views/alarm_test_view.dart';
import '../modules/complete_study_plan/bindings/complete_study_plan_binding.dart';
import '../modules/complete_study_plan/views/complete_study_plan_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/plan_overview/bindings/plan_overview_binding.dart';
import '../modules/plan_overview/views/plan_overview_view.dart';
import '../modules/studyContent/bindings/study_content_binding.dart';
import '../modules/studyContent/views/study_content_view.dart';
import '../modules/survey/bindings/survey_binding.dart';
import '../modules/survey/views/survey_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static final INITIAL = Routes.ALARM_TEST;
  static final INITIAL = AppVariables.isNewUser ? Routes.SURVEY : Routes.HOME;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.SURVEY,
      page: () => SurveyScreen(),
      binding: SurveyBinding(),
    ),
    GetPage(
      name: _Paths.PLAN_OVERVIEW,
      page: () => const PlanOverviewView(),
      binding: PlanOverviewBinding(),
    ),
    GetPage(
      name: _Paths.ALARM_TEST,
      page: () => const AlarmTestView(),
      binding: AlarmTestBinding(),
    ),
    GetPage(
      name: _Paths.COMPLETE_STUDY_PLAN,
      page: () => const CompleteStudyPlanView(),
      binding: CompleteStudyPlanBinding(),
    ),
    GetPage(
      name: _Paths.STUDY_CONTENT,
      page: () => const StudyContentView(),
      binding: StudyContentBinding(),
    ),
  ];
}
