import 'package:get/get.dart';
import '../repository/profile_repository.dart';

class NotificationsController extends GetxController {
  final ProfileRepository _repository = ProfileRepository();
  var notifications = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final res = await _repository.getNotifications();
      if (res.statusCode == 200 && res.data['success']) {
        notifications.value = res.data['data'];
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final res = await _repository.markNotificationRead(id);
      if (res.statusCode == 200 && res.data['success']) {
        final index = notifications.indexWhere((n) => n['_id'] == id);
        if (index != -1) {
          notifications[index]['isUnread'] = false;
          notifications.refresh();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final res = await _repository.markAllNotificationsRead();
      if (res.statusCode == 200 && res.data['success']) {
        for (var notif in notifications) {
          notif['isUnread'] = false;
        }
        notifications.refresh();
      }
    } catch (e) {
      print(e);
    }
  }
}
