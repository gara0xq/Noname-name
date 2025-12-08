import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_name/view/login.dart';
import 'package:no_name/view/welcome.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/login", page: () => Login()),
        GetPage(name: "/welcome", page: () => Welcome()),
      ],
    );
  }
}
