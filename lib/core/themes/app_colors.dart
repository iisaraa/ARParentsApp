import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  static const Color primaryLight = Color(0xFF6B5B95);
  static const Color secondaryLight = Color(0xFF88B3E2);
  static const Color accentLight = Color(0xFF6C9EBF);
  static const Color backgroundLight = Color(0xFF6B5B95);

  // Dark Mode Colors
  static const Color primaryDark = Color(0xFF6A5A8A);
  static const Color secondaryDark = Color(0xFF6D9FC8);
  static const Color accentDark = Color(0xFF6898B8);
  static const Color backgroundDark = Color(0xFF5A4A7A);

  // Surface Colors
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF2A2A3E);
  // static const Color surfaceDark = Color(0xFF2A2A2A);

  // Glass Container Colors
  static Color get glassContainerLight => Colors.white.withOpacity(0.2);
  static Color get glassContainerDark => Colors.white.withOpacity(0.08);
  static Color get glassBorderLight => Colors.white.withOpacity(0.3);
  static Color get glassBorderDark => Colors.white.withOpacity(0.1);

  // Text Colors
  static const Color textLight = Color(0xFF1A1A1A);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textWhite = Colors.white;
  static const Color textBlack = Colors.black;


  // Error Colors
  static const Color errorLight = Color(0xFFE53935);
  static const Color errorDark = Color(0xFFEF5350);

  // Success Colors
  static const Color successLight = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF66BB6A);

  // Warning Colors
  static const Color warningLight = Color(0xFFFF9800);
  static const Color warningDark = Color(0xFFFFA726);

  // Button Colors
  static const Color buttonLight = Colors.white;
  static const Color buttonDark = Colors.white;
  static const Color buttonTextLight = Color(0xFF6B5B95);
  static const Color buttonTextDark = Color(0xFF8B7BB5);

  // Dialog Colors
  static Color dialogBackgroundLight = surfaceLight;
  static Color dialogBackgroundDark = const Color(0xFF2A2A3E);
  static Color dialogBorderLight = Colors.grey.shade300;
  static Color dialogBorderDark = Colors.grey.shade800;

  static const Color info = Color(0xFF2196F3);      // للأزرق (Males)
  static const Color warning = Color(0xFFE91E63);    // للوردي (Females)
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  static const Color dividerLight = Color(0xFFBDBDBD);
  static const Color dividerDark = Color(0xFF616161);
  static const Color shadowLight = Color(0xFF000000);
  static const Color shadowDark = Color(0xFF000000);

  // Gradient Colors
  static const List<Color> lightGradientColors = [
    Color(0xFF6B5B95),
    Color(0xFF88B3E2),
    Color(0xFF6C9EBF),
  ];

  static const List<Color> darkGradientColors = [
    Color(0xFF5B4B85),
    Color(0xFF6893C2),
    Color(0xFF5C8EAF),
  ];

}