import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/office.dart';
import '../services/favorites_service.dart';
import '../theme/app_colors.dart';
import 'opening_hours_sheet.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _openInMaps,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: ctaColors(context).background,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          office.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      if (officeWithDistance.distanceKm != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          l10n.distanceInKm(
                            officeWithDistance.distanceKm!.toStringAsFixed(1),
                          ),
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                      const SizedBox(width: 4),
                      ValueListenableBuilder<Set<String>>(
                        valueListenable: FavoritesService.instance.favorites,
                        builder: (context, keys, _) {
                          final key = '${office.lat},${office.lng}';
                          final saved = keys.contains(key);
                          return IconButton(
                            icon: Icon(
                              saved ? Icons.bookmark : Icons.bookmark_outline,
                              color: saved
                                  ? ctaColors(context).background
                                  : theme.colorScheme.outline,
                            ),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            visualDensity: VisualDensity.compact,
                            tooltip: saved
                                ? l10n.favoriteRemoveTooltip
                                : l10n.favoriteAddTooltip,
                            onPressed: () =>
                                FavoritesService.instance.toggle(key),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    // Indented to align under the title text, past the pin
                    // icon (24) and its spacing (12) above.
                    padding: const EdgeInsets.only(left: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (office.isOpenNow != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              SizedBox(
                                width: 14,
                                child: Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: office.isOpenNow!
                                      ? Colors.green
                                      : theme.colorScheme.error,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                office.isOpenNow!
                                    ? l10n.officeOpenNow
                                    : l10n.officeClosedNow,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: office.isOpenNow!
                                      ? Colors.green
                                      : theme.colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 14,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                office.fullAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.call_outlined,
                              size: 14,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(office.phone),
                          ],
                        ),
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
          if (office.openingHours != null) ...[
            const Divider(height: 1),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  builder: (_) => OpeningHoursSheet(office: office),
                ),
                icon: const Icon(Icons.schedule_outlined, size: 18),
                label: Text(l10n.viewOpeningHoursHint),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
