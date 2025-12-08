import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_name/controller/login_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeWidget extends StatelessWidget {
  PinCodeWidget({super.key});

  LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: controller.login_pass,
      appContext: context, 
      length: 6,
      keyboardType: TextInputType.number,
      obscureText: true,
      obscuringCharacter: "*",
      textStyle: TextStyle(color: Color(0xff283442)),
      enableActiveFill: true,
      pastedTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xff283442)
      ),
      cursorHeight: 65,
      cursorColor: Color(0xff283442),
      cursorWidth: 2,
      pinTheme: PinTheme(
        borderRadius: BorderRadius.circular(8),
        shape: PinCodeFieldShape.box,
        fieldHeight: 75,
        fieldWidth: 50,
        selectedColor: Color(0xff283442),
        activeColor: Color(0xff283442),
        inactiveColor: Color(0xff283442),
        selectedFillColor: Colors.white,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        borderWidth: 2,
      ),
      onCompleted: (value) {
        Get.toNamed("/welcome");
      },
      onChanged: (value) {
        
      },
    );
  }
}