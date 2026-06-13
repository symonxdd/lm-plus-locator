import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The app's light and dark [ThemeData].
class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
  );

  /// System bar overlay style for [theme]: a transparent status bar and a
  /// navigation bar painted in the theme's surface color, with status- and
  /// nav-bar icon colors matching the theme's brightness so they stay legible.
  ///
  /// The icon brightnesses are set explicitly rather than via
  /// [SystemUiOverlayStyle.light]/[SystemUiOverlayStyle.dark], whose presets
  /// always use light nav-bar icons (intended for the default black bar) and
  /// would be invisible on a light surface.
  static SystemUiOverlayStyle systemOverlayStyle(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final iconBrightness = isDark ? Brightness.light : Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: iconBrightness,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: theme.colorScheme.surface,
      systemNavigationBarDividerColor: theme.colorScheme.surface,
      systemNavigationBarIconBrightness: iconBrightness,
      systemNavigationBarContrastEnforced: false,
    );
  }
}
