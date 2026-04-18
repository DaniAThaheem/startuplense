import 'package:get/get.dart';
import 'package:startup_lense/modules/idea_history/binding/idea_history_binding.dart';
import 'package:startup_lense/modules/idea_history/view/idea_history_view.dart';
import 'package:startup_lense/modules/idea_processing/binding/processing_binding.dart';
import 'package:startup_lense/modules/idea_processing/view/processing_view.dart';
import '../modules/dashboard/binding/dashboard_binding.dart';
import '../modules/dashboard/view/dashboard_view.dart';
import '../modules/idea_submission/binding/idea_submission_binding.dart';
import '../modules/idea_submission/view/idea_submission_view.dart';
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
      name: AppRoutes.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.IDEA_SUBMISSION,
      page: () => const IdeaSubmissionView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      binding: IdeaSubmissionBinding(),
    ),
    GetPage(
      name: AppRoutes.PROCESSING,
      page: () => const ProcessingView(),
      binding: ProcessingBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.IDEA_HISTORY,
      page: () => const IdeaHistoryView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      binding: IdeaHistoryBinding(),
    ),

    GetPage(
      name: AppRoutes.IDEA_RESULT,
      page: () => const ProcessingView(),
    ),

  ];
}