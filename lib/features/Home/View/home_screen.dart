import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_name/data/constants/app_colors.dart';
import '../controller/home_controller.dart';
import 'settings_screen.dart';
import 'tasks_screen.dart';
import 'home_content.dart';
import 'components/custom_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      final currentPage = _getCurrentPage(controller.selectedTabIndex.value);

      return Scaffold(
        backgroundColor: AppColors.beigeBackground,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: currentPage,
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      );
    });
  }

  Widget _getCurrentPage(int index) {
    switch (index) {
      case 0:
        return const SettingsScreen();
      case 1:
        return const HomeContent();
      case 2:
        return const TasksScreen();
      default:
        return const HomeContent();
    }
  }
}