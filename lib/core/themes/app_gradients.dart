import 'package:flutter/material.dart';

class AppGradients {
  // Light Mode Gradient
  static const LinearGradient primaryGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6B5B95),
      Color(0xFF88B3E2),
      Color(0xFF6C9EBF),
    ],
  );

  // Dark Mode Gradient
  static const LinearGradient primaryGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5B4B85),
      Color(0xFF6893C2),
      Color(0xFF5C8EAF),
    ],
  );

  // Glass Container Gradient
  static LinearGradient glassContainerGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        isDark
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.25),
        isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.1),
      ],
    );
  }

  // Background Gradient
  static LinearGradient backgroundGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark ? [
        const Color(0xFF4B3B75),
        const Color(0xFF5B4B85),
        const Color(0xFF6893C2),
      ] : [
        const Color(0xFF6B5B95),
        const Color(0xFF88B3E2),
        const Color(0xFF6C9EBF),
      ],
    );
  }

  // Glass Container Decoration
  static BoxDecoration glassContainerDecoration(bool isDark) {
    return BoxDecoration(
      gradient: glassContainerGradient(isDark),
      borderRadius: BorderRadius.circular(45),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.3),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Glass Effect for Cards
  static LinearGradient glassGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.2),
        isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.1),
      ],
    );
  }
}