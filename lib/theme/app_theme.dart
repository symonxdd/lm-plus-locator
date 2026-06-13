import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The app's light and dark [ThemeData].
class AppTheme {
  static final _lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  static final _darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  );

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
    inputDecorationTheme: _inputDecorationTheme(_lightColorScheme),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
    inputDecorationTheme: _inputDecorationTheme(_darkColorScheme),
  );

  /// A softer, filled look for text fields: a tinted background with no
  /// visible outline at rest, and a crisp rounded border once focused.
  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    final radius = BorderRadius.circular(14);
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
      disabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
    );
  }

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
