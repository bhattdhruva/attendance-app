import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/api_endpoints.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  
  var isLoading = false.obs;
  var isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      isAuthenticated.value = true;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await _apiService.client.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['success']) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        if (response.data['mfaSetupRequired'] == true) {
          Get.offAllNamed('/mfa-setup');
        } else if (response.data['mfaRequired'] == true) {
          Get.toNamed('/mfa-verify');
        } else {
          isAuthenticated.value = true;
          // Notice: since we call login from login_screen and await it, 
          // we can just return true here and let the UI do `Get.offAllNamed`.
          return true;
        }
        return false; // Handled by GetX routing for MFA screens
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        Get.snackbar('Login Failed', e.response?.data['error'] ?? 'An error occurred during login');
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(String name, String email, String password, String role) async {
    try {
      isLoading.value = true;
      final response = await _apiService.client.post(ApiEndpoints.register, data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role, // 'superadmin' or 'organization' or 'manager' or 'employee'
      });

      if (response.statusCode == 200 && response.data['success']) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        isAuthenticated.value = true;
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        Get.snackbar('Registration Failed', e.response?.data['error'] ?? 'An error occurred during registration');
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    isAuthenticated.value = false;
    // Get.offAllNamed('/login'); // Navigate back to login screen
  }
}
