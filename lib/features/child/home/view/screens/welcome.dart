import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controller/home_controller.dart';

class Welcome extends StatelessWidget {
  Welcome({super.key});
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beigeBackground,
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              if (!controller.isLoading.value)
                Container(
                  height: Get.height,
                  width: Get.width,
                  color: controller.child.gender == "male"
                      ? AppColors.primaryOrange
                      : AppColors.primaryGreen,
                ),
              if (!controller.isLoading.value)
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 7,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Welcome, ${controller.child.name}",
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Let's earn some coins",
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 120),
                      Expanded(
                        child: Align(
                          alignment: controller.child.gender == "male"
                              ? Alignment.bottomLeft
                              : Alignment.bottomRight,
                          child: Image.asset(
                            "assets/images/${controller.child.gender == "male" ? "boy" : "girl"}.png",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!controller.isLoading.value)
                InkWell(
                  onTap: () => Get.offAllNamed("/child_main"),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.all(30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.darkPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color: AppColors.beigeBackground,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
