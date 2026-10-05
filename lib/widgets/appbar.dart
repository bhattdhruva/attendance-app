import 'package:flutter/material.dart';
import '../app/colors.dart';

/// Custom App Bar inspired by modern clean health & lifestyle dashboard designs.
/// Features user avatar with online badge, greeting with highlight text,
/// emoji badge, and rounded action buttons (notifications, settings, etc.).
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final String? userName;
  final String? avatarUrl;
  final String? avatarInitials;
  final VoidCallback? onAvatarTap;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showNotificationBadge;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;
  final Color backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry padding;

  const CustomAppBar({
    super.key,
    this.title = 'Welcome back',
    this.subtitle,
    this.userName,
    this.avatarUrl,
    this.avatarInitials,
    this.onAvatarTap,
    this.actions,
    this.leading,
    this.showNotificationBadge = true,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onSettingsTap,
    this.backgroundColor = Colors.transparent,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  });

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        color: backgroundColor,
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading or Profile Avatar
            if (leading != null)
              leading!
            else
              _buildAvatar(context),

            const SizedBox(width: 14),

            // Greeting & Name
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          userName ?? 'User',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '👋',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Trailing Action Buttons
            if (actions != null)
              ...actions!
            else ...[
              _buildIconButton(
                icon: Icons.notifications_none_rounded,
                hasBadge: showNotificationBadge,
                badgeCount: notificationCount,
                onTap: onNotificationTap,
              ),
              const SizedBox(width: 10),
              _buildIconButton(
                icon: Icons.settings_outlined,
                onTap: onSettingsTap,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTap: onAvatarTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.avatarPlaceholder,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.surface,
                width: 2,
              ),
              image: avatarUrl != null
                  ? DecorationImage(
                      image: NetworkImage(avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: avatarUrl == null
                ? Center(
                    child: Text(
                      avatarInitials ?? 'U',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.avatarText,
                      ),
                    ),
                  )
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: AppColors.onlineBadge,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    bool hasBadge = false,
    int badgeCount = 0,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: AppColors.textSecondary,
              ),
              if (hasBadge)
                Positioned(
                  top: 9,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.notificationBadge,
                      shape: BoxShape.circle,
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
