import 'dart:developer';
import 'package:get/get.dart';
import '../../../core/services/dio_client.dart';
import '../model/user_model.dart';
import '../model/child_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find<HomeController>();

  final isLoading = true.obs;
  final userName = 'Loading...'.obs;
  final userEmail = 'Loading...'.obs;
  final familyCode = 'Generating...'.obs;
  final childrenList = <ChildModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchAllData();
  }

  Future<void> fetchAllData() async {
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
      userEmail.value = 'parent@example.com';
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
