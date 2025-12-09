import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/dio_client.dart';
import '../model/child_model.dart';
import '../model/task_model.dart';
import 'home_controller.dart';

class ChildDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ChildModel child;

  ChildDetailsController({required this.child});

  late TabController tabController;

  final tasksList = <TaskModel>[].obs;
  final isLoadingTasks = true.obs;
  final isDeleting = false.obs;

  final addTaskFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final pointsController = TextEditingController();
  final dateController = TextEditingController();
  final punishmentController = TextEditingController();
  final isAddingTask = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchChildTasks();
  }

  Future<void> fetchChildTasks() async {
    isLoadingTasks.value = true;

    const String uri = '/user/parent/getChildTasks';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.getWithBody(
        uri: uri,
        data: {"childcode": child.code},
      );

      if (response.statusCode == 200) {
        _processResponse(response.data);
      } else {
        _showErrorSnackbar('Failed to load tasks');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to load tasks');
    } finally {
      isLoadingTasks.value = false;
    }
  }

  void _processResponse(dynamic data) {
    if (data is Map && data.containsKey('task')) {
      final List<dynamic> tasksJson = data['task'];

      tasksList.clear();
      final List<TaskModel> tasks = tasksJson
          .map((taskMap) => TaskModel.fromJson(taskMap))
          .toList();
      tasksList.addAll(tasks);
    }
  }

  void copyChildCode() {
    Clipboard.setData(ClipboardData(text: child.code));
    Get.snackbar(
      'Success',
      'Child code copied: ${child.code}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryGreen,
      colorText: Colors.white,
    );
  }

  Future<void> selectTaskDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
      dateController.text = picked.toIso8601String();
    }
  }

  Future<void> addTask() async {
    if (addTaskFormKey.currentState!.validate()) {
      isAddingTask.value = true;

      const String uri = '/user/parent/add_task';
      final dioClient = DioClient(hasToken: true);

      try {
        final response = await dioClient.post(
          uri: uri,
          data: {
            "title": titleController.text,
            "description": descriptionController.text,
            "points": int.parse(pointsController.text),
            "code": child.code,
            "punishment": punishmentController.text,
            if (dateController.text.isNotEmpty)
              "expire_date": dateController.text,
          },
        );

        isAddingTask.value = false;

        if (response.statusCode == 200 || response.statusCode == 201) {
          titleController.clear();
          descriptionController.clear();
          pointsController.clear();
          dateController.clear();
          punishmentController.clear();

          Get.back();

          _showSuccessSnackbar('Task added successfully');

          await fetchChildTasks();
        }
      } catch (e) {
        isAddingTask.value = false;
        _showErrorSnackbar('Failed to add task. Please try again.');
      }
    }
  }

  Future<void> deleteChild() async {
    isDeleting.value = true;

    const String uri = '/user/parent/deleteChild';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.delete(
        uri: uri,
        data: {"code": child.code},
      );

      isDeleting.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessSnackbar('Child deleted successfully');

        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          await homeController.onRefresh();
        }

        Get.offAllNamed("/main");
      }
    } catch (e) {
      isDeleting.value = false;
      _showErrorSnackbar('Failed to delete child. Please try again.');
    }
  }

  void showDeleteConfirmationDialog() {
    Get.dialog(
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
                'Delete Child',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete ${child.name}? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: isDeleting.value ? null : deleteChild,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isDeleting.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryGreen,
      colorText: Colors.white,
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    titleController.dispose();
    descriptionController.clear();
    pointsController.dispose();
    dateController.dispose();
    punishmentController.dispose();
    super.onClose();
  }
}
