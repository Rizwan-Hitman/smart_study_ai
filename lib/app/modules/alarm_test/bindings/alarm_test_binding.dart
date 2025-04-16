import 'package:get/get.dart';

import '../controllers/alarm_test_controller.dart';

class AlarmTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmTestController>(
      () => AlarmTestController(),
    );
  }
}
