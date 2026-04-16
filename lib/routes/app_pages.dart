import 'package:get/get.dart';
import '../modules/auth/view/login_view.dart';
import '../modules/auth/view/signup_view.dart';
import '../modules/auth/binding/login_binding.dart';
import '../modules/auth/binding/signup_binding.dart';
import '../modules/main/view/main_view.dart';
import '../modules/main/binding/main_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: '/main',
      page: () => const MainView(),
      binding: MainBinding(),
    ),
  ];
}