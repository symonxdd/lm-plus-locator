import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's manually-selected theme mode across restarts.
///
/// [ThemeMode.system] is the default and means "follow the device theme".
class ThemeService {
  static const _prefsKey = 'app_theme_mode';

  /// Loads the previously saved theme mode, or [ThemeMode.system] if the
  /// user hasn't picked one.
  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_prefsKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  /// Saves the user's chosen theme mode.
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }
}
