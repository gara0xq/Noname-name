import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/login_controller.dart';
import '../widget/pin_code_widget.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beigeBackground,
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          child: Column(
            children: [
              SizedBox(height: 40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 35,
                    height: 35,
                    margin: const EdgeInsets.all(8.0),
                    padding: EdgeInsets.only(left: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.darkPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.beigeBackground,
                      size: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Welcome",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 35,
                  color: AppColors.darkPrimary,
                ),
              ),
              Text(
                "Enter your code",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPrimary,
                ),
              ),
              Spacer(),
              Container(
                height: 550,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffFE6C3B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: PinCodeWidget(
                            controller: controller.loginPass,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 63),
                          child: Image.asset(
                            "assets/images/login_image.png",
                            width: 300,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.all(30),
                        child: GetBuilder<LoginController>(
                          builder: (_) {
                            return InkWell(
                              onTap: () => controller.login(),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  width: controller.buttonWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkPrimary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: controller.isLoading
                                      ? CircularProgressIndicator(
                                          color: AppColors.beigeBackground,
                                        )
                                      : Text(
                                          "Confirm",
                                          style: TextStyle(
                                            color: AppColors.beigeBackground,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
