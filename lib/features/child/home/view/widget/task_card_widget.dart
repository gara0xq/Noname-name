import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../core/constants/app_colors.dart';
import '../../model/task_model.dart';
import '../screens/tasks_details_screen.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskModel task;
  final String? childName;

  const TaskCardWidget({super.key, required this.task, this.childName});

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'No date';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayChildName = task.childName ?? childName ?? '';

    return InkWell(
      onTap: () => Get.to(() => TaskDetailsScreen(task: task)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.taskCardYellow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/star.svg",
                    width: 16,
                    height: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  task.points.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  _formatDate(task.expireDate),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                if (displayChildName.isNotEmpty) ...[
                  const Icon(Icons.person, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      displayChildName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
