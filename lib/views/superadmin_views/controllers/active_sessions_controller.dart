import 'package:get/get.dart';
import '../repository/profile_repository.dart';

class ActiveSessionsController extends GetxController {
  final ProfileRepository _repository = ProfileRepository();
  var sessions = [].obs;
  var currentSessionId = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    isLoading.value = true;
    try {
      final res = await _repository.getSessions();
      if (res.statusCode == 200 && res.data['success']) {
        sessions.value = res.data['data'];
        currentSessionId.value = res.data['currentSessionId'];
      }
    } catch(e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> revokeOtherSessions() async {
    try {
      final res = await _repository.revokeOtherSessions();
      if (res.statusCode == 200 && res.data['success']) {
        fetchSessions();
        Get.snackbar('Success', 'Other sessions revoked');
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> revokeSession(String id) async {
    try {
      final res = await _repository.revokeSession(id);
      if (res.statusCode == 200 && res.data['success']) {
        fetchSessions();
        Get.snackbar('Success', 'Session revoked');
      }
    } catch(e) {
      print(e);
    }
  }
}
