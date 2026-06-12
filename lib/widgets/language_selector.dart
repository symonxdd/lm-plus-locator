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

  Future<void> _showLanguagePicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final selectedLocale = LmPlusLocatorApp.selectedLocale(context);

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.languageMenuTooltip,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                for (final entry in _languages.entries)
                  _LanguageOption(
                    label: entry.value,
                    selected: selectedLocale?.languageCode ==
                        entry.key.languageCode,
                    onTap: () {
                      LmPlusLocatorApp.setLocale(context, entry.key);
                      Navigator.of(context).pop();
                    },
                  ),
                const Divider(),
                _LanguageOption(
                  label: l10n.languageSystemDefault,
                  selected: selectedLocale == null,
                  onTap: () {
                    LmPlusLocatorApp.setLocale(context, null);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      onPressed: () => _showLanguagePicker(context),
      icon: const Icon(Icons.language),
      tooltip: l10n.languageMenuTooltip,
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: selected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
