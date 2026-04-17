import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User Data (later connect Firebase)
  var name = "Alex Rivera".obs;
  var email = "alex@lense.ai".obs;

  // Analytics
  var totalIdeas = 12.obs;
  var bestScore = 92.obs;
  var avgScore = 74.obs;
  var lastActivity = "2h ago".obs;

  // AI Insight
  var insight =
      "Your idea quality is improving. Focus on differentiation for better results."
          .obs;

  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to log out?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Get.theme.colorScheme.onPrimary,
      onConfirm: () {
        Get.back();
        Get.offAllNamed('/login');
      },
    );
  }
}