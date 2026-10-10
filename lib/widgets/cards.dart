import 'package:flutter/material.dart';
import '../app/colors.dart';

class CustomActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CustomActionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.inkDark),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: AppColors.neutralGrey),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.inkDark.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String time;
  final String description;
  final String actionText;
  final VoidCallback onActionTap;
  final bool isUnread;
  final bool showDivider;

  const NotificationCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.time,
    required this.description,
    required this.actionText,
    required this.onActionTap,
    this.isUnread = false,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread Dot indicator area
              SizedBox(
                width: 12,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: isUnread
                      ? Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.notifUnreadDot,
                          ),
                        )
                      : null,
                ),
              ),
              // Icon Box
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.inkDark,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.neutralGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.neutralGrey,
                        height: 1.4,
                      ),
                    ),
                    if (actionText.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: onActionTap,
                        child: Text(
                          actionText,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentBlueDark,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: Color(0x1A8385A1), indent: 60),
      ],
    );
  }
}

