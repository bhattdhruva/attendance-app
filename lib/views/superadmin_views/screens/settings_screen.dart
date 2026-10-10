import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/colors.dart';
import '../../../../widgets/appbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'System Settings',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.inkDark, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Platform Configuration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your platform\'s global settings and default configurations.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.neutralGrey,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSettingsCard(
              icon: Icons.tune,
              iconColor: AppColors.accentBlueLight,
              title: 'General Settings',
              description: 'Platform name, logo, favicon, support email, default language, timezone and date format.',
              onTap: () => _showComingSoon('General Settings'),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsCard(
              icon: Icons.domain,
              iconColor: AppColors.primaryViolet,
              title: 'Organization Defaults',
              description: 'Default settings for new organizations, available modules and configuration templates.',
              onTap: () => _showComingSoon('Organization Defaults'),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsCard(
              icon: Icons.mark_email_unread_outlined,
              iconColor: AppColors.accentTealDark,
              title: 'Email & Notifications',
              description: 'Email provider, sender details, email templates and platform announcements.',
              onTap: () => _showComingSoon('Email & Notifications'),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsCard(
              icon: Icons.extension_outlined,
              iconColor: AppColors.accentIndigoLight,
              title: 'Modules & Integrations',
              description: 'Attendance, Leave, Payroll module availability and third-party service connections.',
              onTap: () => _showComingSoon('Modules & Integrations'),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsCard(
              icon: Icons.admin_panel_settings_outlined,
              iconColor: AppColors.accentRedLight,
              title: 'Audit Logs & System',
              description: 'Platform admin activities, system health, backup status and maintenance mode.',
              onTap: () => _showComingSoon('Audit Logs & System'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      'Coming Soon',
      '$feature will be available in an upcoming update.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surfaceCard,
      colorText: AppColors.inkDark,
      margin: const EdgeInsets.all(16),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.neutralGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.inkDark),
            ),
          ],
        ),
      ),
    );
  }
}
