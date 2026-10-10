import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordController extends GetxController {
  final AuthRepository _repository = AuthRepository();
  var isLoading = false.obs;

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      isLoading.value = true;
      final response = await _repository.changePassword(currentPassword, newPassword);

      if (response.statusCode == 200 && response.data['success']) {
        Get.snackbar(
          'Success', 
          'Password changed successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back(); // Return to previous screen (e.g. Settings)
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        Get.snackbar(
          'Error', 
          e.response?.data['error'] ?? 'An error occurred while changing password.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
