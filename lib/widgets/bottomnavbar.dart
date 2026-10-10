import 'package:flutter/material.dart';
import '../app/colors.dart';

/// Item model for [CustomBottomNavBar].
class CustomNavBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const CustomNavBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Custom Bottom Navigation Bar styled to match modern sleek UI
/// with subtle pill highlight, clean line icons, indicator dot, and soft floating elevation.
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomNavBarItem>? items;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final bool isFloating;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items,
    this.activeColor = AppColors.primaryViolet,
    this.inactiveColor = AppColors.neutralGrey,
    this.backgroundColor = AppColors.surfaceCard,
    this.isFloating = false,
  });

  static const List<CustomNavBarItem> defaultItems = [
    CustomNavBarItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    CustomNavBarItem(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Health',
    ),
    CustomNavBarItem(
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'Ask',
    ),
    CustomNavBarItem(
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      label: 'Community',
    ),
    CustomNavBarItem(
      icon: Icons.emoji_events_outlined,
      activeIcon: Icons.emoji_events_rounded,
      label: 'Achieve',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final navItems = items ?? defaultItems;

    Widget navBarContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: isFloating ? BorderRadius.circular(32) : null,
        border: isFloating
            ? Border.all(color: const Color(0x338385A1), width: 1.5)
            : const Border(
                top: BorderSide(
                  color: const Color(0x338385A1),
                  width: 1.2,
                ),
              ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0F000000),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final isSelected = currentIndex == index;
            final item = navItems[index];

            return _buildNavItem(
              index: index,
              item: item,
              isSelected: isSelected,
            );
          }),
        ),
      ),
    );

    if (isFloating) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: navBarContent,
      );
    }

    return navBarContent;
  }

  Widget _buildNavItem({
    required int index,
    required CustomNavBarItem item,
    required bool isSelected,
  }) {
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with subtle animated scale
              AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: color,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 2),
              // Indicator dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 4 : 0,
                height: isSelected ? 4 : 0,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
