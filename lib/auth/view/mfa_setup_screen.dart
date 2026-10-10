import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/mfa_controller.dart';
import '../../app/colors.dart';
import '../../widgets/textfield.dart';
import '../../widgets/textfield.dart';
import '../../widgets/appbar.dart';
import '../../app/routes.dart';

class MfaSetupScreen extends StatefulWidget {
  const MfaSetupScreen({Key? key}) : super(key: key);

  @override
  State<MfaSetupScreen> createState() => _MfaSetupScreenState();
}

class _MfaSetupScreenState extends State<MfaSetupScreen> {
  final MfaController _controller = Get.put(MfaController());
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await _controller.enableMfa(_codeController.text.trim());
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Two-Factor Auth',
        subtitle: 'Setup Authenticator App',
        onNotificationTap: () => Get.toNamed(AppRoutes.notifications),
        onSettingsTap: () => Get.toNamed(AppRoutes.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.inkDark, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              if (_controller.isSettingUp.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: AppColors.primaryViolet),
                  ),
                );
              }

              final qrCodeStr = _controller.qrCodeDataUrl.value;
              ImageProvider? qrImage;
              if (qrCodeStr.startsWith('data:image/png;base64,')) {
                final base64Str = qrCodeStr.split(',').last;
                qrImage = MemoryImage(base64Decode(base64Str));
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR Code Box
                  Container(
                    width: 130,
                    height: 130,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x338385A1), width: 1),
                    ),
                    child: qrImage != null 
                        ? Image(image: qrImage) 
                        : const Icon(Icons.qr_code, size: 60, color: AppColors.neutralGrey),
                  ),
                  const SizedBox(width: 16),
                  
                  // Manual Key Box
                  Expanded(
                    child: Container(
                      height: 130,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background, // Matches mockup light blue bg
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x338385A1), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Manual Setup Key',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceCard,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _controller.secretKey.value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: _controller.secretKey.value));
                                    Get.snackbar('Copied', 'Setup key copied to clipboard!', snackPosition: SnackPosition.BOTTOM);
                                  },
                                  child: const Icon(Icons.copy, size: 16, color: AppColors.primaryViolet),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 40),

            // Enter Code Label
            const Text(
              'Enter the 6-digit code from your authenticator app',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 8),

            // Code Field
            CustomTextField(
              controller: _codeController,
              hintText: '123 456',
              textAlign: TextAlign.left,
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Code is required';
                if (val.replaceAll(' ', '').length != 6) return 'Must be 6 digits';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Verify Button
            Obx(() => ElevatedButton(
              onPressed: _controller.isLoading.value ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryViolet, // Blue button matching mockup
                foregroundColor: AppColors.surfaceCard,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _controller.isLoading.value
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: AppColors.surfaceCard, strokeWidth: 2),
                    )
                  : const Text(
                      'Verify & Enable',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )),
            const SizedBox(height: 24),

            // Help link
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Implement help dialog or screen
                },
                child: const Text(
                  "Don't have access to your authenticator app?",
                  style: TextStyle(
                    color: AppColors.primaryViolet,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
