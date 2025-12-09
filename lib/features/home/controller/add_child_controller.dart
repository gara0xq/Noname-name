import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/dio_client.dart';
import '../../home/controller/home_controller.dart';

class AddChildController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final birthDateController = TextEditingController();

  final selectedGender = Rx<String?>(null);
  final isLoading = false.obs;

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2018, 1, 1),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppColors.darkPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      birthDateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> addChild({bool? navigateToMain}) async {
    if (formKey.currentState!.validate()) {
      if (selectedGender.value == null) {
        Get.snackbar(
          'Error',
          'Please select gender',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      isLoading.value = true;

      const String uri = '/user/parent/addChild';
      final dioClient = DioClient(hasToken: true);

      try {
        final response = await dioClient.post(
          uri: uri,
          data: {
            "name": nameController.text,
            "gender": selectedGender.value,
            "birthDate": birthDateController.text,
          },
        );

        isLoading.value = false;

        if (response.statusCode == 200 || response.statusCode == 201) {
          log('Child added successfully');
          
          Get.snackbar(
            'Success',
            'Child added successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.primaryGreen,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          if (Get.isRegistered<HomeController>()) {
            final homeController = Get.find<HomeController>();
            await homeController.onRefresh();
          }

          if (navigateToMain == true) {
            Get.offAllNamed("/main");
          } else {
            Get.back();
          }
          
          _clearForm();
        }
      } catch (e) {
        isLoading.value = false;
        log('Error adding child: $e');
        Get.snackbar(
          'Error',
          'Failed to add child. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  void _clearForm() {
    nameController.clear();
    birthDateController.clear();
    selectedGender.value = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    birthDateController.dispose();
    super.onClose();
  }
}