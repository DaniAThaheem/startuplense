import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {

  final AuthRepository _authRepository = AuthRepository();

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

    try {
      isLoading.value = true;

      await _authRepository.login(
        email: email.value,
        password: password.value,
      );

      Get.offAllNamed('/main');

    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loginWithGoogle() {
    Get.snackbar("Info", "Google login clicked");
  }
}