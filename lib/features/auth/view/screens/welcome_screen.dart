import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../widget/card_welcome.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beigeBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "I am a",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: AppColors.darkPrimary,
              ),
            ),
            Text(
              "Select on that applies you",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xff283442),
              ),
            ),
            SizedBox(height: 27),
            InkWell(
              onTap: () {
                Get.toNamed("/login");
              },
              child: CardWelcome(
                imge: "assets/images/parent.png",
                name: "Parent",
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: CardWelcome(
                imge: "assets/images/child.png",
                name: "Child",
                color: AppColors.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
