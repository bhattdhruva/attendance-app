import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/api_endpoints.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();

  Future<Response> getProfile() async {
    return await _apiService.client.get(ApiEndpoints.profile);
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await _apiService.client.put(ApiEndpoints.profile, data: data);
  }

  Future<Response> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });
    return await _apiService.client.post('${ApiEndpoints.profile}/avatar', data: formData);
  }



  Future<Response> getSessions() async {
    return await _apiService.client.get('${ApiEndpoints.profile}/sessions');
  }

  Future<Response> revokeOtherSessions() async {
    return await _apiService.client.delete('${ApiEndpoints.profile}/sessions/others');
  }

  Future<Response> revokeSession(String id) async {
    return await _apiService.client.delete('${ApiEndpoints.profile}/sessions/$id');
  }

  Future<Response> getLoginHistory() async {
    return await _apiService.client.get('${ApiEndpoints.profile}/login-history');
  }

  Future<Response> getNotifications() async {
    return await _apiService.client.get('${ApiEndpoints.profile}/notifications');
  }

  Future<Response> markNotificationRead(String id) async {
    return await _apiService.client.put('${ApiEndpoints.profile}/notifications/$id/read');
  }

  Future<Response> markAllNotificationsRead() async {
    return await _apiService.client.put('${ApiEndpoints.profile}/notifications/read-all');
  }
}
