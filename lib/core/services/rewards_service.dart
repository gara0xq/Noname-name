// lib/core/services/rewards_service.dart

import 'dart:developer';
import 'dio_client.dart';

class RewardsService {
  /// 🎁 إضافة مكافأة جديدة
  Future<bool> addReward({
    required String childCode,
    required String title,
    required int points,
    required String imageUrl,
  }) async {
    const String uri = '/user/parent/addReward';
    final dioClient = DioClient(hasToken: true);

    try {
      log('🎁 إضافة مكافأة جديدة...');
      log('Child Code: $childCode');
      log('Title: $title');
      log('Points: $points');
      log('Image URL: $imageUrl');

      final response = await dioClient.post(
        uri: uri,
        data: {
          "code": childCode,
          "title": title,
          "points": points,
          "imageurl": imageUrl,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ تم إضافة المكافأة بنجاح');
        return true;
      } else {
        log('❌ فشل إضافة المكافأة: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      log('❌ خطأ أثناء إضافة المكافأة: $e');
      rethrow;
    }
  }

  /// 📋 جلب مكافآت طفل معين
  Future<List<dynamic>> getChildRewards(String childCode) async {
    const String uri = '/user/parent/getReward';
    final dioClient = DioClient(hasToken: true);

    try {
      log('📋 جلب مكافآت الطفل: $childCode');

      final response = await dioClient.getWithBody(
        uri: uri,
        data: {"code": childCode},
      );
      if (response.statusCode == 201 && response.data != null) {
        log('✅ تم جلب المكافآت بنجاح');

        return response.data['reward'] as List<dynamic>;
      }

      log('⚠️ لا توجد مكافآت');
      return [];
    } catch (e) {
      log('❌ خطأ أثناء جلب المكافآت: $e');
      rethrow;
    }
  }

  /// 🗑️ حذف مكافأة
  Future<bool> deleteReward(String rewardId) async {
    final String uri = '/user/parent/deleteReward/$rewardId';
    final dioClient = DioClient(hasToken: true);

    try {
      log('🗑️ حذف المكافأة: $rewardId');

      final response = await dioClient.delete(uri: uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ تم حذف المكافأة بنجاح');
        return true;
      } else {
        log('❌ فشل حذف المكافأة');
        return false;
      }
    } catch (e) {
      log('❌ خطأ أثناء حذف المكافأة: $e');
      rethrow;
    }
  }

  /// ✏️ تعديل مكافأة
  Future<bool> updateReward({
    required String rewardId,
    required String title,
    required int points,
    required String imageUrl,
  }) async {
    const String uri = '/user/parent/updatedReward';
    final dioClient = DioClient(hasToken: true);

    try {
      log('✏️ تعديل المكافأة: $rewardId');

      final response = await dioClient.put(
        uri: uri,
        data: {
          "rewardId": rewardId,
          "title": title,
          "points": points,
          "imageurl": imageUrl,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ تم تعديل المكافأة بنجاح');
        return true;
      } else {
        log('❌ فشل تعديل المكافأة');
        return false;
      }
    } catch (e) {
      log('❌ خطأ أثناء تعديل المكافأة: $e');
      rethrow;
    }
  }
}
