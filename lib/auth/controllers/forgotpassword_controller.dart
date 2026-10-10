import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _repository = AuthRepository();
  var isLoading = false.obs;

  Future<bool> sendResetLink(String email) async {
    try {
      isLoading.value = true;
      final response = await _repository.forgotPassword(email);

      if (response.statusCode == 200 && response.data['success']) {
        Get.snackbar(
          'Success', 
          'Reset link generated! Redirecting to Reset Password screen...',
          snackPosition: SnackPosition.BOTTOM,
        );

        // For testing purposes, the backend returns the token directly
        final token = response.data['token'];
        final responseEmail = response.data['email'];

        if (token != null && responseEmail != null) {
          // Navigate to reset password with explicit parameters
          Get.toNamed(
            '/reset-password',
            parameters: {'email': responseEmail, 'token': token},
          );
        }

        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        Get.snackbar(
          'Error', 
          e.response?.data['error'] ?? 'An error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
