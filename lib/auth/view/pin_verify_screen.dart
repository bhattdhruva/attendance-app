import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pin_controller.dart';
import '../../app/colors.dart';

class PinVerifyScreen extends StatelessWidget {
  const PinVerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PinController controller = Get.put(PinController());
    
    // Clear any previous state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.enteredPin.value = '';
      controller.hasError.value = false;
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            
            // Profile Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0x338385A1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.background,
                    child: Icon(Icons.person_outline, size: 16, color: AppColors.inkDark),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Super Admin',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      // Sign out or switch user
                      Get.offAllNamed('/login');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0x338385A1),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Change', style: TextStyle(color: AppColors.inkDark, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // PIN Dots
            const Text(
              'Enter your PIN code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < controller.enteredPin.value.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled 
                        ? AppColors.primaryViolet 
                        : (controller.hasError.value ? AppColors.accentRedDark.withOpacity(0.3) : const Color(0x338385A1)),
                  ),
                );
              }),
            )),
            
            const Spacer(),

            // Numpad
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  _buildRow(['1', '2', '3'], controller),
                  _buildRow(['4', '5', '6'], controller),
                  _buildRow(['7', '8', '9'], controller),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNumpadButton(
                        '*', 
                        isSpecial: true,
                        onTap: () {}, // Not typically used but in mockup
                      ),
                      _buildNumpadButton('0', onTap: () {
                        controller.addDigit('0');
                        if (controller.enteredPin.value.length == 4) {
                          controller.submitVerifyPin();
                        }
                      }),
                      _buildNumpadButton(
                        '#',
                        isSpecial: true,
                        icon: Icons.backspace_outlined,
                        onTap: () => controller.removeDigit(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> numbers, PinController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: numbers.map((num) => _buildNumpadButton(
          num, 
          onTap: () {
            controller.addDigit(num);
            if (controller.enteredPin.value.length == 4) {
              controller.submitVerifyPin();
            }
          }
        )).toList(),
      ),
    );
  }

  Widget _buildNumpadButton(String text, {required VoidCallback onTap, bool isSpecial = false, IconData? icon}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, size: 28, color: AppColors.inkDark)
            : Text(
                text,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: isSpecial ? FontWeight.normal : FontWeight.w500,
                  color: AppColors.inkDark,
                ),
              ),
      ),
    );
  }
}
