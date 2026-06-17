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
  String get appTagline => 'Quickly find the LM+ office closest to you.';

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
  String get privacyNoticeTooltip => 'Privacy notice';

  @override
  String get privacyPolicyButton => 'Privacy Policy';

  @override
  String get findNearestOfficeButton => 'Use my location';

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
  String yourLocationLabel(String address) {
    return 'Your location: $address';
  }

  @override
  String get languageMenuTooltip => 'Language';

  @override
  String get themeMenuTooltip => 'Theme';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeModeSystem => 'System';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get authDisclaimer =>
      'An account isn\'t needed to use the office locator. Signing in is optional; it backs up your saved offices and keeps them in sync across your devices.';

  @override
  String get unofficialAppNotice =>
      'This is an independent project and is not affiliated with LM+.';

  @override
  String get openInMapsHint => 'Tap to open in Maps';

  @override
  String get officeOpenNow => 'Open now';

  @override
  String get officeClosedNow => 'Closed now';

  @override
  String get officeTypeFilterOffices => 'Offices';

  @override
  String get officeTypeFilterMailboxes => 'Mailboxes';

  @override
  String get headOfficeTooltip => 'Head office';

  @override
  String get headOfficeTitle => 'LM+ head office';

  @override
  String get countryBelgium => 'Belgium';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get accountTooltip => 'Account';

  @override
  String accountSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get photoShareTooltip => 'Take a photo to share';

  @override
  String get photoRetakeButton => 'Retake';

  @override
  String get photoShareButton => 'Share';

  @override
  String get photoShareSubject => 'Photo from LM+ Locator';

  @override
  String get locatorTabLabel => 'Locator';

  @override
  String get photoShareTabLabel => 'Share photo';

  @override
  String get photoShareExperimentalNotice => 'Experimental feature';

  @override
  String get searchByAddressButton => 'Or search by address';

  @override
  String get addressSearchTitle => 'Search by address';

  @override
  String get addressInputLabel => 'Address';

  @override
  String get addressSearchSubmitButton => 'Search';

  @override
  String get addressNotFoundError =>
      'Address not found. Try a different address.';

  @override
  String get visitWebsiteButton => 'Visit website';

  @override
  String get changeLocationButton => 'Choose a different location';

  @override
  String get addressSuggestionsAttribution =>
      'Address suggestions via OpenStreetMap';

  @override
  String get deleteAccountButton => 'Delete account';

  @override
  String get deleteAccountConfirmTitle => 'Delete account?';

  @override
  String get deleteAccountConfirmMessage =>
      'This permanently deletes your account. This can\'t be undone.';

  @override
  String get reauthenticateTitle => 'Confirm your password';

  @override
  String get reauthenticateMessage =>
      'For your security, please re-enter your password to continue.';

  @override
  String get reauthenticateButton => 'Confirm';

  @override
  String get invalidCredentialsError => 'Incorrect email or password.';

  @override
  String get emailAlreadyInUseError =>
      'An account with this email already exists.';

  @override
  String get weakPasswordError =>
      'Choose a stronger password (at least 6 characters).';

  @override
  String get forgotPasswordButton => 'Forgot password?';

  @override
  String get passwordResetEmailSent =>
      'Password reset email sent. Check your inbox.';

  @override
  String get passwordRequiredError => 'Please enter your password.';

  @override
  String accountIdLabel(String id) {
    return 'Account ID: $id';
  }

  @override
  String accountCreatedLabel(String date) {
    return 'Member since $date';
  }

  @override
  String get accountDeletedMessage => 'Account deleted successfully.';

  @override
  String get favoritesTabLabel => 'Saved';

  @override
  String get favoritesEmptyTitle => 'No saved offices';

  @override
  String get favoritesEmptySubtitle =>
      'Tap the bookmark on any office card to save it.';

  @override
  String get favoriteAddTooltip => 'Save office';

  @override
  String get favoriteRemoveTooltip => 'Remove from saved';

  @override
  String get favoritesSyncedNotice => 'Synced to your account';

  @override
  String get favoritesSignInToSync => 'Sign in to sync across devices';

  @override
  String get offlineBannerMessage => 'Offline — GPS search still works';

  @override
  String get addressSearchOfflineError => 'Offline — only GPS search available';

  @override
  String get openingHoursTitle => 'Opening hours';

  @override
  String get openingHoursClosed => 'Closed';

  @override
  String get openingHoursTodayLabel => '(today)';

  @override
  String get viewOpeningHoursHint => 'View opening hours';
}
