import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/setting_option_row.dart';
import '../widgets/family_invite_dialog.dart';
import '../widgets/change_password_dialog.dart';
import '../../controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

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
                  Get.dialog(const ChangePasswordDialog());
                },
              ),
              const Divider(indent: 20, endIndent: 20, height: 1),

              SettingOptionRow(
                title: 'Invite to family',
                onTap: () {
                  Get.dialog(FamilyInviteDialog());
                },
              ),
              const Divider(indent: 20, endIndent: 20, height: 1),

              Obx(
                () => SettingOptionRow(
                  title: 'Theme',
                  trailing: Switch(
                    value: controller.isThemeDark.value,
                    onChanged: controller.toggleTheme,
                    activeColor: AppColors.taskCardYellow,
                  ),
                ),
              ),
              const Divider(indent: 20, endIndent: 20, height: 1),

              Obx(
                () => SettingOptionRow(
                  title: 'Language',
                  trailing: Switch(
                    value: controller.isLanguageEn.value,
                    onChanged: controller.toggleLanguage,
                    activeColor: AppColors.taskCardYellow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
