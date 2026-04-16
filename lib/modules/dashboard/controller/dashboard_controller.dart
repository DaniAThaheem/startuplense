import 'package:get/get.dart';

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


  void onAddIdea() {
    Get.snackbar("Action", "Navigate to Idea Submission");
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
