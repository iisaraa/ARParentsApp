import 'package:ARKidsWorld/core/themes/colors/primary_pallete.dart';
import 'package:ARKidsWorld/core/themes/colors/semantic_pallete.dart';
import 'package:flutter/material.dart';
import 'netural_pallete.dart';

class DarkThemeColors {
// Primary colors

  static const Color primary = PrimaryPalette.blue300;
  static const Color onPrimary = NeutralPalette.grey900;
  static const Color primaryContainer = PrimaryPalette.blue900;
  static const Color onPrimaryContainer = PrimaryPalette.blue100;

  static const Color secondary = PrimaryPalette.purple300;
  static const Color onSecondary = NeutralPalette.grey900;
  static const Color secondaryContainer = PrimaryPalette.purple900;
  static const Color onSecondaryContainer = PrimaryPalette.purple100;

// Background and surface colors
  static const Color background = NeutralPalette.grey900;
  static const Color onBackground = NeutralPalette.grey100;

  static const Color surface = NeutralPalette.grey850;
  static const Color onSurface = NeutralPalette.grey100;
  static const Color surfaceVariant = NeutralPalette.grey800;
  static const Color onSurfaceVariant = NeutralPalette.grey400;

// State Color
  static const Color error = SemanticPalette.red500;
  static const Color onError = NeutralPalette.black;
  static final Color errorContainer = SemanticPalette.red700;
  static const Color onErrorContainer = SemanticPalette.red50;

  static const Color success = SemanticPalette.green500;
  static const Color onSuccess = NeutralPalette.black;
  static final Color successContainer = SemanticPalette.green700;
  static const Color onSuccessContainer = SemanticPalette.green50;

  static const Color warning = SemanticPalette.yellow500;
  static const Color onWarning = NeutralPalette.black;
  static final Color warningContainer = SemanticPalette.yellow700;
  static const Color onWarningContainer = SemanticPalette.yellow50;

// Border and outline colors
  static const Color outline = NeutralPalette.grey700;
  static const Color outlineVariant = NeutralPalette.grey800;

//Shadows
  static const Color shadow = NeutralPalette.black;
  static const Color scrim = NeutralPalette.black;
}