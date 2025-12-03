import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/auth_bindings.dart';
import 'features/auth/view/screens/continue_signup_screen.dart';
import 'features/auth/view/screens/login_screen.dart';
import 'features/auth/view/screens/signup_screen.dart';
import 'features/auth/view/screens/splash_screen.dart';
import 'features/auth/view/screens/welcome_screen.dart';
import 'features/home/view/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'test',
      debugShowCheckedModeBanner: false,
      initialRoute: "/welcome",
      initialBinding: AuthBindings(),
      getPages: [
        GetPage(name: "/splash", page: () => SplashScreen()),
        GetPage(name: "/welcome", page: () => WelcomeScreen()),
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/signup", page: () => SignupScreen()),
        GetPage(name: "/continue_signup", page: () => ContinueSignupScreen()),
        GetPage(name: "/main", page: () => MainScreen()),
      ],
    );
  }
}
