import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mfa_controller.dart';
import '../../app/colors.dart';
import '../../widgets/textfield.dart';

class MfaVerifyScreen extends StatefulWidget {
  const MfaVerifyScreen({Key? key}) : super(key: key);

  @override
  State<MfaVerifyScreen> createState() => _MfaVerifyScreenState();
}

class _MfaVerifyScreenState extends State<MfaVerifyScreen> {
  final MfaController _controller = Get.put(MfaController());
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await _controller.verifyMfa(_codeController.text.trim());
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceCard,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.inkDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                      ),
                      child: const Icon(
                        Icons.security,
                        size: 40,
                        color: AppColors.primaryViolet,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Verify Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please enter the 6-digit code from your authenticator app to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.neutralGrey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Code Field
                  CustomTextField(
                    controller: _codeController,
                    hintText: '123 456',
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Code is required';
                      if (val.replaceAll(' ', '').length != 6) return 'Must be 6 digits';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Verify Button
                  Obx(() => ElevatedButton(
                    onPressed: _controller.isLoading.value ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryViolet,
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
                            'Verify',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
