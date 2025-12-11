import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aes256/aes256.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/dio_client.dart';

class AuthController extends GetxController {
  TextEditingController lEmail = TextEditingController();
  TextEditingController lPassword = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController familyCode = TextEditingController();
  TextEditingController sEmail = TextEditingController();
  TextEditingController sPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  final signupKey = GlobalKey<FormState>();
  final continueSignupKey = GlobalKey<FormState>();

  bool isLoading = false;
  double buttonWidth = 300;

  Future<void> login() async {
    final sharedPreferances = await SharedPreferences.getInstance();
    const String uri = '/user/parent/login';
    final dioClient = DioClient();

    if (loginKey.currentState!.validate()) {
      loadingAimation();
      try {
        final response = await dioClient.post(
          uri: uri,
          data: {"email": lEmail.text, "password": lPassword.text},
        );
        if (response.statusCode == 201 && response.data != null) {
          final token = Aes256.encrypt(
            text: response.data["token"],
            passphrase: AppConstants.HASHER_KEY,
          );

          await sharedPreferances.setString("token", token);

          AppConstants.AUTH_TOKEN = response.data["token"];
          final userType = "parent";
          await sharedPreferances.setString("user-type", userType);

          final hasChildren = await _checkIfUserHasChildren();

          loadingAimation(isStart: false);
          if (hasChildren) {
            Get.offAllNamed("/main");
          } else {
            Get.offAllNamed("/add_child", arguments: {"showSkipButton": true});
          }
        }
      } on Exception catch (e) {
        log(e.toString());
        loadingAimation(isStart: false);
      }
    } else {
      loadingAimation(isStart: false);
      Get.snackbar(
        'Error',
        'Invalid data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> signup() async {
    const String uri = '/user/parent/register';
    final dioClient = DioClient();

    if (signupKey.currentState!.validate() &&
        sPassword.text == confirmPassword.text) {
      loadingAimation();

      try {
        final response = await dioClient.post(
          uri: uri,
          data: {
            "name": "${firstName.text} ${lastName.text}",
            "email": sEmail.text,
            "password": sPassword.text,
            "phone_number": phoneNumber.text,
            if (familyCode.text.isNotEmpty) "family_code": familyCode.text,
          },
        );

        if (response.statusCode == 201 && response.data != null) {
          Get.offAllNamed("/login");
        }
        loadingAimation(isStart: false);
      } on Exception catch (e) {
        log(e.toString());
        loadingAimation(isStart: false);
      }
    } else {
      loadingAimation(isStart: false);
      Get.snackbar(
        'Error',
        'Invalid data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<bool> _checkIfUserHasChildren() async {
    const String uri = '/user/parent/getChildren';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.get(uri: uri);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic>? childrenJson = response.data['children'];
        return childrenJson != null && childrenJson.isNotEmpty;
      }
      return false;
    } catch (e) {
      log('Error checking children: $e');
      return false;
    }
  }

  loadingAimation({bool isStart = true}) {
    if (isStart) {
      buttonWidth = 50;
      isLoading = true;
      update();
    } else {
      isLoading = false;
      buttonWidth = 300;
      update();
    }
  }
}
