import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mfa_controller.dart';
import '../../app/colors.dart';
import '../../widgets/textfield.dart';
import '../../widgets/textfield.dart';
import '../../widgets/appbar.dart';

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
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Verify Login',
        subtitle: 'Enter your 6-digit authenticator code',
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
    );
  }
}
