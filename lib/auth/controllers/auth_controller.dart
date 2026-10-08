import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

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
      final response = await _apiService.client.post('/auth/login', data: {
        'email': email,
        'password': password,
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
      final response = await _apiService.client.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role, // 'user' or 'manager' or 'superadmin'
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
