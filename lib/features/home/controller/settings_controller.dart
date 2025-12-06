import 'package:get/get.dart';
import 'package:testss/features/home/view/widgets/family_invite_dialog.dart';

class SettingsController extends GetxController {
  var isThemeDark = false.obs;
  var isLanguageEn = true.obs;

  void toggleTheme(bool value) {
    isThemeDark.value = value;
    print('Theme switch changed to: $value');
  }

  void toggleLanguage(bool value) {
    isLanguageEn.value = value;
    print('Language switch changed to: $value');
  }
  
  void showFamilyInviteDialog() {
    Get.dialog(FamilyInviteDialog()); 
  }
}