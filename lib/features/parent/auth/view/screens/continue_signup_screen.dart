import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/auth_controller.dart';
import '../widget/custom_input_field.dart';

class ContinueSignupScreen extends StatelessWidget {
  ContinueSignupScreen({super.key});

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beigeBackground,
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Container(
                height: 174,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/parent_auth_background.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Signup",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: AppColors.darkPrimary,
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: controller.continueSignupKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    CustomInputField(
                      title: "Email",
                      controller: controller.sEmail,
                      hint: "username@example.com",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    CustomInputField(
                      title: "Password",
                      controller: controller.sPassword,
                      hint: "********",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    CustomInputField(
                      title: "Confirm Password",
                      controller: controller.confirmPassword,
                      hint: "********",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              Spacer(),

              SizedBox(
                height: 40,
                child: Row(
                  spacing: 10,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.darkPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.beigeBackground,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: GetBuilder<AuthController>(
                          builder: (_) {
                            return InkWell(
                              onTap: () {
                                controller.signup();
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: 40,
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
                                        "Continue",
                                        style: TextStyle(
                                          color: AppColors.beigeBackground,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
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
