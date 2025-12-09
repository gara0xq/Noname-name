import 'dart:async';
import 'package:get/get.dart';
import '../../../../core/services/dio_client.dart';
import '../model/task_model.dart';

class TasksController extends GetxController {
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

    const String uri = '/user/parent/getTasks';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.get(uri: uri);

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData.containsKey('tasks')) {
          final List<dynamic> tasksJson = responseData['tasks'];

          allTasks.clear();
          final List<TaskModel> tasks = tasksJson
              .map((taskMap) => TaskModel.fromJson(taskMap))
              .toList();
          allTasks.addAll(tasks);

          _calculateStats();

          _resetToAllTasks();

          print(' All tasks loaded: ${tasks.length} tasks');
          print(
            ' Stats - Total: $totalCount, Pending: $pendingCount, Submitted: $submittedCount, Completed: $completedCount, Expired/Declined: $expiredDeclinedCount',
          );
        }
      }
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
    print(' Reset to ALL tasks: ${filteredTasks.length} tasks');
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
        print('🔄 Showing PENDING tasks: ${filteredTasks.length} tasks');
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
