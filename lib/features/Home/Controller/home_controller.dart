import 'package:get/get.dart';
import '../../../data/services/dio_client.dart'; 
import '../model/user_model.dart'; 
import '../model/child_model.dart'; 

class HomeController extends GetxController {

  final isLoading = true.obs; 
  
  final userName = 'Loading...'.obs; 
  
  final childrenList = <ChildModel>[].obs;
  
  final DioClient _dioClient = DioClient();

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  void fetchAllData() async {
    isLoading.value = true;
    
    await Future.wait([
      _fetchUserData(),
      _fetchChildrenList(),
    ]);

    isLoading.value = false;
  }
  
  Future<void> _fetchUserData() async {
    const String uri = '/user/get_User'; 
    
    try {
      final response = await _dioClient.get(uri);
      
      if (response.statusCode == 200 && response.data != null) {
        final user = UserModel.fromJson(response.data);

        userName.value = user.name ?? 'Guest User';
      }
    } catch (e) {

      userName.value = 'Parent'; 
      print('Error fetching user data: $e');
    }
  }


  Future<void> _fetchChildrenList() async {
    const String uri = '/user/get_Children';

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

  final selectedTabIndex = 0.obs;
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}