import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cleo_colors.dart';
import 'cleo_typography.dart';
import 'cleo_spacing.dart';

/// Theme configuration for the Cleo application.
/// Provides light and dark themes with consistent styling.
class CleoTheme {
  /// Get the light theme for the application
  static ThemeData get lightTheme {
    return ThemeData(
      // Base theme properties
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: CleoColors.primary,
        secondary: CleoColors.primaryLight,
        surface: CleoColors.surface,
        surfaceContainer: CleoColors.surfaceContainer,
        error: CleoColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: CleoColors.onSurface,
        onError: Colors.white,
      ),

      // Text Theme
      textTheme: CleoTypography.getTextTheme(Brightness.light),
      
      // Font family
      fontFamily: GoogleFonts.inter().fontFamily,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: CleoColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: CleoSpacing.borderRadius,
        ),
        color: CleoColors.surface,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CleoColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: CleoSpacing.borderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CleoColors.primary,
          side: const BorderSide(color: CleoColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: CleoSpacing.borderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CleoColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: CleoSpacing.borderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: CleoSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: CleoSpacing.borderRadius,
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: CleoSpacing.borderRadius,
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: CleoSpacing.borderRadius,
          borderSide: const BorderSide(
            color: CleoColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: CleoSpacing.borderRadius,
          borderSide: const BorderSide(
            color: CleoColors.error,
            width: 1,
          ),
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: CleoColors.error,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CleoColors.primary,
        foregroundColor: Colors.white,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CleoColors.surface,
        selectedItemColor: CleoColors.primary,
        unselectedItemColor: CleoColors.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // List Tile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        dense: true,
        horizontalTitleGap: 12,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CleoColors.onSurface,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: CleoSpacing.borderRadius,
        ),
      ),

      // Scaffold Background
      scaffoldBackgroundColor: CleoColors.surfaceContainer,
    );
  }

  /// Get the dark theme for the application
  static ThemeData get darkTheme {
    return ThemeData(
      // Base theme properties
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: CleoColors.primaryLight,
        secondary: CleoColors.primary,
        surface: CleoColors.darkSurface,
        surfaceContainer: CleoColors.darkSurfaceContainer,
        error: CleoColors.errorLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: CleoColors.darkTextPrimary,
        onError: Colors.white,
      ),

      // Text Theme
      textTheme: CleoTypography.getTextTheme(Brightness.dark),
      
      // Font family
      fontFamily: GoogleFonts.inter().fontFamily,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: CleoColors.darkSurface,
        foregroundColor: CleoColors.darkTextPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: CleoColors.darkTextPrimary,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: CleoSpacing.borderRadius,
          side: BorderSide(color: Colors.grey.shade800, width: 1),
        ),
        color: CleoColors.darkSurface,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CleoColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: CleoSpacing.borderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CleoColors.primaryLight,
          side: const BorderSide(color: CleoColors.primaryLight),
          shape: RoundedRectangleBorder(
            borderRadius: CleoSpacing.borderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CleoColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: CleoSpacing.borderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CleoColors.darkSurfaceContainer,
        contentPadding: CleoSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: CleoSpacing.borderRadius,
          borderSide: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: CleoSpacing.borderRadius,
          borderSide: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: CleoSpacing.borderRadius,
          borderSide: const BorderSide(
            color: CleoColors.primaryLight,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: CleoSpacing.borderRadius,
          borderSide: const BorderSide(
            color: CleoColors.errorLight,
            width: 1,
          ),
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: CleoColors.errorLight,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CleoColors.primaryLight,
        foregroundColor: Colors.white,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CleoColors.darkSurface,
        selectedItemColor: CleoColors.primaryLight,
        unselectedItemColor: CleoColors.darkTextSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // List Tile
      listTileTheme: const ListTileThemeData(
        contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        dense: true,
        horizontalTitleGap: 12,
        textColor: CleoColors.darkTextPrimary,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey.shade800,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: CleoColors.darkTextPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: CleoSpacing.borderRadius,
        ),
      ),

      // Scaffold Background
      scaffoldBackgroundColor: CleoColors.darkSurfaceContainer,
    );
  }
}
