import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/tasks_service.dart';
import '../model/task_model.dart';
import 'tasks_controller.dart';
import 'child_details_controller.dart';

class TaskDetailsController extends GetxController {
  final String taskId;
  final TasksService _tasksService = TasksService();

  TaskDetailsController({required this.taskId});

  final Rx<TaskModel?> task = Rx<TaskModel?>(null);
  final isLoading = false.obs;
  final isApproving = false.obs;
  final isRejecting = false.obs;
  final isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTaskDetails();
  }

  Future<void> fetchTaskDetails() async {
    isLoading.value = true;

    try {
      final fetchedTask = await _tasksService.getTaskById(taskId);
      task.value = fetchedTask;

      if (fetchedTask == null) {
        print('❌ Task not found for id: $taskId');
        Get.snackbar(
          'Error',
          'Task not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print('✅ Task loaded successfully:');
        print('  ID: ${fetchedTask.id}');
        print('  Title: ${fetchedTask.title}');
        print('  Description: ${fetchedTask.description}');
        print('  Status: ${fetchedTask.status}');
        print('  Display Status: ${fetchedTask.displayStatus}');
        print('  Points: ${fetchedTask.points}');
        print('  Expire Date: ${fetchedTask.expireDate}');
        print('  Punishment: ${fetchedTask.punishment}');
        print('  Submitted At: ${fetchedTask.submittedAt}');
        print('  Child Name: ${fetchedTask.childName}');
        print('  Is Expired: ${fetchedTask.isExpired}');
        print('  Proof Image: ${fetchedTask.proofImageUrl}');
      }
    } catch (e) {
      print(' Error fetching task details: $e');
      Get.snackbar(
        'Error',
        'Failed to load task details: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveTask() async {
    if (isApproving.value) return;

    final confirmed = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryGreen,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Approve Task',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to approve this task? Points will be awarded to the child.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
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
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.darkPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Approve',
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

    if (confirmed != true) return;

    isApproving.value = true;

    try {
      final success = await _tasksService.approveTask(taskId);

      if (success) {
        Get.snackbar(
          'Success',
          'Task approved successfully! Points awarded.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        await _refreshAllControllers();

        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.back();
        });
      } else {
        throw Exception('Failed to approve task - API returned false');
      }
    } catch (e) {
      print(' Error approving task: $e');
      Get.snackbar(
        'Error',
        'Failed to approve task. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isApproving.value = false;
    }
  }

  Future<void> rejectTask() async {
    if (isRejecting.value) return;

    final confirmed = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Reject Task',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to reject this task? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
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
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Reject',
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

    if (confirmed != true) return;

    isRejecting.value = true;

    try {
      final success = await _tasksService.rejectTask(taskId);

      if (success) {
        Get.snackbar(
          'Success',
          'Task rejected successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        await _refreshAllControllers();

        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.back();
        });
      } else {
        throw Exception('Failed to reject task - API returned false');
      }
    } catch (e) {
      print(' Error rejecting task: $e');
      Get.snackbar(
        'Error',
        'Failed to reject task. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isRejecting.value = false;
    }
  }

  Future<void> deleteTask() async {
    if (isDeleting.value) return;

    final confirmed = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Task',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to delete this task? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
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
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
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

    if (confirmed != true) return;

    isDeleting.value = true;

    try {
      final success = await _tasksService.deleteTask(taskId);

      if (success) {
        Get.snackbar(
          'Success',
          'Task deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        await _refreshAllControllers();

        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.back();
        });
      } else {
        throw Exception('Failed to delete task - API returned false');
      }
    } catch (e) {
      print(' Error deleting task: $e');
      Get.snackbar(
        'Error',
        'Failed to delete task. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> _refreshAllControllers() async {
    print('🔄 Refreshing all controllers...');
    
    await fetchTaskDetails();
    print(' Refreshed current task details');

    if (Get.isRegistered<TasksController>()) {
      final tasksController = Get.find<TasksController>();
      await tasksController.refreshTasks();
      print(' Refreshed TasksController');
    }

    if (Get.isRegistered<ChildDetailsController>()) {
      final childDetailsController = Get.find<ChildDetailsController>();
      await childDetailsController.fetchChildTasks();
      print(' Refreshed ChildDetailsController');
    }
  }
}