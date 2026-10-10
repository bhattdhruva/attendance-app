import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../repositories/auth_repository.dart';
import '../../app/routes.dart';

class ResetPasswordController extends GetxController {
  final AuthRepository _repository = AuthRepository();
  var isLoading = false.obs;

  Future<bool> resetPassword(String email, String token, String newPassword) async {
    try {
      isLoading.value = true;
      final response = await _repository.resetPassword(email, token, newPassword);

      if (response.statusCode == 200 && response.data['success']) {
        Get.snackbar(
          'Success', 
          'Password has been reset successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Automatically route back to login on success
        Get.offAllNamed(AppRoutes.login);
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
