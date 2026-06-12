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
  String get emailTab => 'Email';

  @override
  String get phoneTab => 'Phone';

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
  String get phoneLoginTitle => 'Log in with phone number';

  @override
  String get phoneLabel => 'Phone number (e.g. +32470123456)';

  @override
  String get phoneValidationError =>
      'Enter a valid phone number with country code (+32...).';

  @override
  String get sendVerificationCode => 'Send verification code';

  @override
  String get verificationFailed => 'Verification failed.';

  @override
  String get verificationCodeTitle => 'Verification code';

  @override
  String otpSentMessage(String phoneNumber) {
    return 'We\'ve sent a code to $phoneNumber.';
  }

  @override
  String get verificationCodeLabel => 'Verification code';

  @override
  String get verificationCodeValidationError => 'Enter the code you received.';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get invalidVerificationCode => 'Invalid verification code.';

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
}
