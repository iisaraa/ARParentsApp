import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headers
  static TextStyle headerLarge(bool isDark) {
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: isDark ? AppColors.textDark : AppColors.textLight,
      fontFamily: 'BerkshireSwash',
    );
  }

  static TextStyle headerMedium(bool isDark) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: isDark ? AppColors.textDark : AppColors.textLight,
    );
  }

  static TextStyle headerSmall(bool isDark) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: isDark ? AppColors.textDark : AppColors.textLight,
    );
  }

  // Body Text
  static TextStyle bodyLarge(bool isDark) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: isDark ? AppColors.textDark : AppColors.textLight,
    );
  }

  static TextStyle bodyMedium(bool isDark) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    );
  }

  static TextStyle bodySmall(bool isDark) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    );
  }

  // Labels
  static TextStyle labelLarge(bool isDark) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.textDark : AppColors.textLight,
    );
  }

  static TextStyle labelMedium(bool isDark) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    );
  }

  // Buttons
  static TextStyle buttonText(bool isDark) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: isDark ? AppColors.textDark : Colors.white,
    );
  }

  // Error
  static TextStyle errorText(bool isDark) {
    return TextStyle(
      fontSize: 12,
      color: isDark ? AppColors.errorDark : AppColors.errorLight,
    );
  }
}