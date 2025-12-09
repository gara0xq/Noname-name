import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:testss/features/parent/home/view/widgets/home_top_bar.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/child_details_controller.dart';
import '../../model/child_model.dart';
import '../widgets/task_card_widget.dart';
import '../widgets/add_task_dialog.dart';

class ChildDetailsScreen extends StatelessWidget {
  final ChildModel child;

  const ChildDetailsScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChildDetailsController(child: child));
    final bool isMale = child.gender == 'male';
    final Color bgColor = isMale
        ? AppColors.primaryOrange
        : AppColors.primaryGreen;
    final String childImage = isMale
        ? 'assets/images/boy.png'
        : 'assets/images/girl.png';

    return Scaffold(
      backgroundColor: AppColors.beigeBackground,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.darkPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const HomeTopBar(),
                      ],
                    ),
                  ),

                  _buildChildInfoSection(isMale, childImage, controller, child),
                ],
              ),
            ),
          ),

          Container(
            color: Colors.white,
            child: TabBar(
              controller: controller.tabController,
              labelColor: AppColors.darkPrimary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.taskCardYellow,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: 'Tasks'),
                Tab(text: 'Rewards'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [_buildTasksTab(controller, child), _buildRewardsTab()],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.dialog(const AddTaskDialog()),
        backgroundColor: AppColors.darkPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildChildInfoSection(
    bool isMale,
    String childImage,
    ChildDetailsController controller,
    ChildModel child,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMale ? 0 : 20,
        right: isMale ? 20 : 0,
        top: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMale) _buildChildImage(isMale, childImage, controller),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 30,
                left: isMale ? 0 : 20,
                right: isMale ? 20 : 0,
              ),
              child: _buildChildInfoContent(isMale, controller, child),
            ),
          ),

          if (!isMale) _buildChildImage(isMale, childImage, controller),
        ],
      ),
    );
  }

  Widget _buildChildImage(
    bool isMale,
    String childImage,
    ChildDetailsController controller,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          childImage,
          height: 180,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              isMale ? Icons.boy : Icons.girl,
              size: 90,
              color: Colors.white.withOpacity(0.5),
            );
          },
        ),
        Positioned(
          bottom: 10,
          left: isMale ? 80 : null,
          right: isMale ? null : 80,
          child: InkWell(
            onTap: controller.showDeleteConfirmationDialog,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.delete, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChildInfoContent(
    bool isMale,
    ChildDetailsController controller,
    ChildModel child,
  ) {
    return Column(
      crossAxisAlignment: isMale
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          child.name,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: isMale ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 12),

        _buildCodeContainer(isMale, controller, child),

        const SizedBox(height: 12),

        _buildPointsContainer(isMale, child),
      ],
    );
  }

  Widget _buildCodeContainer(
    bool isMale,
    ChildDetailsController controller,
    ChildModel child,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isMale
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          const Text(
            'Code: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            child.code,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: controller.copyChildCode,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.copy, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsContainer(bool isMale, ChildModel child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isMale
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              "assets/icons/star.svg",
              width: 14,
              height: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${child.points} Points',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab(ChildDetailsController controller, ChildModel child) {
    return Obx(() {
      if (controller.isLoadingTasks.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        );
      }

      if (controller.tasksList.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_alt, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No tasks yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.tasksList.length,
        itemBuilder: (context, index) {
          final task = controller.tasksList[index];
          return TaskCardWidget(task: task, childName: child.name);
        },
      );
    });
  }

  Widget _buildRewardsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.card_giftcard, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Rewards coming soon',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
