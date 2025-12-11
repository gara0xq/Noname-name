import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testss/features/child/home/view/screens/rewards_screen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controller/home_controller.dart';
import '../widget/custom_bottom_nav_bar.dart';
import 'tasks_screen.dart';

class ChildMainScreen extends StatelessWidget {
  ChildMainScreen({super.key});
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beigeBackground,
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      height: 115,
                      margin: EdgeInsets.all(20),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 100,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: controller.child.gender == "male"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: controller.child.gender == "male"
                                    ? AppColors.primaryOrange
                                    : AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    controller.child.gender == "male"
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Welcome,",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.beigeBackground,
                                    ),
                                  ),
                                  Text(
                                    controller.child.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.beigeBackground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: controller.child.gender == "male"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Image.asset(
                              "assets/images/${controller.child.gender == "male" ? "boy" : "girl"}.png",
                            ),
                          ),
                        ],
                      ),
                    ),
              Expanded(child: controller.pageIndex == 0 ? TasksScreen() : RewardsScreen()),
            ],
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
