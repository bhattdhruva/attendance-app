import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/resetpassword_controller.dart';
import '../../app/colors.dart';
import '../../core/validations/app_validators.dart';
import '../../widgets/textfield.dart';
import '../../widgets/button.dart';
import '../../widgets/hrms_auth_scaffold.dart';
import '../../app/routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String token;

  const ResetPasswordScreen({
    Key? key,
    required this.email,
    required this.token,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController _controller = Get.put(ResetPasswordController());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    await _controller.resetPassword(
      widget.email, 
      widget.token, 
      _passwordController.text,
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HrmsAuthScaffold(
      title: 'Reset Your Password',
      subtitle: 'Enter your new password below.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // New Password Label
            const Text(
              'New Password',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 8),

            // New Password Field
            CustomTextField(
              controller: _passwordController,
              obscureText: _obscurePass,
              hintText: 'Enter new password',
              validator: AppValidators.validatePassword,
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.neutralGrey),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.neutralGrey,
                ),
                onPressed: () {
                  setState(() => _obscurePass = !_obscurePass);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Password Label
            const Text(
              'Confirm Password',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 8),

            // Confirm Password Field
            CustomTextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              hintText: 'Confirm new password',
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.neutralGrey),
              validator: (val) {
                if (val != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.neutralGrey,
                ),
                onPressed: () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                },
              ),
            ),
            const SizedBox(height: 32),

            // Reset Button
            Obx(() => CustomButton(
              text: 'Reset Password',
              isLoading: _controller.isLoading.value,
              onPressed: _submit,
            )),
            const SizedBox(height: 24),

            // Password Rule text
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline, color: AppColors.accentTealDark, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your password must be at least 8 characters and include a number, uppercase and lowercase letter.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.neutralGrey,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Back to Login Link
            Center(
              child: TextButton.icon(
                onPressed: () => Get.offAllNamed(AppRoutes.login),
                icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.inkDark),
                label: const Text(
                  'Back to Login',
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
