import 'package:flutter/material.dart';

/// Color palette for the Cleo application.
/// Contains all the colors used throughout the app.
class CleoColors {
  // Primary Colors
  static const Color primary = Color(0xFF3273DC);
  static const Color primaryLight = Color(0xFF5290E6);
  static const Color primaryDark = Color(0xFF2962FF);

  // Accent Colors
  static const Color success = Color(0xFF2F855A);
  static const Color successLight = Color(0xFF48BB78);
  static const Color error = Color(0xFFC53030);
  static const Color errorLight = Color(0xFFFEB2B2);
  static const Color info = Color(0xFF3182CE);
  static const Color infoLight = Color(0xFF63B3ED);

  // Neutral Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFF8F9FA); // Formerly background
  static const Color onSurface = Color(0xFF333333); // Formerly onBackground
  static const Color onSurfaceVariant = Color(0xFF555555);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textDisabled = Color(0xFFAAAAAA);

  // Dark Theme Colors
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceContainer = Color(0xFF121212); // Formerly darkBackground
  static const Color darkTextPrimary = Color(0xFFEEEEEE);
  static const Color darkTextSecondary = Color(0xFFBBBBBB);
}
