import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controller/home_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 55,
        margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.darkPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child: controller.pageIndex.value == 0
                  ? Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.beigeBackground,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/tasks.svg",
                            color: AppColors.darkPrimary,
                          ),
                          Text(
                            "Tasks",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () => controller.changePage(0),
                      child: SvgPicture.asset(
                        "assets/icons/tasks.svg",
                        color: AppColors.beigeBackground,
                      ),
                    ),
            ),
            Expanded(
              child: controller.pageIndex.value == 1
                  ? Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.beigeBackground,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/rewards.svg",
                            color: AppColors.darkPrimary,
                          ),
                          Text(
                            "Rewards",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () => controller.changePage(1),
                      child: SvgPicture.asset(
                        "assets/icons/rewards.svg",
                        color: AppColors.beigeBackground,
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
