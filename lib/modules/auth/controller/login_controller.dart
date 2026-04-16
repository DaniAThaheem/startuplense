import 'package:get/get.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final emailFocus = false.obs;
  final passwordFocus = false.obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void setEmailFocus(bool value) {
    emailFocus.value = value;
  }

  void setPasswordFocus(bool value) {
    passwordFocus.value = value;
  }

  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.offAllNamed('/main');
  }

  void loginWithGoogle() {
    Get.snackbar("Info", "Google login clicked");
  }
}