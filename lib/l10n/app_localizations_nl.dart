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
  String get appTagline => 'Vind snel het dichtstbijzijnde LM+ kantoor.';

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
  String get privacyNoticeTooltip => 'Privacyverklaring';

  @override
  String get privacyPolicyButton => 'Privacybeleid';

  @override
  String get findNearestOfficeButton => 'Mijn locatie gebruiken';

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
  String get themeMenuTooltip => 'Thema';

  @override
  String get themeModeLight => 'Licht';

  @override
  String get themeModeDark => 'Donker';

  @override
  String get themeModeSystem => 'Systeem';

  @override
  String get settingsTooltip => 'Instellingen';

  @override
  String get authDisclaimerIntro =>
      'Een account is niet nodig om de kantorenzoeker te gebruiken.';

  @override
  String get authDisclaimerSync =>
      'Aanmelden is optioneel; het synchroniseert je opgeslagen kantoren automatisch via al je apparaten.';

  @override
  String get unofficialAppNotice =>
      'Dit is een onafhankelijk project en is niet verbonden met LM+.';

  @override
  String get openInMapsHint => 'Tik om te openen in Maps';

  @override
  String get officeOpenNow => 'Nu open';

  @override
  String get officeClosedNow => 'Nu gesloten';

  @override
  String get officeTypeFilterOffices => 'Kantoren';

  @override
  String get officeTypeFilterMailboxes => 'Postpunten';

  @override
  String get headOfficeTooltip => 'Hoofdzetel';

  @override
  String get headOfficeTitle => 'LM+ hoofdzetel';

  @override
  String get countryBelgium => 'België';

  @override
  String get logoutConfirmTitle => 'Uitloggen?';

  @override
  String get logoutConfirmMessage => 'Weet je zeker dat je wilt uitloggen?';

  @override
  String get cancelButton => 'Annuleren';

  @override
  String get accountTooltip => 'Account';

  @override
  String accountSignedInAs(String email) {
    return 'Aangemeld als $email';
  }

  @override
  String get photoShareTooltip => 'Foto maken om te delen';

  @override
  String get photoRetakeButton => 'Opnieuw nemen';

  @override
  String get photoShareButton => 'Delen';

  @override
  String get photoShareSubject => 'Foto van LM+ Locator';

  @override
  String get locatorTabLabel => 'Locator';

  @override
  String get photoShareTabLabel => 'Foto delen';

  @override
  String get photoShareExperimentalNotice => 'Experimentele functie';

  @override
  String get searchByAddressButton => 'Of zoek op adres';

  @override
  String get addressSearchTitle => 'Zoek op adres';

  @override
  String get addressInputLabel => 'Adres';

  @override
  String get addressSearchSubmitButton => 'Zoeken';

  @override
  String get addressNotFoundError =>
      'Adres niet gevonden. Probeer een ander adres.';

  @override
  String get visitWebsiteButton => 'Bezoek website';

  @override
  String get addressSuggestionsAttribution =>
      'Adressuggesties via OpenStreetMap';

  @override
  String get deleteAccountButton => 'Account verwijderen';

  @override
  String get deleteAccountConfirmTitle => 'Account verwijderen?';

  @override
  String get deleteAccountConfirmMessage =>
      'Dit verwijdert je account permanent. Dit kan niet ongedaan worden gemaakt.';

  @override
  String get reauthenticateTitle => 'Bevestig je wachtwoord';

  @override
  String get reauthenticateMessage =>
      'Voer voor je veiligheid je wachtwoord opnieuw in om door te gaan.';

  @override
  String get reauthenticateButton => 'Bevestigen';

  @override
  String get invalidCredentialsError => 'Onjuist e-mailadres of wachtwoord.';

  @override
  String get emailAlreadyInUseError =>
      'Er bestaat al een account met dit e-mailadres.';

  @override
  String get weakPasswordError =>
      'Kies een sterker wachtwoord (minstens 6 tekens).';

  @override
  String get forgotPasswordButton => 'Wachtwoord vergeten?';

  @override
  String get passwordResetEmailSent =>
      'E-mail voor wachtwoordherstel verzonden. Controleer je inbox.';

  @override
  String get passwordRequiredError => 'Voer je wachtwoord in.';

  @override
  String accountIdLabel(String id) {
    return 'Account-ID: $id';
  }

  @override
  String accountCreatedLabel(String date) {
    return 'Lid sinds $date';
  }

  @override
  String get accountDeletedMessage => 'Account succesvol verwijderd.';

  @override
  String get networkErrorMessage =>
      'Geen internetverbinding. Controleer je verbinding en probeer opnieuw.';

  @override
  String get tooManyRequestsError =>
      'Te veel pogingen. Wacht even en probeer het opnieuw.';

  @override
  String get userDisabledError => 'Dit account is uitgeschakeld.';

  @override
  String get favoritesTabLabel => 'Opgeslagen';

  @override
  String get favoritesEmptyTitle => 'Geen opgeslagen kantoren';

  @override
  String get favoritesEmptySubtitle =>
      'Tik op het bladwijzerpictogram op een kantoor om het op te slaan.';

  @override
  String get favoriteAddTooltip => 'Kantoor opslaan';

  @override
  String get favoriteRemoveTooltip => 'Verwijder uit opgeslagen';

  @override
  String get favoritesSyncedNotice => 'Gesynchroniseerd met je account';

  @override
  String get favoritesSignInToSync =>
      'Log in om deze lijst op te slaan in je account';

  @override
  String get offlineBannerMessage => 'Offline — zoeken via GPS werkt nog';

  @override
  String get addressSearchOfflineError =>
      'Offline — enkel zoeken via GPS beschikbaar';

  @override
  String get openingHoursTitle => 'Openingsuren';

  @override
  String get openingHoursClosed => 'Gesloten';

  @override
  String get openingHoursTodayLabel => '(vandaag)';

  @override
  String get viewOpeningHoursHint => 'Openingsuren bekijken';

  @override
  String get messagesTabLabel => 'Berichten';

  @override
  String get chatInputHint => 'Typ een bericht...';

  @override
  String get chatSendTooltip => 'Verzenden';

  @override
  String get messagesDentalReimbursementTitle => 'Terugbetaling tandzorg';

  @override
  String get messagesAddressChangeTitle => 'Adreswijziging';

  @override
  String get messagesMembershipCardTitle => 'Lidkaart vervangen';

  @override
  String get messagesDentalReimbursementUserQuestion =>
      'Hallo, ik heb vorige week een aanvraag voor tandzorg ingediend — is er al nieuws over de terugbetaling?';

  @override
  String get messagesDentalReimbursementOfficeAck =>
      'Ik kijk dat even voor u na, een moment.';

  @override
  String get messagesDentalReimbursementOfficeApproved =>
      'Uw aanvraag is goedgekeurd. De terugbetaling wordt binnen 5 werkdagen overgeschreven.';

  @override
  String get messagesDentalReimbursementOfficeFollowup =>
      'Kan ik u nog ergens anders mee helpen?';

  @override
  String get messagesAddressChangeUserQuestion =>
      'Hallo, ik ben recent verhuisd — moet ik mijn adres zelf bij u laten aanpassen?';

  @override
  String get messagesAddressChangeOfficeReply =>
      'Dat is niet nodig — we hebben de wijziging automatisch ontvangen via het bevolkingsregister. Uw dossier is up-to-date.';

  @override
  String get messagesMembershipCardOfficeReminder =>
      'Herinnering: uw nieuwe lidkaart ligt klaar aan onze balie.';

  @override
  String get messagesCannedReply1 =>
      'Bedankt voor uw bericht! We nemen zo snel mogelijk contact met u op.';

  @override
  String get messagesCannedReply2 =>
      'Begrepen — iemand van ons team neemt binnenkort contact met u op.';

  @override
  String get messagesCannedReply3 =>
      'Bedankt voor uw bericht. We bekijken dit en reageren zo snel mogelijk.';
}
