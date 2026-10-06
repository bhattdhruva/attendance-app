import 'package:flutter/material.dart';

/// Centralized color palette for the application matching the UI design system.
abstract class AppColors {
  // Brand & Primary Accents
  static const Color primary = Color(0xFFE2725B); // Coral / Terracotta accent
  static const Color primaryLight = Color(0xFFFDEEE9);
  static const Color primaryDark = Color(0xFFC85A45);

  // Super Admin Theme Accents
  static const Color superAdminPrimary = Color(0xFF3B82F6); // Vibrant Blue
  static const Color superAdminDark = Color(0xFF1E293B); // Dark Slate
  static const Color superAdminPillBg = Color(0xFFF1F5F9);

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Status & Indicators
  static const Color onlineBadge = Color(0xFF22C55E);
  static const Color notificationBadge = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFB45309);
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFF991B1B);
  static const Color info = Color(0xFF3B82F6);

  // Card pastel backgrounds
  static const Color cardBlueBg = Color(0xFFEFF6FF);
  static const Color cardIndigoBg = Color(0xFFEEF2FF);
  static const Color cardAmberBg = Color(0xFFFFFBEB);
  static const Color cardPurpleBg = Color(0xFFFAF5FF);
  static const Color cardOrangeBg = Color(0xFFFFF7ED);
  static const Color cardRoseBg = Color(0xFFFFF1F2);

  // Navigation Bar Specific Colors
  static const Color navActive = Color(0xFF3B82F6);
  static const Color navInactive = Color(0xFF94A3B8);
  static const Color navBackground = Colors.white;

  // Avatar Colors
  static const Color avatarPlaceholder = Color(0xFFE2E8F0);
  static const Color avatarText = Color(0xFF334155);

  // Super Admin Theme & Metric Accents
  static const Color superAdminDeepPurple = Color(0xFF4C1D95);
  static const Color superAdminNavy = Color(0xFF1E3A8A);
  static const Color badgeSuccessBg = Color(0xFFD1FAE5);
  static const Color badgeSuccessText = Color(0xFF059669);

  // Revenue Sales Channel Chart Colors
  static const Color chartAmber = Color(0xFFF59E0B);
  static const Color chartPurple = Color(0xFF7C3AED);
  static const Color chartMint = Color(0xFF10B981);
  static const Color chartTeal = Color(0xFF0284C7);
  static const Color chartSkyBlue = Color(0xFF38BDF8);
  static const Color chartOrange = Color(0xFFF97316);
  static const Color chartIndigo = Color(0xFF6366F1);

  // Shadow Colors
  static Color shadow = Colors.black.withValues(alpha: 0.04);
}

