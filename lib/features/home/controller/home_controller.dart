import 'dart:developer';

import 'package:aes256/aes256.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/dio_client.dart';
import '../model/user_model.dart';
import '../model/child_model.dart';

class HomeController extends GetxController {
  static HomeController get instance =>
      Get.find<HomeController>(); // ✅ إضافة هذا السطر

  final isLoading = true.obs;
  final userName = 'Loading...'.obs;
  final userEmail = 'Loading...'.obs; // ✅ تأكد أن userEmail موجود
  final familyCode = 'Generating...'.obs;
  final childrenList = <ChildModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchAllData();
  }

  Future<void> fetchAllData() async {
    final sharedPreferances = await SharedPreferences.getInstance();
    AppConstants.AUTH_TOKEN = Aes256.decrypt(
      encrypted: sharedPreferances.getString("token").toString(),
      passphrase: AppConstants.HASHER_KEY,
    ).toString();

    isLoading.value = true;

    await Future.wait([_fetchUserData(), _fetchChildrenList()]);

    isLoading.value = false;
  }

  Future<void> onRefresh() async {
    await fetchAllData();
  }

  Future<void> _fetchUserData() async {
    const String uri = '/user/parent/get_current';

    final dioClient = DioClient(hasToken: true);
    try {
      final response = await dioClient.get(uri: uri);

      if (response.statusCode == 200 && response.data != null) {
        final user = UserModel.fromJson(response.data);
        userName.value = user.name ?? 'Guest User';
        userEmail.value =
            "${user.email!.split("@")[0][0]}${"*" * (user.email!.split("@")[0].length - 1)}@${user.email!.split("@")[1]}";
        familyCode.value = user.familyCode ?? 'N/A';
      }
    } catch (e) {
      userName.value = 'Parent';
      userEmail.value = 'parent@example.com'; // ✅ القيمة الافتراضية
      familyCode.value = '123456';
      log('Error fetching user data: $e');
    }
  }

  Future<void> _fetchChildrenList() async {
    const String uri = '/user/parent/getChildren';
    final dioClient = DioClient(hasToken: true);
    try {
      final response = await dioClient.get(uri: uri);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic>? childrenJson = response.data['children'];

        if (childrenJson != null) {
          childrenList.clear();

          final List<ChildModel> children = childrenJson
              .map((childMap) => ChildModel.fromJson(childMap))
              .toList();

          childrenList.addAll(children);
        }
      }
    } catch (e) {
      log('Error fetching children list: $e');
    }
  }

  final selectedTabIndex = 1.obs;
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
