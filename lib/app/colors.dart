import 'package:flutter/material.dart';

/// Centralized color palette for the application matching the UI design system.
abstract class AppColors {
  // Brand & Primary Accents
  static const Color primary = Color(0xFFE2725B); // Coral / Terracotta accent
  static const Color primaryLight = Color(0xFFFDEEE9);
  static const Color primaryDark = Color(0xFFC85A45);

  // Background & Surface
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color border = Color(0xFFF1F5F9);
  static const Color borderMedium = Color(0xFFE2E8F0);

  // Status & Indicators
  static const Color onlineBadge = Color(0xFF22C55E);
  static const Color notificationBadge = Color(0xFFFF5252);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Navigation Bar Specific Colors
  static const Color navActive = Color(0xFFE2725B);
  static const Color navInactive = Color(0xFF94A3B8);
  static const Color navBackground = Colors.white;

  // Avatar Colors
  static const Color avatarPlaceholder = Color(0xFFE2E8F0);
  static const Color avatarText = Color(0xFF334155);

  // Shadow Colors
  static Color shadow = Colors.black.withValues(alpha: 0.04);
}
