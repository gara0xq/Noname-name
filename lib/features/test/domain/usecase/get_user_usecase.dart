import 'package:no_name/features/test/domain/repo/test_repo.dart';

class GetUserUsecase {
  final TestRepo testRepo;

  GetUserUsecase(this.testRepo);

  Future<String> call(String email, String password) async {
    return await testRepo.getUserId(email, password);
  }
}
