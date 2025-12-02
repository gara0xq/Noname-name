import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/Home/View/home_screen.dart'; 

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'no name',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}