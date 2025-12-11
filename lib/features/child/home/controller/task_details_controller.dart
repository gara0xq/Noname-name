import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/dio_client.dart';
import '../model/task_model.dart';
import '../../home/controller/home_controller.dart';

class ChildTaskDetailsController extends GetxController {
  final TaskModel task;
  
  ChildTaskDetailsController({required this.task});

  final isSubmitting = false.obs;

  Future<void> submitTask() async {
    isSubmitting.value = true;

    const String uri = '/user/child/submit';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.post(
        uri: uri,
        data: {
          "taskId": task.id,
          "proof_image_url": "https://your-domain.com/uploads/proof-image.jpg",
        },
      );

      isSubmitting.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Task submitted successfully');

        Get.snackbar(
          'Success',
          'Task submitted successfully! Waiting for parent approval.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Refresh the home controller tasks
        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          await homeController.fetchChildTasks();
        }

        // Navigate back to home and remove the details screen
        Get.back();
      } else {
        throw Exception('Failed to submit task');
      }
    } catch (e) {
      isSubmitting.value = false;
      log('❌ Error submitting task: $e');
      
      Get.snackbar(
        'Error',
        'Failed to submit task. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void showSubmitConfirmation() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.upload_file,
                color: AppColors.primaryGreen,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Submit Task',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to submit this task for parent approval?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close dialog first
                        submitTask();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.darkPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}