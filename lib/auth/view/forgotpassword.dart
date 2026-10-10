import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgotpassword_controller.dart';
import '../../app/colors.dart';
import '../../core/validations/app_validators.dart';
import '../../widgets/textfield.dart';
import '../../widgets/button.dart';
import '../../widgets/hrms_auth_scaffold.dart';
import '../../app/routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController _controller = Get.put(ForgotPasswordController());
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final success = await _controller.sendResetLink(_emailController.text.trim());
    if (success) {
      // Optional: Navigate to a "Check your email" success screen, or back to login
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HrmsAuthScaffold(
      title: 'Forgot Password?',
      subtitle: "Enter your registered email address and we'll send you a link to reset your password.",
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Admin Email Label
            const Text(
              'Admin Email',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 8),

            // CustomTextField
            CustomTextField(
              controller: _emailController,
              validator: AppValidators.validateEmail,
              hintText: 'admin@yourcompany.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.neutralGrey),
            ),
            const SizedBox(height: 24),

            // Send Reset Link Button
            Obx(() => CustomButton(
              text: 'Send Reset Link',
              isLoading: _controller.isLoading.value,
              onPressed: _submit,
            )),
            const SizedBox(height: 24),

            // Return to Login
            Center(
              child: TextButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.inkDark),
                label: const Text(
                  'Return to Login',
                  style: TextStyle(
                    color: AppColors.inkDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
