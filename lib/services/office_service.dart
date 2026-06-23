import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/office.dart';

/// Loads LM+ office data and finds the offices nearest to a given location.
class OfficeService {
  static const _assetPath = 'assets/lm_offices.json';
  static const _earthRadiusKm = 6371.0;

  /// Loads all offices from the bundled JSON asset.
  Future<List<Office>> loadOffices() async {
    final raw = await rootBundle.loadString(_assetPath);
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    return data.map((e) => Office.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Returns all [offices] paired with their distance to (userLat, userLng),
  /// sorted by ascending distance, using the Haversine formula.
  List<OfficeWithDistance> nearestOffices({
    required List<Office> offices,
    required double userLat,
    required double userLng,
  }) {
    final withDistance = offices
        .map(
          (office) => OfficeWithDistance(
            office: office,
            distanceKm: _haversineDistanceKm(
              userLat,
              userLng,
              office.lat,
              office.lng,
            ),
          ),
        )
        .toList();

    withDistance.sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));
    return withDistance;
  }

  /// Narrows [offices] down to the ones matching a free-text [query],
  /// against the name, street address, postal code, and city - diacritic-
  /// and case-insensitive. A multi-word query (e.g. "korenmarkt gent")
  /// requires every word to match somewhere in the office's combined text.
  /// An empty [query] returns [offices] unchanged. Unlike [nearestOffices],
  /// this preserves the input order, so filtering already-sorted results
  /// (by distance) keeps them sorted.
  List<OfficeWithDistance> filterByText(
    List<OfficeWithDistance> offices,
    String query,
  ) {
    final tokens = _normalize(
      query,
    ).split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
    if (tokens.isEmpty) return offices;

    return offices.where((o) {
      final office = o.office;
      final haystack = _normalize(
        '${office.name} ${office.address} ${office.postalCode} ${office.city}',
      );
      return tokens.every(haystack.contains);
    }).toList();
  }

  static const _diacriticsMap = {
    'à': 'a', 'á': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a',
    'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
    'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
    'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
    'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
    'ç': 'c', 'ñ': 'n', 'ý': 'y', 'ÿ': 'y',
  };

  String _normalize(String input) {
    final buffer = StringBuffer();
    for (final rune in input.toLowerCase().runes) {
      final ch = String.fromCharCode(rune);
      buffer.write(_diacriticsMap[ch] ?? ch);
    }
    return buffer.toString();
  }

  double _haversineDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);
}
