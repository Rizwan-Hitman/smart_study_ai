import 'package:get/get.dart';

import '../controllers/plan_overview_controller.dart';

class PlanOverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanOverviewController>(
      () => PlanOverviewController(),
    );
  }
}
