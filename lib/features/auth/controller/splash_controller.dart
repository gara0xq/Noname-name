import 'dart:async';
import 'package:aes256/aes256.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../core/constants/app_constants.dart';

class SplashController extends GetxController {
  VideoPlayerController? _controller;
  bool _visible = true;
  Color backGroundColor = const Color(0xfffd6c39);

  @override
  void onInit() async {
    super.onInit();

    _controller = VideoPlayerController.asset(
      "assets/videos/coinly.mp4",
      videoPlayerOptions: VideoPlayerOptions(),
    );

    _controller!.initialize().then((_) async {
      Timer(const Duration(milliseconds: 100), () async {
        _visible = true;
        _controller!.play();
      });

      final sharedPreferances = await SharedPreferences.getInstance();
      final token = sharedPreferances.getString(AppConstants.TOKEN_KEY);

      Future.delayed(Duration(seconds: 5), () async {
        if (token == null) {
          Get.offAllNamed("/welcome");
        } else {
          AppConstants.AUTH_TOKEN = Aes256.decrypt(
            encrypted: token,
            passphrase: AppConstants.HASHER_KEY,
          ).toString();
          Get.offAllNamed("/main");
        }
      });
    });
  }

  @override
  void onClose() {
    _controller?.dispose();
    super.onClose();
  }

  getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: Center(child: VideoPlayer(_controller!)),
    );
  }
}
