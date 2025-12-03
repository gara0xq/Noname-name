import 'package:get/get.dart';
import '../../../data/services/dio_client.dart';
import '../model/user_model.dart';
import '../model/child_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find<HomeController>(); // ✅ إضافة هذا السطر
  
  final isLoading = true.obs;
  final userName = 'Loading...'.obs;
  final userEmail = 'Loading...'.obs; // ✅ تأكد أن userEmail موجود
  final familyCode = 'Generating...'.obs;
  final childrenList = <ChildModel>[].obs;

  final DioClient _dioClient = DioClient();

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  void fetchAllData() async {
    isLoading.value = true;

    await Future.wait([_fetchUserData(), _fetchChildrenList()]);

    isLoading.value = false;
  }

  Future<void> _fetchUserData() async {
    const String uri = '/user/parent/get_current';

    try {
      final response = await _dioClient.get(uri);

      if (response.statusCode == 200 && response.data != null) {
        final user = UserModel.fromJson(response.data);
        userName.value = user.name ?? 'Guest User';
        userEmail.value = user.email ?? 'parent@example.com'; // ✅ تأكد من تعبئة userEmail
        familyCode.value = user.familyCode ?? 'N/A';
      }
    } catch (e) {
      userName.value = 'Parent';
      userEmail.value = 'parent@example.com'; // ✅ القيمة الافتراضية
      familyCode.value = '123456';
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchChildrenList() async {
    const String uri = '/user/child/getChildren';

    try {
      final response = await _dioClient.get(uri);

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
      print('Error fetching children list: $e');
    }
  }

  final selectedTabIndex = 1.obs;
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
