import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/setting_option_row.dart';
import '../widgets/family_invite_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isThemeDark = false;
  bool isLanguageEn = true;

  @override
  Widget build(BuildContext context) {
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
                  Get.dialog(FamilyInviteDialog());
                },
              ),
              const Divider(indent: 20, endIndent: 20, height: 1),

              SettingOptionRow(
                title: 'Theme',
                trailing: Switch(
                  value: isThemeDark,
                  onChanged: (bool value) {
                    setState(() {
                      isThemeDark = value;
                    });
                    print('Theme switch changed to: $value');
                  },
                  activeColor: AppColors.taskCardYellow,
                ),
              ),
              const Divider(indent: 20, endIndent: 20, height: 1),

              SettingOptionRow(
                title: 'Language',
                trailing: Switch(
                  value: isLanguageEn,
                  onChanged: (bool value) {
                    setState(() {
                      isLanguageEn = value;
                    });
                    print('Language switch changed to: $value');
                  },
                  activeColor: AppColors.taskCardYellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
