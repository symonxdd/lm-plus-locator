import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/office.dart';

/// A card showing a nearby LM+ office. Tapping it opens the office's
/// location in Google Maps (or Apple Maps on iOS).
class OfficeCard extends StatelessWidget {
  const OfficeCard({super.key, required this.officeWithDistance});

  final OfficeWithDistance officeWithDistance;

  Future<void> _openInMaps() async {
    final office = officeWithDistance.office;
    final Uri uri;
    if (!kIsWeb && Platform.isIOS) {
      uri = Uri.parse(
        'https://maps.apple.com/?q=${Uri.encodeComponent(office.name)}'
        '&ll=${office.lat},${office.lng}',
      );
    } else {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1'
        '&query=${office.lat},${office.lng}',
      );
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final office = officeWithDistance.office;
    final mutedStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.outline,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _openInMaps,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            office.name,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.distanceInKm(
                            officeWithDistance.distanceKm.toStringAsFixed(1),
                          ),
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(office.fullAddress),
                    Text(office.phone),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_outlined,
                          size: 14,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(l10n.openInMapsHint, style: mutedStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
