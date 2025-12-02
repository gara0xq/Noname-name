import 'package:dio/dio.dart';
import '../constants/app_constants.dart'; 

class DioClient {
  final Dio _dio = Dio();
  
  DioClient() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Content-Type': 'application/json',
        AppConstants.AUTH_HEADER_KEY: AppConstants.BEARER_PREFIX + AppConstants.MOCK_AUTH_TOKEN,
      },
    );
  }

  Future<Response> get(String uri) async {
    try {
      final Response response = await _dio.get(uri);
      return response;
    } catch (e) {
      rethrow; 
    }
  }
  
  Future<Response> post(String uri, dynamic data) async {
    try {
      final Response response = await _dio.post(uri, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}