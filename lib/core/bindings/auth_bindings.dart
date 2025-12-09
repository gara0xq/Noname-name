import 'package:get/get.dart';

import '../../features/parent/auth/controller/auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
