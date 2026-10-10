import 'package:flutter/material.dart';

/// Centralized color palette for the application matching the UI design system.
abstract class AppColors {
  // === PRIMARY COLORS ===
  static const Color primaryViolet = Color(0xFF8B59EF);
  static const Color primaryIndigo = Color(0xFF4834D4);
  static const Color inkDark = Color(0xFF0B0B24);
  static const Color neutralGrey = Color(0xFF8385A1);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F6FA);

  // === SECONDARY COLORS (Gradients/Accents) ===
  static const Color accentIndigoLight = Color(0xFF9C8FF5);
  static const Color accentIndigoDark = Color(0xFF4534B0);
  
  static const Color accentAmberLight = Color(0xFFFDD968);
  static const Color accentAmberDark = Color(0xFFD97706);
  
  static const Color accentTealLight = Color(0xFF7FF0C2); 
  static const Color accentTealDark = Color(0xFF059669);
  
  static const Color accentBlueLight = Color(0xFF7EBBFF);
  static const Color accentBlueDark = Color(0xFF2563EB);
  
  static const Color accentRedLight = Color(0xFFFB9A9A);
  static const Color accentRedDark = Color(0xFFDC2626);

  // === NOTIFICATION SCREEN COLORS ===
  static const Color notifUnreadDot = Color(0xFFE95454);
  static const Color notifBgGreen = Color(0xFFE8F8F0);
  static const Color notifIconGreen = Color(0xFF1BA665);
  static const Color notifBgOrange = Color(0xFFFFF0E6);
  static const Color notifIconOrange = Color(0xFFFF7A00);
  static const Color notifBgBlue = Color(0xFFE6F0FF);
  static const Color notifIconBlue = Color(0xFF0066FF);
  static const Color notifBgPurple = Color(0xFFF0E6FF);
  static const Color notifIconPurple = Color(0xFF8B59EF);
}

