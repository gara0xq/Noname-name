import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/auth_controller.dart';
import '../widget/custom_input_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

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
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: AppColors.darkPrimary,
                ),
              ),
              SizedBox(height: 30),
              Form(
                key: controller.loginKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    CustomInputField(
                      title: "Email",
                      controller: controller.lEmail,
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
                      controller: controller.lPassword,
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
              SizedBox(height: 10),
              InkWell(
                onTap: () {},
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot your password?"),
                ),
              ),
              Spacer(),
              Center(
                child: InkWell(
                  onTap: () {
                    Get.offAllNamed("/signup");
                  },
                  child: Container(
                    width: 150,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Create an account",
                      style: TextStyle(color: AppColors.beigeBackground),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GetBuilder<AuthController>(
                builder: (_) {
                  return InkWell(
                    onTap: () => controller.login(),
                    child: Align(
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: controller.buttonWidth,
                        height: 50,
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
            ],
          ),
        ),
      ),
    );
  }
}
