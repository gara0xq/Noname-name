// lib/core/services/image_picker_service.dart

import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

/// 📸 خدمة اختيار الصور
/// 
/// هذه الخدمة مسؤولة عن:
/// 1. طلب الأذونات من المستخدم
/// 2. فتح الكاميرا أو المعرض
/// 3. اختيار الصورة وإرجاعها
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// 🔐 طلب أذونات الوصول للصور والكاميرا
  /// 
  /// يرجع: true إذا تم منح الأذونات، false إذا تم الرفض
  Future<bool> requestPermissions() async {
    try {
      log('📋 طلب الأذونات...');

      // طلب أذونات الصور
      PermissionStatus photosStatus = await Permission.photos.request();
      
      // طلب أذونات الكاميرا
      PermissionStatus cameraStatus = await Permission.camera.request();

      log('📸 حالة أذونات الصور: $photosStatus');
      log('📷 حالة أذونات الكاميرا: $cameraStatus');

      // التحقق من منح الأذونات
      if (photosStatus.isGranted || photosStatus.isLimited) {
        log('✅ تم منح أذونات الصور');
        return true;
      } else if (photosStatus.isDenied) {
        log('⚠️ تم رفض أذونات الصور');
        _showPermissionDeniedDialog();
        return false;
      } else if (photosStatus.isPermanentlyDenied) {
        log('🚫 تم رفض أذونات الصور بشكل دائم');
        _showPermanentlyDeniedDialog();
        return false;
      }

      return false;
    } catch (e) {
      log('❌ خطأ في طلب الأذونات: $e');
      return false;
    }
  }

  /// 📷 التقاط صورة من الكاميرا
  /// 
  /// يرجع: ملف الصورة أو null
  Future<File?> pickImageFromCamera() async {
    try {
      // طلب الأذونات أولاً
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        log('❌ لا توجد أذونات للكاميرا');
        return null;
      }

      log('📷 فتح الكاميرا...');

      // التقاط الصورة
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // جودة الصورة (0-100)
        maxWidth: 1920, // أقصى عرض
        maxHeight: 1080, // أقصى ارتفاع
      );

      if (image != null) {
        log('✅ تم التقاط الصورة: ${image.path}');
        return File(image.path);
      } else {
        log('⚠️ لم يتم التقاط صورة');
        return null;
      }
    } catch (e) {
      log('❌ خطأ أثناء التقاط الصورة: $e');
      return null;
    }
  }

  /// 🖼️ اختيار صورة من المعرض
  /// 
  /// يرجع: ملف الصورة أو null
  Future<File?> pickImageFromGallery() async {
    try {
      // طلب الأذونات أولاً
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        log('❌ لا توجد أذونات للمعرض');
        return null;
      }

      log('🖼️ فتح المعرض...');

      // اختيار الصورة
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        log('✅ تم اختيار الصورة: ${image.path}');
        return File(image.path);
      } else {
        log('⚠️ لم يتم اختيار صورة');
        return null;
      }
    } catch (e) {
      log('❌ خطأ أثناء اختيار الصورة: $e');
      return null;
    }
  }

  /// 📝 عرض نافذة حوارية لاختيار مصدر الصورة
  /// 
  /// يرجع: ملف الصورة أو null
  Future<File?> showImageSourceDialog() async {
    File? imageFile;

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Image Source',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // زر الكاميرا
                  InkWell(
                    onTap: () async {
                      Get.back();
                      imageFile = await pickImageFromCamera();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Camera'),
                      ],
                    ),
                  ),
                  // زر المعرض
                  InkWell(
                    onTap: () async {
                      Get.back();
                      imageFile = await pickImageFromGallery();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Gallery'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return imageFile;
  }

  /// ⚠️ عرض رسالة عند رفض الأذونات
  void _showPermissionDeniedDialog() {
    Get.snackbar(
      'Permission Denied',
      'Please allow access to photos and camera',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// 🚫 عرض رسالة عند رفض الأذونات بشكل دائم
  void _showPermanentlyDeniedDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 60,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Text(
                'Permission Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please go to Settings and allow access to photos and camera',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        openAppSettings(); // فتح إعدادات التطبيق
                      },
                      child: const Text('Settings'),
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