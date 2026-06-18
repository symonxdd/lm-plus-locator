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

  /// Short tagline shown on the home screen explaining what the app does.
  ///
  /// In nl, this message translates to:
  /// **'Vind snel het dichtstbijzijnde LM+ kantoor.'**
  String get appTagline;

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

  /// Tooltip for the button that shows the location privacy notice.
  ///
  /// In nl, this message translates to:
  /// **'Privacyverklaring'**
  String get privacyNoticeTooltip;

  /// Settings sheet item that opens the full hosted privacy policy in the browser.
  ///
  /// In nl, this message translates to:
  /// **'Privacybeleid'**
  String get privacyPolicyButton;

  /// Label of the button that starts the nearest-office search.
  ///
  /// In nl, this message translates to:
  /// **'Mijn locatie gebruiken'**
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

  /// Shows the user's current location (address, or coordinates as fallback) after a search.
  ///
  /// In nl, this message translates to:
  /// **'Jouw locatie: {address}'**
  String yourLocationLabel(String address);

  /// Tooltip for the app bar button that opens the language picker.
  ///
  /// In nl, this message translates to:
  /// **'Taal'**
  String get languageMenuTooltip;

  /// Tooltip for the app bar button that opens the theme picker, and the title of that picker's sheet.
  ///
  /// In nl, this message translates to:
  /// **'Thema'**
  String get themeMenuTooltip;

  /// Option in the theme picker for the light theme.
  ///
  /// In nl, this message translates to:
  /// **'Licht'**
  String get themeModeLight;

  /// Option in the theme picker for the dark theme.
  ///
  /// In nl, this message translates to:
  /// **'Donker'**
  String get themeModeDark;

  /// Option in the theme picker that follows the device theme.
  ///
  /// In nl, this message translates to:
  /// **'Systeem'**
  String get themeModeSystem;

  /// Tooltip for the app bar button that opens the combined theme and language settings sheet.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get settingsTooltip;

  /// First line of the small print in the account sheet: an account is not required to use the locator.
  ///
  /// In nl, this message translates to:
  /// **'Een account is niet nodig om de kantorenzoeker te gebruiken.'**
  String get authDisclaimerIntro;

  /// Second line of the small print in the account sheet: what signing in actually enables (cloud sync of saved offices).
  ///
  /// In nl, this message translates to:
  /// **'Aanmelden is optioneel; het synchroniseert je opgeslagen kantoren automatisch via al je apparaten.'**
  String get authDisclaimerSync;

  /// Small print in the settings sheet clarifying that this is an unofficial, independent app and not an official LM+ product.
  ///
  /// In nl, this message translates to:
  /// **'Dit is een onafhankelijk project en is niet verbonden met LM+.'**
  String get unofficialAppNotice;

  /// Small hint on each office card explaining that tapping it opens the location in a maps app.
  ///
  /// In nl, this message translates to:
  /// **'Tik om te openen in Maps'**
  String get openInMapsHint;

  /// Badge shown on an office card when the office is currently open.
  ///
  /// In nl, this message translates to:
  /// **'Nu open'**
  String get officeOpenNow;

  /// Badge shown on an office card when the office is currently closed.
  ///
  /// In nl, this message translates to:
  /// **'Nu gesloten'**
  String get officeClosedNow;

  /// Filter option showing only full offices (with opening hours).
  ///
  /// In nl, this message translates to:
  /// **'Kantoren'**
  String get officeTypeFilterOffices;

  /// Filter option showing only mailbox/drop-off locations.
  ///
  /// In nl, this message translates to:
  /// **'Postpunten'**
  String get officeTypeFilterMailboxes;

  /// Tooltip for the app bar button that shows the head office info sheet.
  ///
  /// In nl, this message translates to:
  /// **'Hoofdzetel'**
  String get headOfficeTooltip;

  /// Title of the head office info sheet.
  ///
  /// In nl, this message translates to:
  /// **'LM+ hoofdzetel'**
  String get headOfficeTitle;

  /// The country name shown after the head office's postal code and city.
  ///
  /// In nl, this message translates to:
  /// **'België'**
  String get countryBelgium;

  /// Title of the confirmation dialog shown when the user taps the logout button.
  ///
  /// In nl, this message translates to:
  /// **'Uitloggen?'**
  String get logoutConfirmTitle;

  /// Message body of the logout confirmation dialog.
  ///
  /// In nl, this message translates to:
  /// **'Weet je zeker dat je wilt uitloggen?'**
  String get logoutConfirmMessage;

  /// Generic label for a button that cancels/dismisses a dialog.
  ///
  /// In nl, this message translates to:
  /// **'Annuleren'**
  String get cancelButton;

  /// Label for the settings entry that opens the account sheet, and the heading of that sheet when signed in.
  ///
  /// In nl, this message translates to:
  /// **'Account'**
  String get accountTooltip;

  /// Shown in the account sheet when the user is signed in, displaying their email address.
  ///
  /// In nl, this message translates to:
  /// **'Aangemeld als {email}'**
  String accountSignedInAs(String email);

  /// Tooltip for the app bar button that opens the photo capture screen.
  ///
  /// In nl, this message translates to:
  /// **'Foto maken om te delen'**
  String get photoShareTooltip;

  /// Button label to discard the current photo and take a new one.
  ///
  /// In nl, this message translates to:
  /// **'Opnieuw nemen'**
  String get photoRetakeButton;

  /// Button label to share the captured photo via the OS share sheet.
  ///
  /// In nl, this message translates to:
  /// **'Delen'**
  String get photoShareButton;

  /// Subject line pre-filled when sharing a photo, e.g. via email.
  ///
  /// In nl, this message translates to:
  /// **'Foto van LM+ Locator'**
  String get photoShareSubject;

  /// Label of the bottom navigation tab for the office locator.
  ///
  /// In nl, this message translates to:
  /// **'Locator'**
  String get locatorTabLabel;

  /// Label of the bottom navigation tab for the photo-share feature.
  ///
  /// In nl, this message translates to:
  /// **'Foto delen'**
  String get photoShareTabLabel;

  /// Small print on the photo-share screen noting that the feature is experimental.
  ///
  /// In nl, this message translates to:
  /// **'Experimentele functie'**
  String get photoShareExperimentalNotice;

  /// Button on the home screen that opens the address search sheet, as an alternative to using GPS location.
  ///
  /// In nl, this message translates to:
  /// **'Of zoek op adres'**
  String get searchByAddressButton;

  /// Title of the address search bottom sheet.
  ///
  /// In nl, this message translates to:
  /// **'Zoek op adres'**
  String get addressSearchTitle;

  /// Label for the address text field in the address search sheet.
  ///
  /// In nl, this message translates to:
  /// **'Adres'**
  String get addressInputLabel;

  /// Submit button label in the address search sheet.
  ///
  /// In nl, this message translates to:
  /// **'Zoeken'**
  String get addressSearchSubmitButton;

  /// Error shown in the address search sheet when the entered address can't be resolved.
  ///
  /// In nl, this message translates to:
  /// **'Adres niet gevonden. Probeer een ander adres.'**
  String get addressNotFoundError;

  /// Button in the head office info sheet that opens the organization's website in the browser.
  ///
  /// In nl, this message translates to:
  /// **'Bezoek website'**
  String get visitWebsiteButton;

  /// Attribution link shown below address suggestions, linking to the OpenStreetMap copyright/license page.
  ///
  /// In nl, this message translates to:
  /// **'Adressuggesties via OpenStreetMap'**
  String get addressSuggestionsAttribution;

  /// Button to permanently delete the signed-in user's account.
  ///
  /// In nl, this message translates to:
  /// **'Account verwijderen'**
  String get deleteAccountButton;

  /// Title of the confirmation dialog before permanently deleting the account.
  ///
  /// In nl, this message translates to:
  /// **'Account verwijderen?'**
  String get deleteAccountConfirmTitle;

  /// Body text of the confirmation dialog before permanently deleting the account.
  ///
  /// In nl, this message translates to:
  /// **'Dit verwijdert je account permanent. Dit kan niet ongedaan worden gemaakt.'**
  String get deleteAccountConfirmMessage;

  /// Title of the dialog asking the user to re-enter their password before a sensitive action like account deletion.
  ///
  /// In nl, this message translates to:
  /// **'Bevestig je wachtwoord'**
  String get reauthenticateTitle;

  /// Explanatory text in the re-authentication dialog.
  ///
  /// In nl, this message translates to:
  /// **'Voer voor je veiligheid je wachtwoord opnieuw in om door te gaan.'**
  String get reauthenticateMessage;

  /// Confirm button in the re-authentication dialog.
  ///
  /// In nl, this message translates to:
  /// **'Bevestigen'**
  String get reauthenticateButton;

  /// Shown when sign-in fails because the email and/or password is incorrect or the account doesn't exist. Deliberately generic for security (doesn't reveal which one is wrong).
  ///
  /// In nl, this message translates to:
  /// **'Onjuist e-mailadres of wachtwoord.'**
  String get invalidCredentialsError;

  /// Shown when registration fails because an account with this email already exists.
  ///
  /// In nl, this message translates to:
  /// **'Er bestaat al een account met dit e-mailadres.'**
  String get emailAlreadyInUseError;

  /// Shown when registration fails because the password is too weak.
  ///
  /// In nl, this message translates to:
  /// **'Kies een sterker wachtwoord (minstens 6 tekens).'**
  String get weakPasswordError;

  /// Button in the login form that sends a password reset email.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord vergeten?'**
  String get forgotPasswordButton;

  /// Confirmation shown after a password reset email was sent successfully.
  ///
  /// In nl, this message translates to:
  /// **'E-mail voor wachtwoordherstel verzonden. Controleer je inbox.'**
  String get passwordResetEmailSent;

  /// Validation message shown in the re-authentication dialog when the password field is left empty.
  ///
  /// In nl, this message translates to:
  /// **'Voer je wachtwoord in.'**
  String get passwordRequiredError;

  /// Shows the signed-in user's Firebase account ID (UID), useful for support requests.
  ///
  /// In nl, this message translates to:
  /// **'Account-ID: {id}'**
  String accountIdLabel(String id);

  /// Shows the date the signed-in account was created.
  ///
  /// In nl, this message translates to:
  /// **'Lid sinds {date}'**
  String accountCreatedLabel(String date);

  /// Confirmation shown on the login form after the user successfully deletes their account.
  ///
  /// In nl, this message translates to:
  /// **'Account succesvol verwijderd.'**
  String get accountDeletedMessage;

  /// Shown when a Firebase Auth call fails because there is no network connection.
  ///
  /// In nl, this message translates to:
  /// **'Geen internetverbinding. Controleer je verbinding en probeer opnieuw.'**
  String get networkErrorMessage;

  /// Shown when Firebase Auth rate-limits the user after too many failed sign-in attempts.
  ///
  /// In nl, this message translates to:
  /// **'Te veel pogingen. Wacht even en probeer het opnieuw.'**
  String get tooManyRequestsError;

  /// Shown when the user tries to sign in to an account that has been disabled in Firebase Console.
  ///
  /// In nl, this message translates to:
  /// **'Dit account is uitgeschakeld.'**
  String get userDisabledError;

  /// Label of the bottom navigation tab that shows the user's saved (favourite) offices.
  ///
  /// In nl, this message translates to:
  /// **'Opgeslagen'**
  String get favoritesTabLabel;

  /// Heading shown on the Saved tab when the user has not yet saved any offices.
  ///
  /// In nl, this message translates to:
  /// **'Geen opgeslagen kantoren'**
  String get favoritesEmptyTitle;

  /// Supporting text under the empty-state heading on the Saved tab, explaining how to save an office.
  ///
  /// In nl, this message translates to:
  /// **'Tik op het bladwijzerpictogram op een kantoor om het op te slaan.'**
  String get favoritesEmptySubtitle;

  /// Tooltip for the bookmark button on an office card when the office is not yet saved.
  ///
  /// In nl, this message translates to:
  /// **'Kantoor opslaan'**
  String get favoriteAddTooltip;

  /// Tooltip for the bookmark button on an office card when the office is already saved.
  ///
  /// In nl, this message translates to:
  /// **'Verwijder uit opgeslagen'**
  String get favoriteRemoveTooltip;

  /// Pill-shaped notice on the Saved tab when the user is signed in, confirming that saved offices sync to their cloud account.
  ///
  /// In nl, this message translates to:
  /// **'Gesynchroniseerd met je account'**
  String get favoritesSyncedNotice;

  /// Pill-shaped notice on the Saved tab when the user is signed out, prompting them to sign in to enable cloud sync. Tapping it opens the account sheet.
  ///
  /// In nl, this message translates to:
  /// **'Log in om deze lijst op te slaan in je account'**
  String get favoritesSignInToSync;

  /// Thin banner shown at the top of the screen when the device has no internet connection. Reassures the user that GPS-based office search still works offline.
  ///
  /// In nl, this message translates to:
  /// **'Offline — zoeken via GPS werkt nog'**
  String get offlineBannerMessage;

  /// Error shown on the address search field when the user tries to search by address while offline. Directs them to use GPS instead.
  ///
  /// In nl, this message translates to:
  /// **'Offline — enkel zoeken via GPS beschikbaar'**
  String get addressSearchOfflineError;

  /// Title of the bottom sheet that shows the full weekly opening hours for an office.
  ///
  /// In nl, this message translates to:
  /// **'Openingsuren'**
  String get openingHoursTitle;

  /// Shown in the opening hours table for a weekday on which the office is closed all day.
  ///
  /// In nl, this message translates to:
  /// **'Gesloten'**
  String get openingHoursClosed;

  /// Short label appended to the current weekday row in the opening hours table to highlight it.
  ///
  /// In nl, this message translates to:
  /// **'(vandaag)'**
  String get openingHoursTodayLabel;

  /// Label on the button inside an office card that opens the full opening hours sheet.
  ///
  /// In nl, this message translates to:
  /// **'Openingsuren bekijken'**
  String get viewOpeningHoursHint;

  /// Label of the bottom navigation tab for the messaging feature.
  ///
  /// In nl, this message translates to:
  /// **'Berichten'**
  String get messagesTabLabel;

  /// Placeholder text in the message input field on the chat screen.
  ///
  /// In nl, this message translates to:
  /// **'Typ een bericht...'**
  String get chatInputHint;

  /// Tooltip for the send button on the chat screen.
  ///
  /// In nl, this message translates to:
  /// **'Verzenden'**
  String get chatSendTooltip;
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
