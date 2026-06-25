import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/head_office_info_button.dart';
import '../widgets/offline_banner.dart';
import '../widgets/settings_selector.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'messages_screen.dart';
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
  bool _locatorShowingSubScreen = false;
  bool _locatorShowingResults = false;
  bool _documentsShowingPreview = false;
  final _homeScreenKey = GlobalKey<HomeScreenState>();
  final _random = Random();
  List<int>? _factOrder;
  int _factOrderIndex = 0;

  /// Picks the next fact from a shuffled "bag" covering every fact exactly
  /// once before reshuffling, instead of pure random repeats. Guards the
  /// bag boundary so the last fact of one cycle can't immediately repeat
  /// as the first of the next.
  String _nextFact(List<String> facts) {
    if (_factOrder == null || _factOrderIndex >= _factOrder!.length) {
      final previousLast = _factOrder == null
          ? null
          : _factOrder![_factOrder!.length - 1];
      final order = List<int>.generate(facts.length, (i) => i)
        ..shuffle(_random);
      if (previousLast != null && order.first == previousLast && order.length > 1) {
        final swapWith = 1 + _random.nextInt(order.length - 1);
        final first = order[0];
        order[0] = order[swapWith];
        order[swapWith] = first;
      }
      _factOrder = order;
      _factOrderIndex = 0;
    }
    final fact = facts[_factOrder![_factOrderIndex]];
    _factOrderIndex++;
    return fact;
  }

  Future<void> _onMascotTap(AppLocalizations l10n) async {
    final facts = [
      l10n.mascotFact1,
      l10n.mascotFact2,
      l10n.mascotFact3,
      l10n.mascotFact4,
      l10n.mascotFact5,
      l10n.mascotFact6,
      l10n.mascotFact7,
      l10n.mascotFact8,
    ];
    final fact = _nextFact(facts);

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
              children: [
                Image.asset('assets/max.png', height: 96),
                const SizedBox(height: 16),
                Text(
                  l10n.mascotFactSheetTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(fact, textAlign: TextAlign.center),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final showBackButton = _index == 0 && _locatorShowingSubScreen;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // AppBar imposes its own system bar style, so set ours explicitly
        // here too - otherwise the nav bar icons revert to the preset's
        // light color and vanish on the light surface in light mode.
        systemOverlayStyle: AppTheme.systemOverlayStyle(theme),
        leading: showBackButton
            ? IconButton(
                icon: const BackButtonIcon(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => _homeScreenKey.currentState?.goToHero(),
              )
            : Padding(
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
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: Stack(
              children: [
                IndexedStack(
                  index: _index,
                  children: [
                    HomeScreen(
                      key: _homeScreenKey,
                      onSubScreenChanged: (showing) =>
                          setState(() => _locatorShowingSubScreen = showing),
                      onResultsChanged: (showing) =>
                          setState(() => _locatorShowingResults = showing),
                    ),
                    const FavoritesScreen(),
                    const MessagesScreen(),
                    PhotoShareScreen(
                      onPhotoPreviewChanged: (showing) => setState(
                        () => _documentsShowingPreview = showing,
                      ),
                    ),
                  ],
                ),
                // Decorative mascot, sized so it never blocks any screen's
                // actual content or controls. On the Locator tab's results
                // list it sits bottom-left and translucent, since the list
                // runs along the right edge there. On the Documents tab it's
                // hidden entirely once a photo is captured, since the
                // Retake/Send buttons occupy its corner. Everywhere else
                // (including the Documents tab's default state, and the
                // Locator tab before any search) it's bottom-right, fully
                // opaque, and tappable.
                if (!(_index == 3 && _documentsShowingPreview))
                  Positioned(
                    bottom: 8,
                    left: _index == 0 && _locatorShowingResults ? 8 : null,
                    right: _index == 0 && _locatorShowingResults ? null : 8,
                    child: GestureDetector(
                      onTap: () => _onMascotTap(l10n),
                      child: Opacity(
                        opacity: _index == 0 && _locatorShowingResults
                            ? 0.6
                            : 1,
                        child: Image.asset('assets/max.png', width: 84),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
            icon: const Icon(Icons.bookmark_outline),
            selectedIcon: const Icon(Icons.bookmark),
            label: l10n.favoritesTabLabel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble),
            label: l10n.messagesTabLabel,
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
