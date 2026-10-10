import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/changepassword_controller.dart';
import '../../app/colors.dart';
import '../../core/validations/app_validators.dart';
import '../../widgets/textfield.dart';
import '../../widgets/textfield.dart';
import '../../widgets/appbar.dart';
import '../../app/routes.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController _controller = Get.put(ChangePasswordController());
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    await _controller.changePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Change Password',
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
            // Current Password Label
            const Text(
              'Current Password',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 8),

            // Current Password Field
            CustomTextField(
              controller: _currentPasswordController,
              obscureText: _obscureCurrent,
              hintText: 'Enter current password',
              textAlign: TextAlign.left,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Current password is required';
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.neutralGrey,
                ),
                onPressed: () {
                  setState(() => _obscureCurrent = !_obscureCurrent);
                },
              ),
            ),
            const SizedBox(height: 24),

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
              controller: _newPasswordController,
              obscureText: _obscureNew,
              hintText: 'Enter new password',
              textAlign: TextAlign.left,
              validator: AppValidators.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.neutralGrey,
                ),
                onPressed: () {
                  setState(() => _obscureNew = !_obscureNew);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Password Label
            const Text(
              'Confirm New Password',
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
              textAlign: TextAlign.left,
              validator: (val) {
                if (val != _newPasswordController.text) {
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
                      'Update Password',
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
