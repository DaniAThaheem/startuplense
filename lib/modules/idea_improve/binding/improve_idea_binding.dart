import 'package:get/get.dart';
import 'package:startup_lense/modules/idea_improve/controller/improve_idea_controller.dart';

class IdeaImproveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IdeaImproveController());
  }
}
