import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controller/auth_controller.dart';
import '../widget/custom_input_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                key: controller.signupKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: CustomInputField(
                            title: "First name",
                            controller: controller.firstName,
                            hint: "John",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomInputField(
                            title: "Last name",
                            controller: controller.lastName,
                            hint: "Wich",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 50,
                          child: CustomInputField(
                            title: "",
                            hint: "+2",
                            readOnly: true,
                          ),
                        ),
                        Expanded(
                          child: CustomInputField(
                            title: "Phone number",
                            controller: controller.phoneNumber,
                            hint: "01* *** ** ***",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: Get.width / 2,
                      child: CustomInputField(
                        title: "Family code (optional)",
                        controller: controller.familyCode,
                        hint: "123456",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          } else if (value.length != 6) {
                            return "Family code must be 6 digits";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),
              Center(
                child: InkWell(
                  onTap: () {
                    Get.offAllNamed("/login");
                  },
                  child: Container(
                    width: 200,
                    height: 40,

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Already have an account",
                      style: TextStyle(color: AppColors.beigeBackground),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Get.toNamed("/continue_signup");
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 300,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.darkPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: AppColors.beigeBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
