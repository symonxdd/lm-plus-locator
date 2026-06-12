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

  @override
  State<LmPlusLocatorApp> createState() => _LmPlusLocatorAppState();
}

class _LmPlusLocatorAppState extends State<LmPlusLocatorApp> {
  final _localeService = LocaleService();
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _localeService.loadLocale().then((locale) {
      if (mounted) setState(() => _locale = locale);
    });
  }

  void _setLocale(Locale? locale) {
    setState(() => _locale = locale);
    _localeService.saveLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LM+ Locator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // If the user picked a language manually, use it. Otherwise use the
      // device locale when it's nl/fr/de/en, falling back to Dutch.
      locale: _locale,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale != null) {
          for (final supported in supportedLocales) {
            if (supported.languageCode == deviceLocale.languageCode) {
              return supported;
            }
          }
        }
        return const Locale('nl');
      },
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
