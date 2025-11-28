import 'package:get/get.dart';
import 'package:no_name/features/test/data/repo_impl/test_repo_impl.dart';

import '../../domain/usecase/get_user_usecase.dart';

class TestController extends GetxController {
  final GetUserUsecase _getUserUseCase;

  TestController() : _getUserUseCase = GetUserUsecase(TestRepoImpl());

  fetchUser(email, password) async {
    await _getUserUseCase.call(email, password);
    update();
  }
}
