import 'package:bloc/bloc.dart';
import 'package:blocapp/data/repositry/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart'; // Import Dio for error handling

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
      emit(AuthFailure(_mapErrorToMessage(error)));
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
      emit(AuthFailure(_mapErrorToMessage(error)));
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

  String _mapErrorToMessage(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        // Server error with response
        final responseBody = error.response!.data;
        return _parseBadRequestError(responseBody);
      } else {
        // Network error
        return 'Network error. Please check your internet connection.';
      }
    } else {
      // Unknown error
      return 'An unexpected error occurred. Please try again.';
    }
  }

  String _parseBadRequestError(dynamic responseBody) {
    if (responseBody is Map<String, dynamic>) {
      // Check for the `status` field
      final message = responseBody['message'];

      // Check for the `data` field which contains specific error details
      final data = responseBody['data'];

      if (data is List<dynamic> && data.isNotEmpty) {
        // Extract detailed error messages
        final errorDetails = data.firstWhere(
            (item) => item is Map<String, dynamic>,
            orElse: () => {});

        final field = errorDetails['field'] ?? '';
        final errorMsg = errorDetails['msg'] ?? 'Unknown error';

        // Return the specific error message
        return '$field $errorMsg';
      }

      // Fallback to a general message if no specific errors are found
      return message ?? 'Invalid input. Please check the provided data.';
    }

    // Default fallback message if response body is not in expected format
    return 'Invalid input. Please check the provided data.';
  }





 
}
