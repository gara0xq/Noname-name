import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:testss/features/parent/home/view/widgets/family_invite_dialog.dart';
import '../../../../core/services/dio_client.dart';

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

  Future<bool> changePassword({required String newPassword}) async {
    const String uri = '/user/parent/updateUserPass';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.put(
        uri: uri,
        data: {"password": newPassword},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Password changed successfully');
        return true;
      } else {
        log('Failed to change password: ${response.statusMessage}');
        throw Exception('Failed to change password');
      }
    } on DioException catch (e) {
      log('Dio Error changing password: ${e.response?.data}');

      // إذا كان الباك اند بيرجع رسالة خطأ محددة
      if (e.response?.data != null) {
        final errorMessage =
            e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to change password';
        throw Exception(errorMessage);
      }

      throw Exception('Network error. Please try again.');
    } catch (e) {
      log('Error changing password: $e');
      throw Exception('An unexpected error occurred');
    }
  }
}
