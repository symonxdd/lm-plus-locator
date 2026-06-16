import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/connectivity_service.dart';

/// Thin amber strip shown immediately below the [AppBar] when the device has
/// no internet connection. Slides in and out automatically — no manual dismiss.
///
/// The core office locator still works offline (offices are bundled as an
/// asset), so this is an informational nudge, not a blocking error.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  static final _service = ConnectivityService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _service.onlineStream,
      // Optimistic default: assume online until the first event arrives so
      // the banner doesn't flash in on every cold start.
      initialData: true,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          // Keep width stable so AnimatedSize only animates the height.
          child: SizedBox(
            width: double.infinity,
            child: isOnline ? null : _BannerContent(),
          ),
        );
      },
    );
  }
}

class _BannerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Amber warning colors — Material 3 has no 'warning' semantic slot, so
    // these are defined explicitly to avoid clashing with the app's blue
    // primary or red error colors.
    final bg = isDark ? const Color(0xFF4A3800) : const Color(0xFFFFF3CD);
    final fg = isDark ? const Color(0xFFFFE082) : const Color(0xFF5C4000);

    return ColoredBox(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.wifi_off_rounded, size: 16, color: fg),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.offlineBannerMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
