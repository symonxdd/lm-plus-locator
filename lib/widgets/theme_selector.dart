import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';

/// App bar action that lets the user switch between light, dark and the
/// device's system theme.
///
/// The choice is persisted via [LmPlusLocatorApp.setThemeMode].
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  Future<void> _showThemePicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final selectedMode = LmPlusLocatorApp.themeModeOf(context);

    final options = {
      ThemeMode.system: (l10n.themeModeSystem, Icons.brightness_auto_outlined),
      ThemeMode.light: (l10n.themeModeLight, Icons.light_mode_outlined),
      ThemeMode.dark: (l10n.themeModeDark, Icons.dark_mode_outlined),
    };

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
                  l10n.themeMenuTooltip,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                for (final entry in options.entries)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(entry.value.$2),
                    title: Text(entry.value.$1),
                    trailing: selectedMode == entry.key
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      LmPlusLocatorApp.setThemeMode(context, entry.key);
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
      onPressed: () => _showThemePicker(context),
      icon: const Icon(Icons.brightness_6_outlined),
      tooltip: l10n.themeMenuTooltip,
    );
  }
}
