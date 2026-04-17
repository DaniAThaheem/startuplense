import 'package:get/get.dart';
import 'package:startup_lense/routes/app_routes.dart';

class DashboardController extends GetxController {
  // 🔥 Reactive Idea List (dummy data for now)
  var ideas = [
    {
      "title": "AI Fitness App",
      "score": 82,
      "status": "Analyzed",
    },
    {
      "title": "Smart Study Planner",
      "score": 74,
      "status": "Analyzed",
    },
    {
      "title": "AI Travel Assistant",
      "score": null,
      "status": "Processing",
    },
  ].obs;


  void onAddIdea() async {
    final result = await Get.toNamed(AppRoutes.IDEA_SUBMISSION);

    if (result != null) {
      ideas.insert(0, result);
    }
    Get.snackbar(
      "Success",
      "Idea analyzed successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 👉 SEE ALL BUTTON
  void onViewAll() {
    Get.snackbar("Navigation", "Go to Idea History Screen");
  }

  // 👉 OPEN IDEA
  void openIdea(Map idea) {
    Get.snackbar("Open Idea", idea["title"]);
  }

  // 👉 LONG PRESS OPTIONS
  void onIdeaLongPress(Map idea) {
    // only logic trigger
  }


}
