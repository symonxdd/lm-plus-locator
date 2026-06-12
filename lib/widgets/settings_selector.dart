import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';

/// App bar action that opens a single bottom sheet combining the theme and
/// language pickers, keeping the app bar itself uncluttered.
///
/// Choices are persisted via [LmPlusLocatorApp.setThemeMode] and
/// [LmPlusLocatorApp.setLocale].
class SettingsSelector extends StatelessWidget {
  const SettingsSelector({super.key, this.onLogout});

  /// Called when the user taps "log out" in the sheet. If `null`, no logout
  /// entry is shown (e.g. on the auth screen, where the user isn't signed in
  /// yet).
  final VoidCallback? onLogout;

  static final _languages = {
    const Locale('nl'): 'Nederlands',
    const Locale('fr'): 'Français',
    const Locale('de'): 'Deutsch',
    const Locale('en'): 'English',
  };

  Future<void> _showSettingsSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final selectedMode = LmPlusLocatorApp.themeModeOf(context);
    final selectedLocale = LmPlusLocatorApp.selectedLocale(context);
    final packageInfo = await PackageInfo.fromPlatform();
    final buildType = kReleaseMode ? 'release' : 'dev';
    final versionLabel = 'v${packageInfo.version} ($buildType)';

    if (!context.mounted) return;

    final themeOptions = {
      ThemeMode.system: (l10n.themeModeSystem, Icons.brightness_auto_outlined),
      ThemeMode.light: (l10n.themeModeLight, Icons.light_mode_outlined),
      ThemeMode.dark: (l10n.themeModeDark, Icons.dark_mode_outlined),
    };

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
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
                for (final entry in themeOptions.entries)
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
                const Divider(height: 32),
                Text(
                  l10n.languageMenuTooltip,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                for (final entry in _languages.entries)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.value),
                    trailing: selectedLocale?.languageCode ==
                            entry.key.languageCode
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      LmPlusLocatorApp.setLocale(context, entry.key);
                      Navigator.of(context).pop();
                    },
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.languageSystemDefault),
                  trailing: selectedLocale == null
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    LmPlusLocatorApp.setLocale(context, null);
                    Navigator.of(context).pop();
                  },
                ),
                if (onLogout != null) ...[
                  const Divider(height: 32),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout),
                    title: Text(l10n.logoutTooltip),
                    onTap: () {
                      Navigator.of(context).pop();
                      onLogout!();
                    },
                  ),
                ],
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    versionLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
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
      onPressed: () => _showSettingsSheet(context),
      icon: const Icon(Icons.settings_outlined),
      tooltip: l10n.settingsTooltip,
    );
  }
}
