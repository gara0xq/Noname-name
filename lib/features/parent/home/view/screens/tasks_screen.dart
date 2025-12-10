import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testss/core/constants/app_colors.dart';
import 'package:testss/features/parent/home/view/screens/task_detail_screen.dart';
import 'package:testss/features/parent/home/view/widgets/home_top_bar.dart';
import 'package:testss/features/parent/home/view/widgets/task_filer_widget.dart';
import '../../controller/tasks_controller.dart';
import '../widgets/task_card_widget.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TasksController());

    return Scaffold(
      backgroundColor: AppColors.beigeBackground,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              color: AppColors.beigeBackground,
              child: const HomeTopBar(),
            ),
          ),

          const TaskFilterWidget(),

          Expanded(
            child: GetBuilder<TasksController>(
              builder: (controller) {
                if (controller.isLoading.value && controller.allTasks.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  );
                }

                if (controller.hasError.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error Loading Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: controller.refreshTasks,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredTasks.isEmpty) {
                  String emptyMessage = 'No tasks found';
                  String emptySubtitle =
                      'Try changing the filter or create new tasks';

                  if (controller.currentFilter.value != null) {
                    switch (controller.currentFilter.value) {
                      case 'pending':
                        emptyMessage = 'No pending tasks';
                        emptySubtitle =
                            'All tasks are either submitted, completed, expired, or declined';
                        break;
                      case 'submitted':
                        emptyMessage = 'No submitted tasks';
                        emptySubtitle =
                            'No tasks are waiting for your approval';
                        break;
                      case 'completed':
                        emptyMessage = 'No completed tasks';
                        emptySubtitle = 'No tasks have been approved yet';
                        break;
                      case 'expired_Declined':
                        emptyMessage = 'No expired or declined tasks';
                        emptySubtitle = 'Great! All tasks are active and valid';
                        break;
                    }
                  }

                  return RefreshIndicator(
                    color: AppColors.primaryGreen,
                    onRefresh: controller.refreshTasks,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                controller.currentFilter.value != null
                                    ? Icons.filter_alt_outlined
                                    : Icons.task_alt_outlined,
                                size: 100,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                emptyMessage,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  emptySubtitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              if (controller.currentFilter.value != null)
                                ElevatedButton(
                                  onPressed: () {
                                    controller.applyFilter(null);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 14,
                                    ),
                                  ),
                                  child: const Text(
                                    'Show All Tasks',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              else
                                ElevatedButton(
                                  onPressed: () {
                                    Get.offAllNamed("/main");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 14,
                                    ),
                                  ),
                                  child: const Text(
                                    'Go Back',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primaryGreen,
                  onRefresh: controller.refreshTasks,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = controller.filteredTasks[index];
                      return TaskCardWidget(
                        task: task,
                        onTap: () {
                          Get.to(
                            () => TaskDetailsScreen(taskId: task.id),
                            transition: Transition.rightToLeft,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}