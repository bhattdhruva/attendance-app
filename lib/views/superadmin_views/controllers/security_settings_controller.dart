import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../auth/repositories/auth_repository.dart';
import '../../../app/routes.dart';

class SecuritySettingsController extends GetxController {
  final AuthRepository _repository = AuthRepository();
  
  var isLoading = false.obs;
  var isMfaEnabled = false.obs;
  var adminName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await _repository.getMe();
      if (response.statusCode == 200 && response.data['success']) {
        final profile = response.data['data'];
        adminName.value = profile['fullName'] ?? 'Super Admin';
        isMfaEnabled.value = profile['mfaEnabled'] ?? false;
      }
    } catch (e) {
      if (e is DioException) {
        Get.snackbar('Error', 'Failed to fetch profile settings');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> disableMfa() async {
    try {
      isLoading.value = true;
      final response = await _repository.disableMfa();
      if (response.statusCode == 200 && response.data['success']) {
        isMfaEnabled.value = false;
        Get.snackbar(
          'Success', 
          'Two-Factor Authentication disabled.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (e is DioException) {
        Get.snackbar('Error', e.response?.data['error'] ?? 'Failed to disable MFA');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void handleMfaToggle(bool val) {
    if (val) {
      // Navigate to Setup MFA
      Get.toNamed(AppRoutes.mfaSetup)?.then((_) => fetchProfile());
    } else {
      // Disable MFA
      disableMfa();
    }
  }
}
