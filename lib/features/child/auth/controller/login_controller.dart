import 'dart:developer';

import 'package:aes256/aes256.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/dio_client.dart';

class LoginController extends GetxController {
  TextEditingController loginPass = TextEditingController();
  bool isLoading = false;
  double buttonWidth = 300;

  Future<void> login() async {
    final sharedPreferances = await SharedPreferences.getInstance();
    const String uri = '/user/child/login';
    final dioClient = DioClient();
    log(loginPass.text);
    loadingAimation();
    try {
      final response = await dioClient.post(
        uri: uri,
        data: {"childCode": loginPass.text},
      );
      if (response.statusCode == 200 && response.data != null) {
        final token = Aes256.encrypt(
          text: response.data["token"],
          passphrase: AppConstants.HASHER_KEY,
        );

        await sharedPreferances.setString("token", token);

        AppConstants.AUTH_TOKEN = response.data["token"];
        AppConstants.USER_TYPE = "child";
        await sharedPreferances.setString("user-type", AppConstants.USER_TYPE);

        loadingAimation(isStart: false);

        Get.offAllNamed("/child_welcome");
      }
    } on Exception catch (e) {
      log(e.toString());
      loadingAimation(isStart: false);
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
