import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/child_rewards_controller.dart';
import '../../controller/home_controller.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rewardsController = Get.put(ChildRewardsController());
    final homeController = Get.find<HomeController>();

    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: rewardsController.refreshRewards,
      child: Obx(() {
        if (rewardsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryGreen,
            ),
          );
        }

        if (rewardsController.hasError.value) {
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
                  'Error Loading Rewards',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  rewardsController.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: rewardsController.refreshRewards,
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

        if (rewardsController.rewardsList.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No rewards available',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Complete tasks to earn points and unlock rewards!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Points Display Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      homeController.child.gender == "male"
                          ? AppColors.primaryOrange
                          : AppColors.primaryGreen,
                      homeController.child.gender == "male"
                          ? AppColors.primaryOrange.withOpacity(0.8)
                          : AppColors.primaryGreen.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/star.svg",
                        width: 32,
                        height: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Points',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${homeController.child.points}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Available Rewards',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              const SizedBox(height: 16),

              // Rewards Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: rewardsController.rewardsList.length,
                itemBuilder: (context, index) {
                  final reward = rewardsController.rewardsList[index];
                  final canRedeem = homeController.child.points >= reward.points;

                  return _buildRewardCard(
                    context,
                    reward,
                    canRedeem,
                    rewardsController,
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRewardCard(
    BuildContext context,
    reward,
    bool canRedeem,
    ChildRewardsController controller,
  ) {
    return InkWell(
      onTap: () {
        if (reward.imageUrl != null && reward.imageUrl!.isNotEmpty) {
          _showImageDialog(context, reward.imageUrl!);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: reward.isRedeemed
              ? Colors.grey[300]
              : canRedeem
                  ? AppColors.taskCardYellow
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: reward.isRedeemed
                ? Colors.grey
                : canRedeem
                    ? AppColors.taskCardYellow
                    : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container with Badge
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: reward.isRedeemed
                          ? Colors.grey[400]
                          : canRedeem
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                      child: reward.imageUrl != null && reward.imageUrl!.isNotEmpty
                          ? Image.network(
                              reward.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.card_giftcard,
                                    size: 50,
                                    color: reward.isRedeemed
                                        ? Colors.grey[600]
                                        : canRedeem
                                            ? Colors.white
                                            : Colors.grey[400],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                Icons.card_giftcard,
                                size: 50,
                                color: reward.isRedeemed
                                    ? Colors.grey[600]
                                    : canRedeem
                                        ? Colors.white
                                        : Colors.grey[400],
                              ),
                            ),
                    ),
                  ),
                  
                  // Status Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: reward.isRedeemed 
                            ? Colors.green 
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        reward.isRedeemed ? 'Redeemed' : 'Not Redeemed',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Redeemed Overlay
                  if (reward.isRedeemed)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info Container
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reward.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: reward.isRedeemed
                            ? Colors.grey[700]
                            : canRedeem
                                ? Colors.white
                                : Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: reward.isRedeemed
                                    ? Colors.grey[500]
                                    : canRedeem
                                        ? Colors.white
                                        : AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/star.svg",
                                width: 12,
                                height: 12,
                                color: reward.isRedeemed
                                    ? Colors.white
                                    : canRedeem
                                        ? AppColors.taskCardYellow
                                        : Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${reward.points}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: reward.isRedeemed
                                    ? Colors.grey[700]
                                    : canRedeem
                                        ? Colors.white
                                        : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        
                        // Redeem Button
                        if (!reward.isRedeemed && canRedeem)
                          InkWell(
                            onTap: () {
                              _showRedeemDialog(
                                context,
                                reward.id,
                                reward.title,
                                reward.points,
                                controller,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Redeem',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.taskCardYellow,
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
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRedeemDialog(
    BuildContext context,
    String rewardId,
    String rewardTitle,
    int rewardPoints,
    ChildRewardsController controller,
  ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.card_giftcard,
                color: AppColors.primaryGreen,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Redeem Reward',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to redeem "$rewardTitle" for $rewardPoints points?',
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
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.redeemReward(rewardId);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.darkPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Redeem',
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