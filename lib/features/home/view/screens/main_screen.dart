import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controller/home_controller.dart';
import 'settings_screen.dart';
import 'tasks_screen.dart';
import 'home_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Obx(() {
      final currentPage = _getCurrentPage(controller.selectedTabIndex.value);

      return Scaffold(
        backgroundColor: AppColors.beigeBackground,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
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
        return const HomeScreen();
      case 2:
        return const TasksScreen();
      default:
        return const HomeScreen();
    }
  }
}