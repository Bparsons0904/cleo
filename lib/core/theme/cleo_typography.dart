import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cleo_colors.dart';

/// Typography styles for the Cleo application.
/// Contains all the text styles used throughout the app.
class CleoTypography {
  // Headline Styles
  static TextStyle headline1(BuildContext context) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).brightness == Brightness.dark 
      ? CleoColors.darkTextPrimary 
      : CleoColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle headline2(BuildContext context) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).brightness == Brightness.dark 
      ? CleoColors.darkTextPrimary 
      : CleoColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle headline3(BuildContext context) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).brightness == Brightness.dark 
      ? CleoColors.darkTextPrimary 
      : CleoColors.textPrimary,
    letterSpacing: -0.2,
  );

  // Body Styles
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).brightness == Brightness.dark 
      ? CleoColors.darkTextPrimary 
      : CleoColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).brightness == Brightness.dark 
      ? CleoColors.darkTextSecondary 
      : CleoColors.textSecondary,
    height: 1.4,
  );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).brightness == Brightness.dark 
      ? CleoColors.darkTextSecondary 
      : CleoColors.textSecondary,
    height: 1.3,
  );

  static TextStyle caption(BuildContext context) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).brightness == Brightness.dark 
      ? CleoColors.darkTextSecondary 
      : CleoColors.textDisabled,
  );

  // Button Text
  static TextStyle buttonText(BuildContext context) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  /// Generate a complete text theme using Google Fonts
  static TextTheme getTextTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color textPrimary = isDark ? CleoColors.darkTextPrimary : CleoColors.textPrimary;
    final Color textSecondary = isDark ? CleoColors.darkTextSecondary : CleoColors.textSecondary;
    
    return GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.3,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isDark ? CleoColors.darkTextSecondary : CleoColors.textDisabled,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
