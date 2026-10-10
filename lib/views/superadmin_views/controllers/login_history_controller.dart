import 'package:get/get.dart';
import '../repository/profile_repository.dart';

class LoginHistoryController extends GetxController {
  final ProfileRepository _repository = ProfileRepository();
  var logs = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoginHistory();
  }

  Future<void> fetchLoginHistory() async {
    isLoading.value = true;
    try {
      final res = await _repository.getLoginHistory();
      if (res.statusCode == 200 && res.data['success']) {
        logs.value = res.data['data'];
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
