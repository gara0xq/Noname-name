// lib/features/parent/home/controller/tasks_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import '../../../../core/services/tasks_service.dart';
import '../model/task_model.dart';

class TasksController extends GetxController {
  final TasksService _tasksService = TasksService();

  final allTasks = <TaskModel>[].obs;
  final filteredTasks = <TaskModel>[].obs;

  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final currentFilter = Rx<String?>(null);

  final pendingCount = 0.obs;
  final submittedCount = 0.obs;
  final completedCount = 0.obs;
  final expiredDeclinedCount = 0.obs;
  final totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllTasks();
  }

  Future<void> fetchAllTasks() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final tasks = await _tasksService.getAllTasks();

      allTasks.clear();
      allTasks.addAll(tasks);

      _calculateStats();
      _resetToAllTasks();

      print(' All tasks loaded: ${tasks.length} tasks');
      print(
        ' Stats - Total: $totalCount, Pending: $pendingCount, Submitted: $submittedCount, Completed: $completedCount, Expired/Declined: $expiredDeclinedCount',
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load tasks: $e';
      print(' Error fetching tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateStats() {
    pendingCount.value = allTasks
        .where((task) => task.status == 'pending' && !task.isExpired)
        .length;

    submittedCount.value = allTasks
        .where((task) => task.status == 'submitted')
        .length;

    completedCount.value = allTasks
        .where((task) => task.status == 'completed')
        .length;

    expiredDeclinedCount.value = allTasks
        .where((task) => task.status == 'Declined' || task.isExpired)
        .length;

    totalCount.value = allTasks.length;
  }

  void _resetToAllTasks() {
    filteredTasks.value = List<TaskModel>.from(allTasks);
    currentFilter.value = null;
    update();
    print('🔄 Reset to ALL tasks: ${filteredTasks.length} tasks');
  }

  void applyFilter(String? filterType) {
    currentFilter.value = filterType;

    if (filterType == null) {
      _resetToAllTasks();
      return;
    }

    switch (filterType) {
      case 'pending':
        filteredTasks.value = allTasks
            .where((task) => task.status == 'pending' && !task.isExpired)
            .toList();
        print(' Showing PENDING tasks: ${filteredTasks.length} tasks');
        break;

      case 'submitted':
        filteredTasks.value = allTasks
            .where((task) => task.status == 'submitted')
            .toList();
        print(' Showing SUBMITTED tasks: ${filteredTasks.length} tasks');
        break;

      case 'completed':
        filteredTasks.value = allTasks
            .where((task) => task.status == 'completed')
            .toList();
        print(' Showing COMPLETED tasks: ${filteredTasks.length} tasks');
        break;

      case 'expired_Declined':
        filteredTasks.value = allTasks
            .where((task) => task.status == 'Declined' || task.isExpired)
            .toList();
        print(' Showing EXPIRED/DECLINED tasks: ${filteredTasks.length} tasks');
        break;
    }

    update();
  }

  int getFilterCount(String? filterType) {
    switch (filterType) {
      case 'pending':
        return pendingCount.value;
      case 'submitted':
        return submittedCount.value;
      case 'completed':
        return completedCount.value;
      case 'expired_Declined':
        return expiredDeclinedCount.value;
      default:
        return totalCount.value;
    }
  }

  Future<void> refreshTasks() async {
    print(' Refreshing tasks...');
    await fetchAllTasks();
  }
}