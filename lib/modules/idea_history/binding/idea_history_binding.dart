import 'package:get/get.dart';
import '../controller/idea_history_controller.dart';

class IdeaHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IdeaHistoryController());
  }
}