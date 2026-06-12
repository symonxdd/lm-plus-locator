import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's manually-selected app language across restarts.
///
/// A `null` locale means "follow the device language" (falling back to
/// Dutch for unsupported languages, via [MaterialApp.localeResolutionCallback]).
class LocaleService {
  static const _prefsKey = 'app_locale_code';

  /// Loads the previously saved locale, or `null` if the user hasn't picked
  /// one (i.e. the device language should be used).
  Future<Locale?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code == null) return null;
    return Locale(code);
  }

  /// Saves the user's chosen locale. Pass `null` to clear the preference and
  /// follow the device language again.
  Future<void> saveLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_prefsKey);
    } else {
      await prefs.setString(_prefsKey, locale.languageCode);
    }
  }
}
