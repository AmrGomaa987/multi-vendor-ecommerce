import 'package:blocapp/constants/api_constants.dart';
import 'package:dio/dio.dart';

class AuthWebService {
  late Dio _dio;
  AuthWebService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ));
  }

  Future<Response> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      print('Register response: ${response.data}'); // Debug print
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiConstants.loginEndpoint, data: {
        'email': email,
        'password': password,
      });
      print('Login response: ${response.data}'); // Debug print
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
