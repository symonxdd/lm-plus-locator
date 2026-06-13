import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Icon-only button that explains, in a bottom sheet, why and how the app
/// uses the device's location.
class PrivacyInfoButton extends StatelessWidget {
  const PrivacyInfoButton({super.key});

  Future<void> _showPrivacyNotice(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Text(l10n.locationPrivacyNotice),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      onPressed: () => _showPrivacyNotice(context),
      icon: const Icon(Icons.privacy_tip_outlined),
      tooltip: l10n.privacyNoticeTooltip,
    );
  }
}
