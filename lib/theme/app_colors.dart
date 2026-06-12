import 'package:flutter/material.dart';

/// Navy from the app icon's pin shape — primary CTA color in light mode.
const brandNavy = Color(0xFF2C398F);

/// Light blue from the app icon's plus sign — primary CTA color in dark
/// mode, where the navy doesn't have enough contrast against a dark surface.
const brandSkyBlue = Color(0xFF85D1F5);

/// Background/foreground colors for the app's primary call-to-action
/// buttons, chosen for readability in both light and dark themes.
({Color background, Color foreground}) ctaColors(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark
      ? (background: brandSkyBlue, foreground: const Color(0xFF0D1B4C))
      : (background: brandNavy, foreground: Colors.white);
}
