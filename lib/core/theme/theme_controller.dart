import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode controller to manage app theme settings
class ThemeController extends StateNotifier<ThemeMode> {
  /// Shared preferences key for storing theme preference
  static const String _themePreferenceKey = 'theme_mode';
  
  /// Shared preferences instance for persisting theme choice
  final SharedPreferences _preferences;

  /// Constructor initializes state based on saved preferences
  ThemeController(this._preferences) : super(_loadThemeMode(_preferences));

  /// Load theme mode from preferences, default to system
  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final String? themeModeString = prefs.getString(_themePreferenceKey);
    if (themeModeString == null) {
      return ThemeMode.system;
    }
    
    return ThemeMode.values.firstWhere(
      (mode) => mode.toString() == themeModeString,
      orElse: () => ThemeMode.system,
    );
  }

  /// Update theme mode and save preference
  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.setString(_themePreferenceKey, mode.toString());
    state = mode;
  }

  /// Toggle between light and dark mode
  Future<void> toggleThemeMode() async {
    if (state == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Check if current theme is dark
  bool get isDarkMode => state == ThemeMode.dark;

  /// Get current theme mode
  ThemeMode get themeMode => state;
}

/// Provider for theme controller
final themeControllerProvider = StateNotifierProvider<ThemeController, ThemeMode>((ref) {
  throw UnimplementedError('Provider must be overridden with shared preferences');
});

/// Initialize theme controller provider with shared preferences
StateNotifierProvider<ThemeController, ThemeMode> initThemeProvider(SharedPreferences prefs) {
  return StateNotifierProvider<ThemeController, ThemeMode>(
    (ref) => ThemeController(prefs),
  );
}
