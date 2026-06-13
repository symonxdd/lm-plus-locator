import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/head_office.dart';

/// App bar action that shows the LM+ head office's address and contact
/// details in a bottom sheet.
class HeadOfficeInfoButton extends StatelessWidget {
  const HeadOfficeInfoButton({super.key});

  Future<void> _showHeadOfficeInfo(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet(
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
                  l10n.headOfficeTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  HeadOffice.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(HeadOffice.addressLine),
                Text(
                  '${HeadOffice.postalCode} ${HeadOffice.city}, '
                  '${l10n.countryBelgium}',
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(HeadOffice.phone),
                  onTap: () => launchUrl(
                    Uri(
                      scheme: 'tel',
                      path: HeadOffice.phone.replaceAll(' ', ''),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.email_outlined),
                  title: Text(HeadOffice.email),
                  onTap: () => launchUrl(
                    Uri(scheme: 'mailto', path: HeadOffice.email),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.language_outlined),
                  title: Text(l10n.visitWebsiteButton),
                  onTap: () => launchUrl(
                    Uri.parse(HeadOffice.website),
                    mode: LaunchMode.externalApplication,
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
      onPressed: () => _showHeadOfficeInfo(context),
      icon: const Icon(Icons.apartment_outlined),
      tooltip: l10n.headOfficeTooltip,
    );
  }
}
