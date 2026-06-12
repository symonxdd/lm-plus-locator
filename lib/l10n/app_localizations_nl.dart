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

  @override
  String yourLocationLabel(String address) {
    return 'Jouw locatie: $address';
  }

  @override
  String get languageMenuTooltip => 'Taal';

  @override
  String get languageSystemDefault => 'Systeemtaal';

  @override
  String get themeMenuTooltip => 'Thema';

  @override
  String get themeModeLight => 'Licht';

  @override
  String get themeModeDark => 'Donker';

  @override
  String get themeModeSystem => 'Systeemthema';

  @override
  String get authDisclaimer =>
      'Een account is niet nodig om de kantorenzoeker te gebruiken. Aanmelden is optioneel en biedt momenteel geen extra functies.';

  @override
  String get continueAsGuestButton => 'Doorgaan zonder account';

  @override
  String get openInMapsHint => 'Tik om te openen in Maps';

  @override
  String get headOfficeTooltip => 'Hoofdzetel';

  @override
  String get headOfficeTitle => 'LM+ hoofdzetel';

  @override
  String get countryBelgium => 'België';

  @override
  String get continueWithAccountButton => 'Doorgaan met account';

  @override
  String get logoutConfirmTitle => 'Uitloggen?';

  @override
  String get logoutConfirmMessage => 'Weet je zeker dat je wilt uitloggen?';

  @override
  String get cancelButton => 'Annuleren';
}
