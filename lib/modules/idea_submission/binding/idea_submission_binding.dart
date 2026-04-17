import 'package:get/get.dart';
import '../controller/idea_submission_controller.dart';

class IdeaSubmissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdeaSubmissionController>(
          () => IdeaSubmissionController(),
    );
  }
}