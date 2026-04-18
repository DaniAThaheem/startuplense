import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IdeaImproveController extends GetxController {

  // 🔹 TEXT CONTROLLERS
  final titleController = TextEditingController();
  final problemController = TextEditingController();
  final marketController = TextEditingController();
  final strategyController = TextEditingController();

  // 🔹 LOADING
  var isLoading = false.obs;

  // 🔹 BUTTON SCALE
  var scale = 1.0.obs;

  // 🔹 SCORE
  var score = 72.obs;

  // ================= SUGGESTIONS =================

  // 🔸 TITLE
  var titleSuggestion = "AI-powered fitness tracker for students".obs;
  var titleReason =
      "A clearer and more specific title improves investor understanding."
          .obs;

  // 🔸 PROBLEM
  var problemSuggestion =
      "Students struggle to maintain consistent fitness routines due to lack of motivation and guidance."
          .obs;

  var problemReason =
      "Clearly defined problems improve AI analysis accuracy and solution mapping."
          .obs;

  // 🔸 MARKET
  var marketSuggestion =
      "University students aged 18–25 in urban areas".obs;

  var marketReason =
      "Narrowing the target audience improves market validation and scalability insights."
          .obs;

  // 🔸 STRATEGY
  var strategySuggestion =
      "Subscription-based model with freemium onboarding".obs;

  var strategyReason =
      "A defined monetization strategy increases business feasibility score."
          .obs;

  // ================= APPLY METHODS =================

  void applyTitleSuggestion() {
    titleController.text = titleSuggestion.value;
  }

  void applyProblemSuggestion() {
    problemController.text = problemSuggestion.value;
  }

  void applyMarketSuggestion() {
    marketController.text = marketSuggestion.value;
  }

  void applyStrategySuggestion() {
    strategyController.text = strategySuggestion.value;
  }

  // ================= SAVE =================

  void saveImprovedIdea() {
    Get.snackbar("Success", "Idea improved successfully");
    Get.back(result: {
      "title": titleController.text,
      "score": score.value + 8, // simulate improvement
      "status": "Analyzed",
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    problemController.dispose();
    marketController.dispose();
    strategyController.dispose();
    super.onClose();
  }
}
