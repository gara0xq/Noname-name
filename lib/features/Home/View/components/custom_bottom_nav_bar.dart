import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/constants/app_colors.dart';
import '../../controller/home_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      final selectedIndex = controller.selectedTabIndex.value;
      final isHomeSelected = selectedIndex == 1;

      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavIcon(
                    icon: Icons.settings,
                    label: 'Settings',
                    isSelected: selectedIndex == 0,
                    onTap: () => controller.changeTab(0),
                  ),

                  const SizedBox(width: 70),

                  // Tasks
                  _buildNavIcon(
                    icon: Icons.checklist,
                    label: 'Tasks',
                    isSelected: selectedIndex == 2,
                    onTap: () => controller.changeTab(2),
                  ),
                ],
              ),

              // Middle icon
              Positioned(
                top: -30,
                child: GestureDetector(
                  onTap: () => controller.changeTab(1),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      isHomeSelected
                          ? 'lib/assets/images/childrenWhite.png'
                          : 'lib/assets/images/childrenDark.png',
                      fit: BoxFit.none,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.people_alt,
                          color: isHomeSelected
                              ? Colors.white
                              : AppColors.darkPrimary,
                          size: 32,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNavIcon({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? AppColors.darkPrimary
                  : AppColors.darkPrimary.withOpacity(0.4),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppColors.darkPrimary
                    : AppColors.darkPrimary.withOpacity(0.4),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
