// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'LM+ Locator';

  @override
  String get emailTab => 'E-mail';

  @override
  String get phoneTab => 'Telefoon';

  @override
  String get loginTitle => 'Inloggen';

  @override
  String get registerTitle => 'Account aanmaken';

  @override
  String get emailLabel => 'E-mailadres';

  @override
  String get emailValidationError => 'Voer een geldig e-mailadres in.';

  @override
  String get passwordLabel => 'Wachtwoord';

  @override
  String get passwordValidationError =>
      'Wachtwoord moet minstens 6 tekens zijn.';

  @override
  String get registerButton => 'Registreren';

  @override
  String get toggleToLogin => 'Heb je al een account? Log in';

  @override
  String get toggleToRegister => 'Nog geen account? Registreer';

  @override
  String get authenticationFailed => 'Authenticatie mislukt.';

  @override
  String get phoneLoginTitle => 'Inloggen met telefoonnummer';

  @override
  String get phoneLabel => 'Telefoonnummer (bv. +32470123456)';

  @override
  String get phoneValidationError =>
      'Voer een geldig telefoonnummer in met landcode (+32...).';

  @override
  String get sendVerificationCode => 'Verstuur verificatiecode';

  @override
  String get verificationFailed => 'Verificatie mislukt.';

  @override
  String get verificationCodeTitle => 'Verificatiecode';

  @override
  String otpSentMessage(String phoneNumber) {
    return 'We hebben een code gestuurd naar $phoneNumber.';
  }

  @override
  String get verificationCodeLabel => 'Verificatiecode';

  @override
  String get verificationCodeValidationError => 'Voer de ontvangen code in.';

  @override
  String get confirmButton => 'Bevestigen';

  @override
  String get invalidVerificationCode => 'Ongeldige verificatiecode.';

  @override
  String get logoutTooltip => 'Uitloggen';

  @override
  String get locationPrivacyNotice =>
      'We gebruiken je locatie enkel om het dichtstbijzijnde kantoor te vinden. Je locatie wordt nooit opgeslagen of gedeeld.';

  @override
  String get findNearestOfficeButton =>
      'Vind mijn dichtstbijzijnde LM+ kantoor';

  @override
  String get locationPermissionDenied =>
      'Locatietoegang geweigerd. Geef toestemming in je instellingen om het dichtstbijzijnde kantoor te vinden.';

  @override
  String get openSettingsButton => 'Open instellingen';

  @override
  String get locationServiceDisabled =>
      'Locatieservices zijn uitgeschakeld. Zet GPS aan om verder te gaan.';

  @override
  String get openLocationSettingsButton => 'Open locatie-instellingen';

  @override
  String get genericErrorMessage =>
      'Er is iets misgegaan. Probeer het later opnieuw.';

  @override
  String distanceInKm(String distance) {
    return '$distance km';
  }
}
