import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/tasks_controller.dart';

class TaskFilterWidget extends StatelessWidget {
  const TaskFilterWidget({super.key});

  final List<Map<String, dynamic>> _filters = const [
    {
      'value': null,
      'label': 'All Tasks',
      'icon': Icons.all_inclusive,
      'color': AppColors.darkPrimary,
    },
    {
      'value': 'pending',
      'label': 'Pending',
      'icon': Icons.pending_actions,
      'color': AppColors.primaryOrange,
    },
    {
      'value': 'submitted',
      'label': 'Submitted',
      'icon': Icons.upload_file,
      'color': AppColors.primaryGreen,
    },
    {
      'value': 'completed',
      'label': 'Completed',
      'icon': Icons.check_circle,
      'color': Color(0xFF2E7D32),
    },
    {
      'value': 'expired_Declined',
      'label': 'Expired/Declined',
      'icon': Icons.error_outline,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final TasksController controller = Get.find<TasksController>();

    return Obx(() {
      final selectedFilter = controller.currentFilter.value;

      return Container(
        height: 80,
        color: AppColors.beigeBackground,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = selectedFilter == filter['value'];
            final taskCount = controller.getFilterCount(filter['value']);

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () => controller.applyFilter(filter['value']),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? filter['color'] : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? filter['color']
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            filter['icon'],
                            size: 18,
                            color: isSelected ? Colors.white : filter['color'],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            filter['label'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          taskCount.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
