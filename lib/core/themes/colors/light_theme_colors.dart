import 'package:ARKidsWorld/core/themes/colors/primary_pallete.dart';
import 'package:ARKidsWorld/core/themes/colors/semantic_pallete.dart';
import 'package:flutter/material.dart';
import 'netural_pallete.dart';


class LightThemeColors {

// Primary colors
  static const Color primary = PrimaryPalette.blue500;
  static const Color onPrimary = NeutralPalette.white;
  static const Color primaryContainer = PrimaryPalette.blue100;
  static const Color onPrimaryContainer = PrimaryPalette.blue900;
  static const Color primaryCard = PrimaryPalette.blue700;

  static const Color secondary = PrimaryPalette.purple500;
  static const Color onSecondary = NeutralPalette.white;
  static const Color secondaryContainer = PrimaryPalette.purple100;
  static const Color onSecondaryContainer = PrimaryPalette.purple900;

// Background and surface colors
  static const Color background = NeutralPalette.grey50;
  static const Color onBackground = NeutralPalette.grey900;

  static const Color surface = NeutralPalette.white;
  static const Color onSurface = NeutralPalette.grey900;
  static const Color surfaceVariant = NeutralPalette.grey100;
  static const Color onSurfaceVariant = NeutralPalette.grey700;
  static const Color onSurfaceVariant2 = NeutralPalette.grey300;

  // State Colors
  static const Color error = SemanticPalette.red700;
  static const Color onError = NeutralPalette.white;
  static const Color errorContainer = SemanticPalette.red50;
  static final Color onErrorContainer = SemanticPalette.red700;

  static const Color success = SemanticPalette.green700;
  static const Color onSuccess = NeutralPalette.white;
  static const Color successContainer = SemanticPalette.green50;
  static final Color onSuccessContainer = SemanticPalette.green700;

  static const Color warning = SemanticPalette.yellow700;
  static const Color onWarning = NeutralPalette.black;
  static const Color warningContainer = SemanticPalette.yellow50;
  static final Color onWarningContainer = SemanticPalette.yellow700;

// Border and outline colors
  static const Color outline = NeutralPalette.grey300;
  static const Color outlineVariant = NeutralPalette.grey200;

// Shadows
  static const Color shadow = NeutralPalette.black;
  static const Color scrim = NeutralPalette.black;
}
