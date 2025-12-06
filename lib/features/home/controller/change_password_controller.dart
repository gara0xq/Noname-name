import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class ChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> changePassword() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      const String uri = '/user/parent/updateUserPass';
      final dioClient = DioClient(hasToken: true);

      try {
        final response = await dioClient.put(
          uri: uri,
          data: {
            "password": newPasswordController.text,
          },
        );

        isLoading.value = false;

        if (response.statusCode == 200 || response.statusCode == 201) {
          log('Password changed successfully');
          Get.back();
          Get.snackbar(
            'Success',
            'Password changed successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.primaryGreen,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          log('Failed to change password: ${response.statusMessage}');
          _showErrorSnackbar('Failed to change password');
        }
      } on DioException catch (e) {
        isLoading.value = false;
        log('Dio Error changing password: ${e.response?.data}');

        String errorMessage = 'An error occurred. Please try again.';

        if (e.response?.data != null) {
          errorMessage = e.response?.data['message'] ??
              e.response?.data['error'] ??
              'Failed to change password';
          
          // Check if password is the same
          if (errorMessage.toLowerCase().contains('same')) {
            errorMessage = 'New password cannot be the same as the old password';
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Connection timeout. Please try again.';
        } else if (e.type == DioExceptionType.unknown) {
          errorMessage = 'Network error. Please check your connection.';
        }

        _showErrorSnackbar(errorMessage);
      } catch (e) {
        isLoading.value = false;
        log('Error changing password: $e');
        
        String errorMessage = 'An unexpected error occurred';
        if (e.toString().toLowerCase().contains('same')) {
          errorMessage = 'New password cannot be the same as the old password';
        }
        
        _showErrorSnackbar(errorMessage);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}