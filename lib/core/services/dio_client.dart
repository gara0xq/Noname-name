import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  final Dio _dio = Dio();
  bool hasToken;
  DioClient({this.hasToken = false}) {
    _dio.options = BaseOptions(
      validateStatus: (status) => true,
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Content-Type': 'application/json',
        if (hasToken)
          AppConstants.AUTH_HEADER_KEY:
              AppConstants.BEARER_PREFIX + AppConstants.AUTH_TOKEN,
      },
    );
  }

  Future<Response> get({required String uri}) async {
    try {
      final Response response = await _dio.get(uri);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post({required String uri, required dynamic data}) async {
    try {
      final Response response = await _dio.post(uri, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
