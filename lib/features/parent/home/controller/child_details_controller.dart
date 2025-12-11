import 'dart:developer';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/rewards_service.dart';
import '../../../../core/services/tasks_service.dart';
import '../model/child_model.dart';
import '../model/reward_model.dart';
import '../model/task_model.dart';
import 'home_controller.dart';

class ChildDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ChildModel child;
  final TasksService _tasksService = TasksService();

  ChildDetailsController({required this.child});

  late TabController tabController;

  final RewardsService _rewardsService = RewardsService();
  List<RewardModel> rewardsList = <RewardModel>[].obs;
  final isLoadingRewards = true.obs;

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

  // Add Reward Form
  final addRewardFormKey = GlobalKey<FormState>();
  final rewardTitleController = TextEditingController();
  final rewardPointsController = TextEditingController();
  Rx<XFile?> selectedRewardImage = Rx<XFile?>(null);
  final isUploadingReward = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchChildTasks();
    fetchChildRewards();
  }

  Future<void> fetchChildTasks() async {
    isLoadingTasks.value = true;

    try {
      final tasks = await _tasksService.getChildTasks(child.code);

      tasksList.clear();
      tasksList.addAll(tasks);

      print(' Child tasks loaded: ${tasks.length} tasks for ${child.name}');
    } catch (e) {
      _showErrorSnackbar('Failed to load tasks');
      print(' Error fetching child tasks: $e');
    } finally {
      isLoadingTasks.value = false;
    }
  }

  Future<void> fetchChildRewards() async {
    isLoadingRewards.value = true;

    try {
      log('📋 Fetching rewards for child: ${child.code}');

      final data = await _rewardsService.getChildRewards(child.code);

      rewardsList.clear();
      rewardsList = data.map((e) => RewardModel.fromMap(e)).toList();

      log('✅ Rewards loaded: ${rewardsList.length} rewards for ${child.name}');
    } catch (e) {
      _showErrorSnackbar('Failed to load rewards');
      log('❌ Error fetching rewards: $e');
    } finally {
      isLoadingRewards.value = false;
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

      try {
        final success = await _tasksService.addTask(
          title: titleController.text,
          description: descriptionController.text,
          points: int.parse(pointsController.text),
          childCode: child.code,
          punishment: punishmentController.text,
          expireDate: dateController.text.isNotEmpty
              ? dateController.text
              : null,
        );

        isAddingTask.value = false;

        if (success) {
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
        print(' Error adding task: $e');
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

  Future pickRewardImage() async {
    PermissionStatus photosStatus = await Permission.photos.request();
    final ImagePicker _picker = ImagePicker();

    if (photosStatus.isGranted) {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedRewardImage.value = image;
        image.readAsBytes();
      }
    }
  }

  Future<String> uploadImage(String? filePath, List<int> fileBytes) async {
    isUploadingReward.value = true;
    final Cloudinary cloudinary = Cloudinary.signedConfig(
      apiKey: "381892251377675",
      apiSecret: "vtLf6BfJ4irTC2VT9hAc2N3KVqE",
      cloudName: "do3ob6bif",
    );

    try {
      final response = await cloudinary.upload(
        file: filePath,
        fileBytes: fileBytes,
        resourceType: CloudinaryResourceType.image,
        fileName: filePath!.split("/").last ?? "image",
        folder: "internship2025",
      );
      return response.secureUrl!;
    } catch (e) {
      log(e.toString());
    } finally {
      isUploadingReward.value = false;
    }
    return "";
  }

  Future addReward() async {
    final fileBytes = await selectedRewardImage.value!.readAsBytes();
    final imageUrl = await uploadImage(
      selectedRewardImage.value!.path,
      fileBytes as List<int>,
    );

    const String uri = '/user/parent/addReward';
    final dioClient = DioClient(hasToken: true);
    isAddingTask.value = true;

    try {
      final response = await dioClient.post(
        uri: uri,
        data: RewardModel(
          title: rewardTitleController.text,
          imageUrl: imageUrl,
          points: int.tryParse(rewardPointsController.text)!,
        ).toMap(child.code),
      );

      isAddingTask.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessSnackbar('Added reward successfully');

        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          await homeController.onRefresh();
        }
        Get.offAllNamed("/main");
      } else {
        _showErrorSnackbar(response.data["message"]);
      }
    } catch (e) {
      isDeleting.value = false;
      _showErrorSnackbar('Failed to add reward. Please try again.');
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    pointsController.dispose();
    dateController.dispose();
    punishmentController.dispose();
    super.onClose();
  }
}
