import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';
import '../widget/pin_code_widget.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xff283442),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.arrow_back_ios, color: Color(0xffFEF8F3)),
                ),
              ),
            ),
          ),
          // SizedBox(height: 14,),
          Text(
            "Welcome",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 35),
          ),
          Text(
            "Enter your code",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Container(
            height: 520,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xffFE6C3B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: PinCodeWidget(controller: controller),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 63),
                  child: Image.asset(
                    "assets/login_image.png",
                    width: 300,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
