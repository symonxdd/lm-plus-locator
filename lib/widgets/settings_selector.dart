import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import 'account_sheet.dart';

const _privacyPolicyUrl =
    'https://symonxdd.github.io/lm-plus-locator/privacy-policy/';

const _developerName = 'Symon Blazejczak';
const _portfolioUrl = 'https://symon.me';
const _githubUrl = 'https://github.com/symonxdd/lm-plus-locator';
const _docsUrl = 'https://symonxdd.github.io/lm-plus-locator/';

/// App bar action that opens a single bottom sheet combining the theme and
/// language pickers, keeping the app bar itself uncluttered.
///
/// Choices are persisted via [LmPlusLocatorApp.setThemeMode] and
/// [LmPlusLocatorApp.setLocale].
class SettingsSelector extends StatelessWidget {
  const SettingsSelector({super.key});

  static final _languages = {
    const Locale('nl'): 'Nederlands',
    const Locale('fr'): 'Français',
    const Locale('de'): 'Deutsch',
    const Locale('en'): 'English',
  };

  Future<void> _showSettingsSheet(BuildContext rootContext) async {
    final l10n = AppLocalizations.of(rootContext)!;
    final selectedMode = LmPlusLocatorApp.themeModeOf(rootContext);
    final effectiveLocale = LmPlusLocatorApp.effectiveLocale(rootContext);
    final packageInfo = await PackageInfo.fromPlatform();
    final buildType = kReleaseMode ? 'internal release build' : 'dev';
    final versionLabel = 'v${packageInfo.version} ($buildType)';

    if (!rootContext.mounted) return;

    final themeOptions = {
      ThemeMode.system: (l10n.themeModeSystem, Icons.brightness_auto_outlined),
      ThemeMode.light: (l10n.themeModeLight, Icons.light_mode_outlined),
      ThemeMode.dark: (l10n.themeModeDark, Icons.dark_mode_outlined),
    };

    await showModalBottomSheet<void>(
      context: rootContext,
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
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(l10n.accountTooltip),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showAccountSheet(rootContext);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.privacyPolicyButton),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    Navigator.of(context).pop();
                    launchUrl(
                      Uri.parse(_privacyPolicyUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.aboutTooltip),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showAboutSheet(rootContext);
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
                    trailing:
                        effectiveLocale.languageCode == entry.key.languageCode
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
                const Divider(height: 32),
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
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    versionLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    l10n.unofficialAppNotice,
                    textAlign: TextAlign.center,
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

  Future<void> _showAccountSheet(BuildContext context) async {
    if (!context.mounted) return;
    final accountDeleted = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const AccountSheet(),
    );

    if (accountDeleted == true && context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          backgroundColor: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.accountDeletedMessage,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _showAboutSheet(BuildContext context) async {
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.aboutTooltip, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Text(
                  l10n.aboutDeveloperLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Text(_developerName, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.language_outlined),
                  title: Text(l10n.aboutPortfolioButton),
                  onTap: () => launchUrl(
                    Uri.parse(_portfolioUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.code_outlined),
                  title: Text(l10n.aboutGithubButton),
                  onTap: () => launchUrl(
                    Uri.parse(_githubUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.menu_book_outlined),
                  title: Text(l10n.aboutDocsButton),
                  onTap: () => launchUrl(
                    Uri.parse(_docsUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    l10n.aboutBuiltLabel,
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
