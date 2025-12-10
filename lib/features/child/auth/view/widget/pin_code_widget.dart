import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeWidget extends StatelessWidget {
  final TextEditingController controller;
  const PinCodeWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: controller,
      appContext: context,
      length: 6,
      keyboardType: TextInputType.number,
      textStyle: TextStyle(color: Color(0xff283442)),
      enableActiveFill: true,
      cursorColor: Colors.black,
      pastedTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xff283442),
      ),
      cursorHeight: 30,
      pinTheme: PinTheme(
        borderRadius: BorderRadius.circular(8),
        shape: PinCodeFieldShape.box,
        fieldHeight: 70,
        fieldWidth: 45,
        selectedColor: Colors.transparent,
        activeColor: Colors.transparent,
        inactiveColor: Colors.transparent,
        selectedFillColor: Colors.white,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        borderWidth: 0,
      ),
      onCompleted: (value) {
        // Get.toNamed("/welcome");
      },
      onChanged: (value) {},
    );
  }
}
