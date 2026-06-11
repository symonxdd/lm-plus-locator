import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final office = officeWithDistance.office;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: _openInMaps,
        leading: const Icon(Icons.location_on),
        title: Text(office.name),
        subtitle: Text('${office.city}\n${office.phone}'),
        isThreeLine: true,
        trailing: Text(
          '${officeWithDistance.distanceKm.toStringAsFixed(1)} km',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
