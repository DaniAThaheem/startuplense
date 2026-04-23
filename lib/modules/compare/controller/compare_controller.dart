import 'package:get/get.dart';
import 'package:startup_lense/modules/idea_history/controller/Idea_history_controller.dart';

class CompareController extends GetxController {
  var ideaA = Rxn<IdeaModel>();
  var ideaB = Rxn<IdeaModel>();

  var isComparing = false.obs;

  // Dynamic AI results
  var scoreA = 0.0.obs;
  var scoreB = 0.0.obs;

  var riskA = "".obs;
  var riskB = "".obs;

  /// 🔥 SELECT IDEA A
  void selectIdeaA(IdeaModel idea) {
    ideaA.value = idea;
    _checkAndCompare();
  }

  /// 🔥 SELECT IDEA B
  void selectIdeaB(IdeaModel idea) {
    ideaB.value = idea;
    _checkAndCompare();
  }

  /// 🔥 AUTO CHECK
  void _checkAndCompare() {
    if (ideaA.value != null && ideaB.value != null) {
      _runComparison();
    }
  }

  /// 🔥 MAIN COMPARISON LOGIC
  void _runComparison() {
    // simulate AI delay
    Future.delayed(const Duration(milliseconds: 400), () {
      scoreA.value = ideaA.value!.score.toDouble();
      scoreB.value = ideaB.value!.score.toDouble();

      // simple risk logic (you can upgrade later)
      riskA.value = scoreA.value > 70 ? "Low" : "Medium";
      riskB.value = scoreB.value > 70 ? "Low" : "High";

      isComparing.value = true;
    });
  }

  /// 🔥 RESET EVERYTHING
  void reset() {
    ideaA.value = null;
    ideaB.value = null;
    isComparing.value = false;

    scoreA.value = 0;
    scoreB.value = 0;

    riskA.value = "";
    riskB.value = "";
  }
}