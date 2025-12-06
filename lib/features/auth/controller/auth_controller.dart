import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aes256/aes256.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/dio_client.dart';

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
          loadingAimation(isStart: false);
          Get.offAllNamed("/main");
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
