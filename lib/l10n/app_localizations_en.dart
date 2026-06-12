// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LM+ Locator';

  @override
  String get loginTitle => 'Log in';

  @override
  String get registerTitle => 'Create account';

  @override
  String get emailLabel => 'Email address';

  @override
  String get emailValidationError => 'Enter a valid email address.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordValidationError =>
      'Password must be at least 6 characters.';

  @override
  String get registerButton => 'Register';

  @override
  String get toggleToLogin => 'Already have an account? Log in';

  @override
  String get toggleToRegister => 'Don\'t have an account? Register';

  @override
  String get authenticationFailed => 'Authentication failed.';

  @override
  String get logoutTooltip => 'Log out';

  @override
  String get locationPrivacyNotice =>
      'We only use your location to find the nearest office. Your location is never stored or shared.';

  @override
  String get findNearestOfficeButton => 'Find my nearest LM+ office';

  @override
  String get locationPermissionDenied =>
      'Location access denied. Allow access in your settings to find the nearest office.';

  @override
  String get openSettingsButton => 'Open settings';

  @override
  String get locationServiceDisabled =>
      'Location services are turned off. Enable GPS to continue.';

  @override
  String get openLocationSettingsButton => 'Open location settings';

  @override
  String get genericErrorMessage =>
      'Something went wrong. Please try again later.';

  @override
  String distanceInKm(String distance) {
    return '$distance km';
  }

  @override
  String yourLocationLabel(String latitude, String longitude) {
    return 'Your location: $latitude, $longitude';
  }

  @override
  String get languageMenuTooltip => 'Language';

  @override
  String get languageSystemDefault => 'System language';

  @override
  String get authDisclaimer =>
      'Signing in is currently for testing and development purposes only, and isn\'t required to use the office locator.';

  @override
  String get continueAsGuestButton => 'Continue without an account';
}
