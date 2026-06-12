import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'services/locale_service.dart';

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

  @override
  State<LmPlusLocatorApp> createState() => _LmPlusLocatorAppState();
}

class _LmPlusLocatorAppState extends State<LmPlusLocatorApp>
    with WidgetsBindingObserver {
  final _localeService = LocaleService();
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localeService.loadLocale().then((locale) {
      if (mounted) setState(() => _locale = locale);
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // If the user picked a language manually, use it. Otherwise follow the
      // device language, falling back to Dutch when unsupported.
      locale: _locale ?? _resolveDeviceLocale(),
      home: const AuthGate(),
    );
  }
}

/// Shows [AuthScreen] or [HomeScreen] depending on the current Firebase auth
/// state, switching automatically as the user logs in or out.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const AuthScreen();
      },
    );
  }
}
