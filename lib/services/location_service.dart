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
  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  /// Opens the app's system settings screen, e.g. so the user can grant
  /// location permission after denying it permanently.
  Future<bool> openAppSettings() => ph.openAppSettings();

  /// Opens the device's location (GPS) settings screen.
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}
