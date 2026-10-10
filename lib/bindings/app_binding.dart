import 'package:get/get.dart';
import '../auth/controllers/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Inject controllers globally so they are available immediately
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
