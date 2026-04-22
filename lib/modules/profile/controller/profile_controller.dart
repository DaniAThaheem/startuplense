import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
class ProfileController extends GetxController {

  final AuthRepository _authRepository = AuthRepository();
  var isLoading = false.obs;


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

  Future<void> logout() async {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to log out?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Get.theme.colorScheme.onPrimary,
      onConfirm: () async {
        Get.back(); // close dialog

        try {
          isLoading.value = true;

          await _authRepository.logout();

          Get.offAllNamed('/login');
        } catch (e) {
          Get.snackbar("Error", e.toString());
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

}