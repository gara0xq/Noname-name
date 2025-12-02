import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/constants/app_colors.dart';
import '../../controller/home_controller.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: AppColors.darkPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    controller.userName.value.split(' ').first,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.taskCardYellow,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.darkPrimary,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}