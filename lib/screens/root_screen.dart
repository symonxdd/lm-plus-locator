import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/head_office_info_button.dart';
import '../widgets/settings_selector.dart';
import 'home_screen.dart';
import 'photo_share_screen.dart';

/// Top-level scaffold with a bottom navigation bar for switching between the
/// office locator and the photo-share feature.
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // AppBar imposes its own system bar style, so set ours explicitly
        // here too - otherwise the nav bar icons revert to the preset's
        // light color and vanish on the light surface in light mode.
        systemOverlayStyle: AppTheme.systemOverlayStyle(theme),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  ctaColors(context).background,
                  BlendMode.srcIn,
                ),
                child: Image.asset('assets/icon/icon_pin_mask.png'),
              ),
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  ctaColors(context).foreground,
                  BlendMode.srcIn,
                ),
                child: Image.asset('assets/icon/icon_plus_mask.png'),
              ),
            ],
          ),
        ),
        title: Text(l10n.appTitle),
        actions: const [HeadOfficeInfoButton(), SettingsSelector()],
      ),
      body: IndexedStack(
        index: _index,
        children: const [HomeScreen(), PhotoShareScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        // Match the screen background instead of the default, slightly
        // elevated surface color, so the bar blends into the rest of the UI.
        backgroundColor: colorScheme.surface,
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.location_on_outlined),
            selectedIcon: const Icon(Icons.location_on),
            label: l10n.locatorTabLabel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.camera_alt_outlined),
            selectedIcon: const Icon(Icons.camera_alt),
            label: l10n.photoShareTabLabel,
          ),
        ],
      ),
    );
  }
}
