import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  static const Color primaryLight = Color(0xFF6B5B95);      // الأرجواني
  static const Color secondaryLight = Color(0xFF88B3E2);    // الأزرق الفاتح
  static const Color accentLight = Color(0xFF6C9EBF);       // الأزرق المتوسط
  static const Color backgroundLight = Color(0xFF6B5B95);   // خلفية أرجوانية

  // Dark Mode Colors
  static const Color primaryDark = Color(0xFF5B4B85);        // أرجواني أغمق (قريب من 6B5B95)
  static const Color secondaryDark = Color(0xFF6893C2);      // أزرق فاتح أغمق (قريب من 88B3E2)
  static const Color accentDark = Color(0xFF5C8EAF);         // أزرق متوسط أغمق (قريب من 6C9EBF)
  static const Color backgroundDark = Color(0xFF4B3B75);     // خلفية أرجوانية أغمق

  // Surface Colors
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF2A2A2A);

  // Glass Container Colors
  static Color get glassContainerLight => Colors.white.withOpacity(0.2);
  static Color get glassContainerDark => Colors.white.withOpacity(0.1);
  static Color get glassBorderLight => Colors.white.withOpacity(0.3);
  static Color get glassBorderDark => Colors.white.withOpacity(0.15);

  // Text Colors
  static const Color textLight = Color(0xFF1A1A1A);
  static const Color textDark = Color(0xFFE0E0E0);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textSecondaryDark = Color(0xFFA0A0A0);
  static const Color textWhite = Colors.white;

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
  static Color dialogBackgroundDark = const Color(0xFF2C2C2C);
  static Color dialogBorderLight = Colors.grey.shade300;
  static Color dialogBorderDark = Colors.grey.shade800;

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