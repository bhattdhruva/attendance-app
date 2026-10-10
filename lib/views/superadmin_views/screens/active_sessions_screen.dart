import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/colors.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/appbar.dart';
import '../../../../app/routes.dart';
import '../controllers/active_sessions_controller.dart';

class ActiveSessionsScreen extends StatelessWidget {
  const ActiveSessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ActiveSessionsController controller = Get.put(ActiveSessionsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Active Sessions',
        subtitle: 'Manage your currently logged in devices',
        onNotificationTap: () => Get.toNamed(AppRoutes.notifications),
        onSettingsTap: () => Get.toNamed(AppRoutes.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.inkDark, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryViolet));
        }

        if (controller.sessions.isEmpty) {
          return const Center(
            child: Text(
              'No active sessions found',
              style: TextStyle(color: AppColors.neutralGrey, fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              ...controller.sessions.map((session) {
                final isCurrent = session['_id'] == controller.currentSessionId.value;
                final lastActivity = DateTime.parse(session['lastActivityAt']).toLocal();
                
                String timeStr = isCurrent ? 'Active now' : _formatTimeAgo(lastActivity);
                String deviceStr = session['userAgent'] ?? 'Unknown Device';
                
                if (deviceStr.contains('iPhone')) deviceStr = 'iPhone';
                else if (deviceStr.contains('iPad')) deviceStr = 'iPad';
                else if (deviceStr.contains('Android')) deviceStr = 'Android Device';
                else if (deviceStr.contains('Mac OS X')) deviceStr = 'MacBook / Mac';
                else if (deviceStr.contains('Windows')) deviceStr = 'Windows PC';
                else deviceStr = 'Web Browser';
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildSessionCard(
                    device: deviceStr,
                    location: session['ipAddress'] ?? 'Unknown Location',
                    time: timeStr,
                    isActive: isCurrent,
                    onRevoke: isCurrent ? null : () => controller.revokeSession(session['_id']),
                  ),
                );
              }).toList(),

              if (controller.sessions.length > 1) ...[
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Log out of all other sessions',
                  icon: Icons.logout,
                  onPressed: () {
                    controller.revokeOtherSessions();
                  },
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return 'Last active: ${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return 'Last active: ${diff.inHours} hours ago';
    return 'Last active: ${diff.inDays} days ago';
  }

  Widget _buildSessionCard({
    required String device,
    required String location,
    required String time,
    required bool isActive,
    VoidCallback? onRevoke,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              device.contains('iPhone') ? Icons.phone_iphone : Icons.computer,
              color: AppColors.inkDark,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        device,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.inkDark),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentTealLight.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Current',
                          style: TextStyle(color: AppColors.accentTealDark, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(color: AppColors.neutralGrey, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: isActive ? AppColors.accentTealDark : AppColors.neutralGrey,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (onRevoke != null)
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.accentRedDark, size: 20),
              onPressed: onRevoke,
              tooltip: 'Revoke Session',
            ),
        ],
      ),
    );
  }
}
