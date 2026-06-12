import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/locale_service.dart';
import 'services/theme_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LmPlusLocatorApp());
}

class LmPlusLocatorApp extends StatefulWidget {
  const LmPlusLocatorApp({super.key});

  /// Sets the app's locale and persists the choice. Pass `null` to follow
  /// the device language again (falling back to Dutch if unsupported).
  static void setLocale(BuildContext context, Locale? locale) {
    context.findAncestorStateOfType<_LmPlusLocatorAppState>()?._setLocale(locale);
  }

  /// The manually-selected locale, or `null` if the app is following the
  /// device language.
  static Locale? selectedLocale(BuildContext context) {
    return context.findAncestorStateOfType<_LmPlusLocatorAppState>()?._locale;
  }

  /// Sets the app's theme mode and persists the choice.
  static void setThemeMode(BuildContext context, ThemeMode mode) {
    context.findAncestorStateOfType<_LmPlusLocatorAppState>()?._setThemeMode(mode);
  }

  /// The current theme mode (defaults to [ThemeMode.system]).
  static ThemeMode themeModeOf(BuildContext context) {
    return context.findAncestorStateOfType<_LmPlusLocatorAppState>()?._themeMode ??
        ThemeMode.system;
  }

  @override
  State<LmPlusLocatorApp> createState() => _LmPlusLocatorAppState();
}

class _LmPlusLocatorAppState extends State<LmPlusLocatorApp>
    with WidgetsBindingObserver {
  final _localeService = LocaleService();
  final _themeService = ThemeService();
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localeService.loadLocale().then((locale) {
      if (mounted) setState(() => _locale = locale);
    });
    _themeService.loadThemeMode().then((mode) {
      if (mounted) setState(() => _themeMode = mode);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // Re-resolve the device locale if the user hasn't picked one manually.
    if (_locale == null) setState(() {});
  }

  void _setLocale(Locale? locale) {
    setState(() => _locale = locale);
    _localeService.saveLocale(locale);
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    _themeService.saveThemeMode(mode);
  }

  /// Maps the device's current locale to a supported one, falling back to
  /// Dutch when the device language isn't supported.
  Locale _resolveDeviceLocale() {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    for (final supported in AppLocalizations.supportedLocales) {
      if (supported.languageCode == deviceLocale.languageCode) {
        return supported;
      }
    }
    return const Locale('nl');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LM+ Locator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // If the user picked a language manually, use it. Otherwise follow the
      // device language, falling back to Dutch when unsupported.
      locale: _locale ?? _resolveDeviceLocale(),
      home: const HomeScreen(),
    );
  }
}
