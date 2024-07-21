import 'package:bloc/bloc.dart';
import 'package:blocapp/data/repositry/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

enum PasswordVisibility { visible, hidden }

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
   PasswordVisibility _passwordVisibility = PasswordVisibility.hidden;
  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.register(name, email, password);
      final token = response.data['data']['token']; // Accessing nested token

      if (token == null) {
        emit(AuthFailure('Token is null'));
        return;
      }

      // Save token using SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      emit(AuthSuccess(token));
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.login(email, password);
      final token = response.data['data']['token']; // Accessing nested token

      if (token == null) {
        emit(AuthFailure('Token is null'));
        return;
      }

      // Save token using SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      emit(AuthSuccess(token));
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    emit(AuthInitial());
  }

  void togglePasswordVisibility() {
    _passwordVisibility = _passwordVisibility == PasswordVisibility.hidden
        ? PasswordVisibility.visible
        : PasswordVisibility.hidden;
        emit(AuthPasswordVisibilityChanged(_passwordVisibility));
  }
}
