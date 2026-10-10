import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../repositories/auth_repository.dart';
import '../../app/routes.dart';

class MfaController extends GetxController {
  final AuthRepository _repository = AuthRepository();
  
  var isLoading = false.obs;
  var isSettingUp = false.obs;
  
  var secretKey = ''.obs;
  var qrCodeDataUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Automatically fetch MFA setup data when screen opens
    setupMfa();
  }

  Future<void> setupMfa() async {
    try {
      isSettingUp.value = true;
      final response = await _repository.setupMfa();
      
      if (response.statusCode == 200 && response.data['success']) {
        secretKey.value = response.data['data']['secret'];
        qrCodeDataUrl.value = response.data['data']['qrCodeUrl'];
      }
    } catch (e) {
      if (e is DioException) {
        Get.snackbar(
          'Error', 
          e.response?.data['error'] ?? 'Failed to setup MFA.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isSettingUp.value = false;
    }
  }

  Future<bool> enableMfa(String code) async {
    try {
      isLoading.value = true;
      final response = await _repository.enableMfa(code);

      if (response.statusCode == 200 && response.data['success']) {
        Get.snackbar(
          'Success', 
          'Two-Factor Authentication enabled successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppRoutes.dashboard); // Redirect to dashboard after successful MFA
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        Get.snackbar(
          'Error', 
          e.response?.data['error'] ?? 'Invalid authenticator code.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyMfa(String code) async {
    try {
      isLoading.value = true;
      final response = await _repository.verifyMfa(code);

      if (response.statusCode == 200 && response.data['success']) {
        Get.offAllNamed(AppRoutes.dashboard);
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        Get.snackbar(
          'Error', 
          e.response?.data['error'] ?? 'Invalid authenticator code.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
