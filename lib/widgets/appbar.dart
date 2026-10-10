import 'package:flutter/material.dart';
import '../app/colors.dart';

/// Custom App Bar inspired by modern clean SaaS & lifestyle dashboard designs.
/// Supports both:
/// 1. Greeting mode with user avatar & wave emoji (e.g., Welcome back / Tiago 👋).
/// 2. Header title + subtitle mode (e.g. "Super Admin Dashboard" / "⚡ PulsarHR Root Console")
/// with actions like notifications, profile avatar, or custom icons.
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
  final bool showWaveEmoji;

  const CustomAppBar({
    super.key,
    this.title = 'Super Admin Dashboard',
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
    this.showWaveEmoji = false,
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
            // Leading widget if specified
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],

            // Title & Subtitle or Greeting & User Name
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
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutralGrey,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ] else if (userName != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            userName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutralGrey,
                            ),
                          ),
                        ),
                        if (showWaveEmoji) ...[
                          const SizedBox(width: 4),
                          const Text('👋', style: TextStyle(fontSize: 16)),
                        ],
                      ],
                    ),
                  ],
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
              if (onAvatarTap != null || avatarUrl != null || avatarInitials != null)
                _buildAvatar(context)
              else
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x0F000000),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.surfaceCard,
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
                      avatarInitials ?? 'A',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.inkDark,
                      ),
                    ),
                  )
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.accentTealDark,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surfaceCard,
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
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0x338385A1),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0F000000),
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
                color: AppColors.neutralGrey,
              ),
              if (hasBadge)
                Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.accentRedDark,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                    child: badgeCount > 0
                        ? Text(
                            '$badgeCount',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
