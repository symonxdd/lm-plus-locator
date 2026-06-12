// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'LM+ Locator';

  @override
  String get emailTab => 'E-Mail';

  @override
  String get phoneTab => 'Telefon';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get registerTitle => 'Konto erstellen';

  @override
  String get emailLabel => 'E-Mail-Adresse';

  @override
  String get emailValidationError =>
      'Bitte gib eine gültige E-Mail-Adresse ein.';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordValidationError =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get registerButton => 'Registrieren';

  @override
  String get toggleToLogin => 'Hast du schon ein Konto? Anmelden';

  @override
  String get toggleToRegister => 'Noch kein Konto? Registrieren';

  @override
  String get authenticationFailed => 'Authentifizierung fehlgeschlagen.';

  @override
  String get phoneLoginTitle => 'Mit Telefonnummer anmelden';

  @override
  String get phoneLabel => 'Telefonnummer (z. B. +32470123456)';

  @override
  String get phoneValidationError =>
      'Bitte gib eine gültige Telefonnummer mit Landesvorwahl ein (+32...).';

  @override
  String get sendVerificationCode => 'Bestätigungscode senden';

  @override
  String get verificationFailed => 'Verifizierung fehlgeschlagen.';

  @override
  String get verificationCodeTitle => 'Bestätigungscode';

  @override
  String otpSentMessage(String phoneNumber) {
    return 'Wir haben einen Code an $phoneNumber gesendet.';
  }

  @override
  String get verificationCodeLabel => 'Bestätigungscode';

  @override
  String get verificationCodeValidationError =>
      'Bitte gib den erhaltenen Code ein.';

  @override
  String get confirmButton => 'Bestätigen';

  @override
  String get invalidVerificationCode => 'Ungültiger Bestätigungscode.';

  @override
  String get logoutTooltip => 'Abmelden';

  @override
  String get locationPrivacyNotice =>
      'Wir verwenden deinen Standort nur, um das nächstgelegene Büro zu finden. Dein Standort wird niemals gespeichert oder weitergegeben.';

  @override
  String get findNearestOfficeButton => 'Nächstes LM+ Büro finden';

  @override
  String get locationPermissionDenied =>
      'Standortzugriff verweigert. Erlaube den Zugriff in den Einstellungen, um das nächstgelegene Büro zu finden.';

  @override
  String get openSettingsButton => 'Einstellungen öffnen';

  @override
  String get locationServiceDisabled =>
      'Standortdienste sind deaktiviert. Aktiviere GPS, um fortzufahren.';

  @override
  String get openLocationSettingsButton => 'Standorteinstellungen öffnen';

  @override
  String get genericErrorMessage =>
      'Etwas ist schiefgelaufen. Bitte versuche es später erneut.';

  @override
  String distanceInKm(String distance) {
    return '$distance km';
  }

  @override
  String get languageMenuTooltip => 'Sprache';

  @override
  String get languageSystemDefault => 'Systemsprache';
}
