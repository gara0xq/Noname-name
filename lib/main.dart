import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'core/bindings/auth_bindings.dart';
import 'features/child/auth/view/screens/login.dart';
import 'features/child/home/view/screens/child_main_screen.dart';
import 'features/child/home/view/screens/welcome.dart';
import 'features/parent/auth/view/screens/continue_signup_screen.dart';
import 'features/parent/auth/view/screens/login_screen.dart';
import 'features/parent/auth/view/screens/signup_screen.dart';
import 'features/splash/view/screens/splash_screen.dart';
import 'features/splash/view/screens/welcome_screen.dart';
import 'features/parent/home/view/screens/main_screen.dart';
import 'features/parent/home/view/screens/add_child_screen.dart';

void main() {
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'test',
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      initialBinding: AuthBindings(),
      getPages: [
        //splash
        GetPage(name: "/splash", page: () => SplashScreen()),
        GetPage(name: "/welcome", page: () => WelcomeScreen()),
        //parent auth
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/signup", page: () => SignupScreen()),
        GetPage(name: "/continue_signup", page: () => ContinueSignupScreen()),
        //parent main
        GetPage(name: "/main", page: () => MainScreen()),
        GetPage(name: "/add_child", page: () => AddChildScreen()),
        //child auth
        GetPage(name: "/child_login", page: () => Login()),
        GetPage(name: "/child_welcome", page: () => Welcome()),
        //child main
        GetPage(name: "/child_main", page: () => ChildMainScreen()),
      ],
    );
  }
}
