import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class SignupController extends GetxController {

  final AuthRepository _authRepository = AuthRepository();

  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final university = ''.obs;

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmHidden = true.obs;

  final focusField = ''.obs;

  void setName(String v) => name.value = v;
  void setEmail(String v) => email.value = v;
  void setPassword(String v) => password.value = v;
  void setConfirmPassword(String v) => confirmPassword.value = v;
  void setUniversity(String v) => university.value = v;

  void togglePassword() => isPasswordHidden.toggle();
  void toggleConfirm() => isConfirmHidden.toggle();

  void setFocus(String field) => focusField.value = field;

  Future<void> signup() async {
    if (name.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty ||
        confirmPassword.value.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      await _authRepository.signup(
        name: name.value,
        email: email.value,
        password: password.value,
        university: university.value,
      );

      Get.offAllNamed('/main');

    } catch (e) {
      Get.snackbar("Signup Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void signupWithGoogle() {
    Get.snackbar("Info", "Google signup clicked");
  }
}