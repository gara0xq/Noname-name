// lib/core/services/cloudinary_service.dart

import 'dart:io';
import 'dart:developer';
import 'package:cloudinary/cloudinary.dart';

class CloudinaryService {
  static const String cloudName = 'do3ob6bif';
  static const String apiKey = '381892251377675';
  static const String apiSecret = 'vtLf6BfJ4irTC2VT9hAc2N3KVqE';
  
  late final Cloudinary _cloudinary;
  
  CloudinaryService() {
    // ✅ تهيئة Cloudinary مع API credentials
    _cloudinary = Cloudinary.signedConfig(
      apiKey: apiKey,
      apiSecret: apiSecret,
      cloudName: cloudName,
    );
  }

  /// 📤 رفع صورة إلى Cloudinary (Signed Upload)
  Future<String?> uploadImage({
    required File imageFile,
    String folder = 'rewards',
    String? fileName,
  }) async {
    try {
      log('🚀 بدء رفع الصورة إلى Cloudinary...');

      final response = await _cloudinary.upload(
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: folder,
        fileName: fileName ?? 'reward_${DateTime.now().millisecondsSinceEpoch}',
        progressCallback: (count, total) {
          final progress = ((count / total) * 100).toStringAsFixed(1);
          log('📊 تقدم الرفع: $progress%');
        },
      );

      if (response.isSuccessful && response.secureUrl != null) {
        final imageUrl = response.secureUrl!;
        log('✅ تم رفع الصورة بنجاح: $imageUrl');
        return imageUrl;
      } else {
        // log('❌ فشل رفع الصورة: ${response.error?.message}');
        return null;
      }
    } catch (e) {
      log('❌ خطأ أثناء رفع الصورة: $e');
      return null;
    }
  }

  /// 📤 رفع صورة بدون توقيع (Unsigned Upload) - للأمان في التطبيقات الأمامية
  Future<String?> uploadImageUnsigned({
    required File imageFile,
    String folder = 'rewards',
    String? fileName,
    required String uploadPreset, // ⚠️ مطلوب لـ Unsigned Upload
  }) async {
    try {
      log('🚀 بدء رفع صورة غير موقعة إلى Cloudinary...');

      final response = await _cloudinary.unsignedUpload(
        file: imageFile.path,
        uploadPreset: uploadPreset, // مثل 'flutter_upload_preset'
        resourceType: CloudinaryResourceType.image,
        folder: folder,
        fileName: fileName ?? 'reward_${DateTime.now().millisecondsSinceEpoch}',
        progressCallback: (count, total) {
          final progress = ((count / total) * 100).toStringAsFixed(1);
          log('📊 تقدم الرفع: $progress%');
        },
      );

      if (response.isSuccessful && response.secureUrl != null) {
        final imageUrl = response.secureUrl!;
        log('✅ تم رفع الصورة بنجاح: $imageUrl');
        return imageUrl;
      } else {
        // log('❌ فشل رفع الصورة: ${response.error?.message}');
        return null;
      }
    } catch (e) {
      log('❌ خطأ أثناء رفع الصورة: $e');
      return null;
    }
  }

  /// 🗑️ حذف صورة من Cloudinary
  Future<bool> deleteImage(String publicId) async {
    try {
      log('🗑️ حذف الصورة: $publicId');
      
      final response = await _cloudinary.destroy(
        publicId,
        resourceType: CloudinaryResourceType.image,
      );

      if (response.isSuccessful ?? false) {
        log('✅ تم حذف الصورة بنجاح');
        return true;
      } else {
        // log('❌ فشل حذف الصورة: ${response.error?.message}');
        return false;
      }
    } catch (e) {
      log('❌ خطأ أثناء حذف الصورة: $e');
      return false;
    }
  }
}