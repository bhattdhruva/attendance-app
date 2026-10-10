import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';
import '../../core/utils/api_endpoints.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<Response> login(String email, String password) async {
    return await _apiService.client.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> forgotPassword(String email) async {
    return await _apiService.client.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.forgotPassword}',
      data: {'email': email},
    );
  }

  Future<Response> resetPassword(String email, String token, String newPassword) async {
    return await _apiService.client.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.resetPassword}',
      data: {
        'email': email,
        'token': token,
        'newPassword': newPassword,
      },
    );
  }

  Future<Response> setupMfa() async {
    return await _apiService.client.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.mfaSetup}',
    );
  }

  Future<Response> enableMfa(String code) async {
    return await _apiService.client.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.mfaEnable}',
      data: {'code': code},
    );
  }

  Future<Response> changePassword(String currentPassword, String newPassword) async {
    return await _apiService.client.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.changePassword}',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<Response> verifyMfa(String code) async {
    return await _apiService.client.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.mfaVerify}',
      data: {'code': code},
    );
  }

  Future<Response> disableMfa() async {
    return await _apiService.client.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.mfaDisable}',
    );
  }

  Future<Response> getMe() async {
    return await _apiService.client.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.getMe}',
    );
  }
}
