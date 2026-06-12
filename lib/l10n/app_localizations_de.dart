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
  String yourLocationLabel(String latitude, String longitude) {
    return 'Dein Standort: $latitude, $longitude';
  }

  @override
  String get languageMenuTooltip => 'Sprache';

  @override
  String get languageSystemDefault => 'Systemsprache';

  @override
  String get authDisclaimer =>
      'Die Anmeldung dient derzeit nur Test- und Entwicklungszwecken und ist nicht erforderlich, um den Bürofinder zu nutzen.';

  @override
  String get continueAsGuestButton => 'Ohne Konto fortfahren';
}
