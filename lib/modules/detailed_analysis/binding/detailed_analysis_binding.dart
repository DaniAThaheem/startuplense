import 'package:get/get.dart';
import '../controller/detailed_analysis_controller.dart';

class DetailedAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailedAnalysisController());
  }
}
