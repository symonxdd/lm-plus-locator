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
  String get appTagline => 'Finde schnell das nächstgelegene LM+ Büro.';

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
  String get privacyNoticeTooltip => 'Datenschutzhinweis';

  @override
  String get privacyPolicyButton => 'Datenschutzerklärung';

  @override
  String get findNearestOfficeButton => 'Meinen Standort verwenden';

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
  String yourLocationLabel(String address) {
    return 'Dein Standort: $address';
  }

  @override
  String get languageMenuTooltip => 'Sprache';

  @override
  String get themeMenuTooltip => 'Design';

  @override
  String get themeModeLight => 'Hell';

  @override
  String get themeModeDark => 'Dunkel';

  @override
  String get themeModeSystem => 'System';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get authDisclaimer =>
      'Für die Nutzung des Bürofinders ist kein Konto erforderlich. Die Anmeldung ist optional und schaltet derzeit keine zusätzlichen Funktionen frei.';

  @override
  String get unofficialAppNotice =>
      'Dies ist ein unabhängiges Projekt und steht in keiner Verbindung zu LM+.';

  @override
  String get openInMapsHint => 'Tippen, um in Maps zu öffnen';

  @override
  String get officeOpenNow => 'Jetzt geöffnet';

  @override
  String get officeClosedNow => 'Jetzt geschlossen';

  @override
  String get officeTypeFilterOffices => 'Büros';

  @override
  String get officeTypeFilterMailboxes => 'Briefkästen';

  @override
  String get headOfficeTooltip => 'Hauptsitz';

  @override
  String get headOfficeTitle => 'LM+ Hauptsitz';

  @override
  String get countryBelgium => 'Belgien';

  @override
  String get logoutConfirmTitle => 'Abmelden?';

  @override
  String get logoutConfirmMessage => 'Möchtest du dich wirklich abmelden?';

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get accountTooltip => 'Konto';

  @override
  String accountSignedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String get photoShareTooltip => 'Foto zum Teilen aufnehmen';

  @override
  String get photoRetakeButton => 'Erneut aufnehmen';

  @override
  String get photoShareButton => 'Teilen';

  @override
  String get photoShareSubject => 'Foto von LM+ Locator';

  @override
  String get locatorTabLabel => 'Locator';

  @override
  String get photoShareTabLabel => 'Foto teilen';

  @override
  String get photoShareExperimentalNotice => 'Experimentelle Funktion';

  @override
  String get searchByAddressButton => 'Oder nach Adresse suchen';

  @override
  String get addressSearchTitle => 'Adresssuche';

  @override
  String get addressInputLabel => 'Adresse';

  @override
  String get addressSearchSubmitButton => 'Suchen';

  @override
  String get addressNotFoundError =>
      'Adresse nicht gefunden. Versuche eine andere Adresse.';

  @override
  String get visitWebsiteButton => 'Website besuchen';

  @override
  String get changeLocationButton => 'Anderen Standort wählen';

  @override
  String get addressSuggestionsAttribution =>
      'Adressvorschläge via OpenStreetMap';

  @override
  String get deleteAccountButton => 'Konto löschen';

  @override
  String get deleteAccountConfirmTitle => 'Konto löschen?';

  @override
  String get deleteAccountConfirmMessage =>
      'Dadurch wird dein Konto dauerhaft gelöscht. Dies kann nicht widerrufen werden.';

  @override
  String get reauthenticateTitle => 'Passwort bestätigen';

  @override
  String get reauthenticateMessage =>
      'Bitte gib aus Sicherheitsgründen dein Passwort erneut ein, um fortzufahren.';

  @override
  String get reauthenticateButton => 'Bestätigen';

  @override
  String get invalidCredentialsError =>
      'E-Mail-Adresse oder Passwort ist falsch.';

  @override
  String get emailAlreadyInUseError =>
      'Es existiert bereits ein Konto mit dieser E-Mail-Adresse.';

  @override
  String get weakPasswordError =>
      'Wähle ein stärkeres Passwort (mindestens 6 Zeichen).';

  @override
  String get forgotPasswordButton => 'Passwort vergessen?';

  @override
  String get passwordResetEmailSent =>
      'E-Mail zum Zurücksetzen des Passworts wurde gesendet. Überprüfe dein Postfach.';

  @override
  String get passwordRequiredError => 'Bitte gib dein Passwort ein.';

  @override
  String accountIdLabel(String id) {
    return 'Konto-ID: $id';
  }

  @override
  String accountCreatedLabel(String date) {
    return 'Mitglied seit $date';
  }

  @override
  String get accountDeletedMessage => 'Konto erfolgreich gelöscht.';

  @override
  String get offlineBannerMessage => 'Kein Internet — Büroliste noch verfügbar';
}
