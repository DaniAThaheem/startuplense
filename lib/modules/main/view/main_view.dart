import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:startup_lense/modules/compare/view/compare_view.dart';
import 'package:startup_lense/modules/idea_history/controller/Idea_history_controller.dart';
import 'package:startup_lense/modules/idea_history/view/idea_history_view.dart';
import 'package:startup_lense/modules/profile/controller/profile_controller.dart';
import 'package:startup_lense/modules/profile/view/profile_view.dart';
import '../controller/main_controller.dart';
import '../../dashboard/view/dashboard_view.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../compare/controller/compare_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    Get.put(IdeaHistoryController());
    Get.put(CompareController());
    Get.put(ProfileController());

    return Obx(() {

      return Scaffold(
        backgroundColor: const Color(0xFF0B0F19),

        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            DashboardView(),
            IdeaHistoryView(),
            CompareView(),
            ProfileView()
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          backgroundColor: const Color(0xFF0B0F19),
          selectedItemColor: const Color(0xFF06B6D4),
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "Ideas"),
            BottomNavigationBarItem(icon: Icon(Icons.compare), label: "Compare"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      );
    });
  }
}