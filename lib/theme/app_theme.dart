import 'package:flutter/material.dart';

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
}
