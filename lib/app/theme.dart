import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryViolet,
      scaffoldBackgroundColor: AppColors.surfaceCard,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceCard,
        foregroundColor: AppColors.inkDark,
        elevation: 0,
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryViolet,
        secondary: AppColors.primaryViolet,
        surface: AppColors.surfaceCard,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: AppColors.inkDark,
        onSurface: AppColors.inkDark,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.inkDark),
        bodyMedium: TextStyle(color: AppColors.inkDark),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.background,
      ),
      dividerColor: AppColors.neutralGrey,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryViolet,
      scaffoldBackgroundColor: AppColors.inkDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.inkDark,
        foregroundColor: AppColors.surfaceCard,
        elevation: 0,
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryViolet,
        secondary: AppColors.primaryViolet,
        surface: AppColors.inkDark,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: AppColors.inkDark,
        onSurface: AppColors.surfaceCard,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.surfaceCard),
        bodyMedium: TextStyle(color: AppColors.surfaceCard),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF4A4B56), // slightly lighter than indianInk
      ),
      dividerColor: AppColors.neutralGrey,
    );
  }
}
