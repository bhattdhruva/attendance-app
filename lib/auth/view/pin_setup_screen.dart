import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pin_controller.dart';
import '../../app/colors.dart';

class PinSetupScreen extends StatelessWidget {
  const PinSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PinController controller = Get.put(PinController());
    
    // Clear state when opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.enteredPin.value = '';
      controller.firstPin.value = '';
      controller.hasError.value = false;
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.inkDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            
            // Text Header
            Obx(() => Text(
              controller.firstPin.value.isEmpty 
                  ? 'Set a 4-digit PIN' 
                  : 'Confirm your PIN',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.inkDark,
              ),
            )),
            const SizedBox(height: 12),
            const Text(
              'For quick access to your dashboard',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.neutralGrey,
              ),
            ),
            const SizedBox(height: 32),

            // PIN Dots
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
                      _buildNumpadButton('*', isSpecial: true, onTap: () {}),
                      _buildNumpadButton('0', onTap: () {
                        controller.addDigit('0');
                        if (controller.enteredPin.value.length == 4) {
                          controller.submitSetupPin();
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
              controller.submitSetupPin();
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
