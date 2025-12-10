import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/dio_client.dart';
import '../model/reward_model.dart';
import './home_controller.dart';

class ChildRewardsController extends GetxController {
  final rewardsList = <RewardModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isRedeeming = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRewards();
  }

  Future<void> fetchRewards() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    const String uri = '/user/child/getRewards';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.get(uri: uri);

      if (response.statusCode == 200 && response.data != null) {
        log(' Rewards Response: ${response.data}');

        final Map<String, dynamic> responseData = response.data;

        if (responseData.containsKey('rewards')) {
          final List<dynamic> rewardsJson = responseData['rewards'];

          rewardsList.clear();
          final List<RewardModel> rewards = rewardsJson
              .map((rewardMap) => RewardModel.fromJson(rewardMap))
              .toList();
          rewardsList.addAll(rewards);

          log(' Loaded ${rewards.length} rewards');
        }
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load rewards: $e';
      log(' Error fetching rewards: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> redeemReward(String rewardId) async {
    if (isRedeeming.value) return;
    
    isRedeeming.value = true;
    
    final String uri = '/user/child/redeemedReward/$rewardId';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.put(uri: uri, data: {});

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(' Reward redeemed successfully');

        Get.snackbar(
          'Success',
          'Reward redeemed successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF8ED8B4),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Refresh rewards list to update status
        await fetchRewards();
        
        // Refresh child data to update points
        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          await homeController.fetchChildData();
          log('🔄 Child points refreshed');
        }
      }
    } catch (e) {
      log(' Error redeeming reward: $e');
      Get.snackbar(
        'Error',
        'Failed to redeem reward. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isRedeeming.value = false;
    }
  }

  Future<void> refreshRewards() async {
    await fetchRewards();
    
    // Also refresh child data
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      await homeController.fetchChildData();
    }
  }
}