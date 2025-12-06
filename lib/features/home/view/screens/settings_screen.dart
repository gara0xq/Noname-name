import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/setting_option_row.dart';
import '../../controller/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> { 
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    
    if (Get.isRegistered<SettingsController>() == false) {
      Get.put<SettingsController>(SettingsController());
    }

    return Scaffold(
      backgroundColor: AppColors.beigeBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 0),
                child: Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPrimary,
                    ),
                  ),
                ),
              ),
              const UserProfileCard(),

              const SizedBox(height: 10),

              SettingOptionRow(
                title: 'Change password',
                onTap: () {
                  print('Change password clicked');
                },
              ),
              const Divider(indent: 20, endIndent: 20, height: 1),

              SettingOptionRow(
                title: 'Invite to family',
                onTap: () {
                  controller.showFamilyInviteDialog();
                },
              ),
              const Divider(indent: 20, endIndent: 20, height: 1),

              Obx(() => SettingOptionRow(
                    title: 'Theme',
                    trailing: Switch(
                      value: controller.isThemeDark.value, 
                      onChanged: (bool value) {
                        controller.toggleTheme(value); 
                      },
                      activeColor: AppColors.taskCardYellow,
                    ),
                  )),
              const Divider(indent: 20, endIndent: 20, height: 1),

              Obx(() => SettingOptionRow(
                    title: 'Language',
                    trailing: Switch(
                      value: controller.isLanguageEn.value,
                      onChanged: (bool value) {
                        controller.toggleLanguage(value); 
                      },
                      activeColor: AppColors.taskCardYellow,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}