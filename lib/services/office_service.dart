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

  /// Returns the [count] offices nearest to (userLat, userLng), sorted by
  /// ascending distance, using the Haversine formula.
  List<OfficeWithDistance> nearestOffices({
    required List<Office> offices,
    required double userLat,
    required double userLng,
    int count = 5,
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

    withDistance.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return withDistance.take(count).toList();
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
