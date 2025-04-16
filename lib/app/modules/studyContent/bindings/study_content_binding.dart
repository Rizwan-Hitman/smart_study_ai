import 'package:get/get.dart';

import '../controllers/study_content_controller.dart';

class StudyContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudyContentController>(
      () => StudyContentController(),
    );
  }
}
