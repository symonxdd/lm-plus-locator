import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// The result of checking/requesting location permission and GPS status.
enum LocationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
}

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

  /// Opens the app's system settings screen, e.g. so the user can grant
  /// location permission after denying it permanently.
  Future<bool> openAppSettings() => ph.openAppSettings();

  /// Opens the device's location (GPS) settings screen.
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}
