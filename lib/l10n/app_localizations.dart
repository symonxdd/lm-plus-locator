import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('nl'),
  ];

  /// The application title shown in the app bar.
  ///
  /// In nl, this message translates to:
  /// **'LM+ Locator'**
  String get appTitle;

  /// Tab label for email/password authentication.
  ///
  /// In nl, this message translates to:
  /// **'E-mail'**
  String get emailTab;

  /// Tab label for phone (OTP) authentication.
  ///
  /// In nl, this message translates to:
  /// **'Telefoon'**
  String get phoneTab;

  /// Heading shown on the email form in login mode, and the login button label.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get loginTitle;

  /// Heading shown on the email form in register mode.
  ///
  /// In nl, this message translates to:
  /// **'Account aanmaken'**
  String get registerTitle;

  /// Label for the email text field.
  ///
  /// In nl, this message translates to:
  /// **'E-mailadres'**
  String get emailLabel;

  /// Validation message when the email field is empty or invalid.
  ///
  /// In nl, this message translates to:
  /// **'Voer een geldig e-mailadres in.'**
  String get emailValidationError;

  /// Label for the password text field.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord'**
  String get passwordLabel;

  /// Validation message when the password is too short.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord moet minstens 6 tekens zijn.'**
  String get passwordValidationError;

  /// Submit button label in register mode.
  ///
  /// In nl, this message translates to:
  /// **'Registreren'**
  String get registerButton;

  /// Link shown in register mode to switch to login mode.
  ///
  /// In nl, this message translates to:
  /// **'Heb je al een account? Log in'**
  String get toggleToLogin;

  /// Link shown in login mode to switch to register mode.
  ///
  /// In nl, this message translates to:
  /// **'Nog geen account? Registreer'**
  String get toggleToRegister;

  /// Fallback error message when email/password authentication fails.
  ///
  /// In nl, this message translates to:
  /// **'Authenticatie mislukt.'**
  String get authenticationFailed;

  /// Heading shown on the phone authentication form.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen met telefoonnummer'**
  String get phoneLoginTitle;

  /// Label for the phone number text field.
  ///
  /// In nl, this message translates to:
  /// **'Telefoonnummer (bv. +32470123456)'**
  String get phoneLabel;

  /// Validation message when the phone number is empty or missing a country code.
  ///
  /// In nl, this message translates to:
  /// **'Voer een geldig telefoonnummer in met landcode (+32...).'**
  String get phoneValidationError;

  /// Submit button label on the phone authentication form.
  ///
  /// In nl, this message translates to:
  /// **'Verstuur verificatiecode'**
  String get sendVerificationCode;

  /// Fallback error message when sending the SMS verification code fails.
  ///
  /// In nl, this message translates to:
  /// **'Verificatie mislukt.'**
  String get verificationFailed;

  /// App bar title on the OTP screen.
  ///
  /// In nl, this message translates to:
  /// **'Verificatiecode'**
  String get verificationCodeTitle;

  /// Message shown on the OTP screen, including the phone number the code was sent to.
  ///
  /// In nl, this message translates to:
  /// **'We hebben een code gestuurd naar {phoneNumber}.'**
  String otpSentMessage(String phoneNumber);

  /// Label for the OTP code text field.
  ///
  /// In nl, this message translates to:
  /// **'Verificatiecode'**
  String get verificationCodeLabel;

  /// Validation message when the OTP code field is empty or too short.
  ///
  /// In nl, this message translates to:
  /// **'Voer de ontvangen code in.'**
  String get verificationCodeValidationError;

  /// Submit button label on the OTP screen.
  ///
  /// In nl, this message translates to:
  /// **'Bevestigen'**
  String get confirmButton;

  /// Fallback error message when the OTP code is incorrect.
  ///
  /// In nl, this message translates to:
  /// **'Ongeldige verificatiecode.'**
  String get invalidVerificationCode;

  /// Tooltip for the logout button on the home screen.
  ///
  /// In nl, this message translates to:
  /// **'Uitloggen'**
  String get logoutTooltip;

  /// Privacy notice shown before requesting GPS location.
  ///
  /// In nl, this message translates to:
  /// **'We gebruiken je locatie enkel om het dichtstbijzijnde kantoor te vinden. Je locatie wordt nooit opgeslagen of gedeeld.'**
  String get locationPrivacyNotice;

  /// Label of the button that starts the nearest-office search.
  ///
  /// In nl, this message translates to:
  /// **'Vind mijn dichtstbijzijnde LM+ kantoor'**
  String get findNearestOfficeButton;

  /// Message shown when location permission was denied or permanently denied.
  ///
  /// In nl, this message translates to:
  /// **'Locatietoegang geweigerd. Geef toestemming in je instellingen om het dichtstbijzijnde kantoor te vinden.'**
  String get locationPermissionDenied;

  /// Button label that opens the app's system settings.
  ///
  /// In nl, this message translates to:
  /// **'Open instellingen'**
  String get openSettingsButton;

  /// Message shown when GPS/location services are turned off.
  ///
  /// In nl, this message translates to:
  /// **'Locatieservices zijn uitgeschakeld. Zet GPS aan om verder te gaan.'**
  String get locationServiceDisabled;

  /// Button label that opens the device's location settings.
  ///
  /// In nl, this message translates to:
  /// **'Open locatie-instellingen'**
  String get openLocationSettingsButton;

  /// Generic error message shown when finding the nearest office fails unexpectedly.
  ///
  /// In nl, this message translates to:
  /// **'Er is iets misgegaan. Probeer het later opnieuw.'**
  String get genericErrorMessage;

  /// Distance to an office, formatted to one decimal place by the caller.
  ///
  /// In nl, this message translates to:
  /// **'{distance} km'**
  String distanceInKm(String distance);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
