import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../app/routes.dart';

class PinController extends GetxController {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  var enteredPin = ''.obs;
  var isSettingUp = false.obs;
  var firstPin = ''.obs;
  
  var hasError = false.obs;

  void addDigit(String digit) {
    if (enteredPin.value.length < 4) {
      enteredPin.value += digit;
      hasError.value = false;
    }
  }

  void removeDigit() {
    if (enteredPin.value.isNotEmpty) {
      enteredPin.value = enteredPin.value.substring(0, enteredPin.value.length - 1);
      hasError.value = false;
    }
  }

  // Setup Flow
  Future<void> submitSetupPin() async {
    if (enteredPin.value.length != 4) return;

    if (firstPin.value.isEmpty) {
      // First step done, wait for confirm
      firstPin.value = enteredPin.value;
      enteredPin.value = '';
    } else {
      // Confirming
      if (firstPin.value == enteredPin.value) {
        // Save to secure storage
        await _storage.write(key: 'user_pin', value: enteredPin.value);
        Get.snackbar('Success', 'PIN configured successfully!', snackPosition: SnackPosition.BOTTOM);
        Get.back(); // Go back to settings or dashboard
      } else {
        // Mismatch
        hasError.value = true;
        firstPin.value = '';
        enteredPin.value = '';
        Get.snackbar('Error', 'PINs do not match. Try again.', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  // Verify Flow
  Future<void> submitVerifyPin() async {
    if (enteredPin.value.length != 4) return;

    final storedPin = await _storage.read(key: 'user_pin');
    
    if (storedPin == enteredPin.value) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      hasError.value = true;
      enteredPin.value = '';
      Get.snackbar('Error', 'Incorrect PIN.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Check if PIN exists (to decide routing on app load)
  Future<bool> hasPinSetup() async {
    final pin = await _storage.read(key: 'user_pin');
    return pin != null && pin.isNotEmpty;
  }
}
