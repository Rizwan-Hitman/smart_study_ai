import 'package:get/get.dart';

import '../controllers/complete_study_plan_controller.dart';

class CompleteStudyPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteStudyPlanController>(
      () => CompleteStudyPlanController(),
    );
  }
}
