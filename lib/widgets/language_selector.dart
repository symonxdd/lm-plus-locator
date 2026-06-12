import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';

/// App bar action that lets the user manually pick the app's language
/// (Dutch, French, German or English), or follow the device language.
///
/// The choice is persisted via [LmPlusLocatorApp.setLocale].
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  static final _languages = {
    const Locale('nl'): 'Nederlands',
    const Locale('fr'): 'Français',
    const Locale('de'): 'Deutsch',
    const Locale('en'): 'English',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);

    return PopupMenuButton<Locale?>(
      icon: const Icon(Icons.language),
      tooltip: l10n.languageMenuTooltip,
      onSelected: (locale) => LmPlusLocatorApp.setLocale(context, locale),
      itemBuilder: (context) => [
        for (final entry in _languages.entries)
          CheckedPopupMenuItem(
            value: entry.key,
            checked: currentLocale.languageCode == entry.key.languageCode,
            child: Text(entry.value),
          ),
        const PopupMenuDivider(),
        CheckedPopupMenuItem(
          value: null,
          checked: false,
          child: Text(l10n.languageSystemDefault),
        ),
      ],
    );
  }
}
