import 'package:blocapp/data/web_services/auth_web_service.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final AuthWebService authWebService;

  AuthRepository(this.authWebService);
  Future<Response> register(String name, String email, String password) async {
    return await authWebService.register(name, email, password);
  }

  Future<Response> login(String email, String password) async {
    return await authWebService.login(email, password);
  }
}
