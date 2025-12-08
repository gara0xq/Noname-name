import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.offNamed("login");
          },
          child: Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
      ),
    );
  }
}