import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart' as ph;

import '../models/address_suggestion.dart';

/// The result of checking/requesting location permission and GPS status.
enum LocationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
}

/// Nominatim address types broader than a municipality, excluded from
/// address suggestions since they aren't useful search locations.
const _excludedAddressTypes = {
  'county',
  'state_district',
  'state',
  'region',
  'country',
  'continent',
};

/// Wraps geolocator + permission_handler to provide a single, exhaustive
/// permission check and the user's current position.
class LocationService {
  /// Checks GPS service availability and location permission, requesting
  /// permission if needed. Never throws.
  Future<LocationPermissionStatus> checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.permanentlyDenied;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationPermissionStatus.granted;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }

  /// Returns the device's current position. Only call after [checkPermission]
  /// returns [LocationPermissionStatus.granted].
  ///
  /// Uses [LocationAccuracy.medium] rather than `.high`: finding the nearest
  /// office doesn't need GPS-grade precision, and medium accuracy returns a
  /// fix noticeably faster (often via network/cell positioning).
  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  }

  /// Returns the last cached position, if any, without waiting for a fresh
  /// fix. Used to show approximate results instantly while a fresh fix is
  /// obtained via [getCurrentPosition]. Only call after [checkPermission]
  /// returns [LocationPermissionStatus.granted].
  Future<Position?> getLastKnownPosition() => Geolocator.getLastKnownPosition();

  /// Resolves (lat, lng) to a human-readable address without a house number
  /// (e.g. "Bellemstraat, 9880 Aalter"), since reverse geocoding can be off
  /// by a house or two. Returns `null` if reverse geocoding fails or returns
  /// nothing.
  Future<String?> reverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;

      final placemark = placemarks.first;
      final street = [
        placemark.thoroughfare,
        placemark.street?.replaceAll(RegExp(r'\s*\d+\S*\s*$'), ''),
      ].firstWhere((s) => s != null && s.isNotEmpty, orElse: () => null);
      final cityLine = [
        placemark.postalCode,
        placemark.locality,
      ].where((s) => s != null && s.isNotEmpty).join(' ');

      final parts = [
        street,
        cityLine,
      ].where((s) => s != null && s.isNotEmpty);
      if (parts.isEmpty) return null;

      return parts.join(', ');
    } catch (_) {
      return null;
    }
  }

  /// Resolves a free-text address to coordinates, e.g. for users who don't
  /// want to grant location access. Returns `null` if the address can't be
  /// resolved.
  Future<Location?> geocodeAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      return locations.isEmpty ? null : locations.first;
    } catch (_) {
      return null;
    }
  }

  /// Looks up live address suggestions for [query] as the user types, using
  /// the free OpenStreetMap Nominatim search API. Returns an empty list for
  /// short queries or if the request fails.
  Future<List<AddressSuggestion>> suggestAddresses(
    String query, {
    String? languageCode,
  }) async {
    if (query.trim().length < 3) return [];

    // LM+ offices are all in Belgium, so restrict suggestions accordingly -
    // without this, Nominatim happily suggests same-named places abroad
    // (e.g. searching "Alken" also returns hits in Germany, Denmark, Poland).
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'jsonv2',
      'addressdetails': '1',
      'limit': '8',
      'countrycodes': 'be',
    });

    try {
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'LM+ Locator (Flutter app)',
          'Accept-Language': ?languageCode,
        },
      );
      if (response.statusCode != 200) return [];

      final results = (jsonDecode(response.body) as List<dynamic>)
          .cast<Map<String, dynamic>>();

      final suggestions = <AddressSuggestion>[];
      final seenLabels = <String>{};
      for (final map in results) {
        // Administrative areas broader than a municipality (counties,
        // provinces, states, countries) aren't useful search locations and
        // can shadow a city/town result under the same name - e.g.
        // searching "Gent" also returns the "Gent" arrondissement, a
        // county-sized area whose centre is ~6km from the city itself.
        if (_excludedAddressTypes.contains(map['addresstype'])) continue;

        final lat = double.tryParse(map['lat'] as String? ?? '');
        final lon = double.tryParse(map['lon'] as String? ?? '');
        if (lat == null || lon == null) continue;

        final address = map['address'] as Map<String, dynamic>? ?? {};
        final name = map['name'] as String? ?? address['road'] as String?;
        if (name == null) continue;

        final locality = address['city'] as String? ??
            address['town'] as String? ??
            address['village'] as String? ??
            address['municipality'] as String?;
        final country = address['country'] as String?;

        final labelParts = <String>{
          name,
          ?locality,
          ?country,
        };
        final displayName = labelParts.join(', ');

        if (!seenLabels.add(displayName)) continue;
        suggestions.add(AddressSuggestion(
          displayName: displayName,
          latitude: lat,
          longitude: lon,
        ));
        if (suggestions.length >= 5) break;
      }
      return suggestions;
    } catch (_) {
      return [];
    }
  }

  /// Opens the app's system settings screen, e.g. so the user can grant
  /// location permission after denying it permanently.
  Future<bool> openAppSettings() => ph.openAppSettings();

  /// Opens the device's location (GPS) settings screen.
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}
