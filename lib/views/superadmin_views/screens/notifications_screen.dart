import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/colors.dart';
import '../../../../widgets/cards.dart';
import '../../../../widgets/appbar.dart';
import '../../../../app/routes.dart';
import '../controllers/notifications_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/dashboard_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Obx(() {
          final profileController = Get.put(ProfileController());
          final avatarUrlStr = profileController.avatarUrl.value;
          final String? fullAvatarUrl = avatarUrlStr.isNotEmpty
              ? (avatarUrlStr.startsWith('http') ? avatarUrlStr : 'http://192.168.1.5:5000$avatarUrlStr')
              : null;
          
          return CustomAppBar(
            title: 'Notifications',
            showNotificationIcon: false,
            avatarUrl: fullAvatarUrl,
            avatarInitials: profileController.fullName.value.isNotEmpty ? profileController.fullName.value[0] : 'A',
            onAvatarTap: () {
              if (Get.isRegistered<DashboardController>()) {
                Get.find<DashboardController>().changeTab(4); // Profile tab index
                Get.back();
              } else {
                Get.toNamed(AppRoutes.profile);
              }
            },
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.inkDark, size: 20),
              onPressed: () => Get.back(),
            ),
          );
        }),
      ),
      body: Obx(() {
        final controller = Get.put(NotificationsController());

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications', style: TextStyle(color: AppColors.neutralGrey)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notif = controller.notifications[index];
                
                final isUnread = notif['isUnread'] == true;
                final type = notif['type'] ?? 'INFO';
                
                IconData icon;
                Color iconColor;
                Color bgColor;
                
                if (type == 'SUCCESS') {
                  icon = Icons.check_circle_outline;
                  iconColor = AppColors.notifIconGreen;
                  bgColor = AppColors.notifBgGreen;
                } else if (type == 'WARNING') {
                  icon = Icons.warning_amber_rounded;
                  iconColor = AppColors.notifIconOrange;
                  bgColor = AppColors.notifBgOrange;
                } else if (type == 'ERROR') {
                  icon = Icons.error_outline;
                  iconColor = AppColors.accentRedDark;
                  bgColor = AppColors.accentRedLight.withValues(alpha: 0.1);
                } else {
                  icon = Icons.info_outline;
                  iconColor = AppColors.primaryViolet;
                  bgColor = AppColors.accentIndigoLight.withValues(alpha: 0.1);
                }
                
                return NotificationCard(
                  icon: icon,
                  iconColor: iconColor,
                  bgColor: bgColor,
                  title: notif['title'] ?? 'Notification',
                  time: '', // Could format time ago here
                  description: notif['description'] ?? '',
                  actionText: isUnread ? 'Mark as read' : '',
                  onActionTap: isUnread ? () => controller.markAsRead(notif['_id']) : () {},
                  isUnread: isUnread,
                  showDivider: index < controller.notifications.length - 1,
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
