import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/security_settings_controller.dart';
import '../../../app/colors.dart';
import '../../../app/routes.dart';

class SecuritySettingsView extends StatelessWidget {
  const SecuritySettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecuritySettingsController controller = Get.put(SecuritySettingsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.inkDark),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Security Settings',
          style: TextStyle(
            color: AppColors.inkDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.adminName.value.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryViolet));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            children: [
              // Profile Avatar Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x338385A1), width: 1),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.background,
                      child: Icon(Icons.person_outline, color: AppColors.inkDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.adminName.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.inkDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Super Administrator',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.neutralGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings Options Title
              const Text(
                'Password & Security',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutralGrey,
                ),
              ),
              const SizedBox(height: 12),

              // Change Password Option
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your current password',
                onTap: () => Get.toNamed(AppRoutes.changePassword),
              ),
              const SizedBox(height: 12),

              // Two-Factor Auth Option
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x338385A1), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                      ),
                      child: const Icon(Icons.security, size: 20, color: AppColors.inkDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Two-Factor Authentication',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.isMfaEnabled.value ? 'MFA is currently enabled' : 'Protect your account with 2FA',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.neutralGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: controller.isMfaEnabled.value,
                      activeColor: AppColors.primaryViolet,
                      onChanged: (val) {
                        if (controller.isMfaEnabled.value && !val) {
                          // Show confirmation dialog before disabling
                          Get.defaultDialog(
                            title: 'Disable 2FA?',
                            middleText: 'Are you sure you want to disable Two-Factor Authentication? Your account will be less secure.',
                            textConfirm: 'Disable',
                            textCancel: 'Cancel',
                            confirmTextColor: AppColors.surfaceCard,
                            buttonColor: AppColors.accentRedDark,
                            onConfirm: () {
                              Get.back(); // close dialog
                              controller.handleMfaToggle(val);
                            },
                          );
                        } else {
                          controller.handleMfaToggle(val);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // PIN Code Setup Option
              _buildSettingItem(
                icon: Icons.dialpad,
                title: 'Quick Access PIN',
                subtitle: 'Set a 4-digit PIN for faster login',
                onTap: () {
                  Get.toNamed(AppRoutes.pinSetup);
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x338385A1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
              ),
              child: Icon(icon, size: 20, color: AppColors.inkDark),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.neutralGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.neutralGrey),
          ],
        ),
      ),
    );
  }
}
