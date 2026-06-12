// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LM+ Locator';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get emailLabel => 'Adresse e-mail';

  @override
  String get emailValidationError =>
      'Veuillez saisir une adresse e-mail valide.';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordValidationError =>
      'Le mot de passe doit contenir au moins 6 caractères.';

  @override
  String get registerButton => 'S\'inscrire';

  @override
  String get toggleToLogin => 'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get toggleToRegister => 'Pas encore de compte ? Inscrivez-vous';

  @override
  String get authenticationFailed => 'Authentification échouée.';

  @override
  String get logoutTooltip => 'Se déconnecter';

  @override
  String get locationPrivacyNotice =>
      'Nous utilisons votre position uniquement pour trouver le bureau le plus proche. Votre position n\'est jamais enregistrée ni partagée.';

  @override
  String get findNearestOfficeButton => 'Trouver le bureau LM+ le plus proche';

  @override
  String get locationPermissionDenied =>
      'Accès à la position refusé. Autorisez l\'accès dans vos paramètres pour trouver le bureau le plus proche.';

  @override
  String get openSettingsButton => 'Ouvrir les paramètres';

  @override
  String get locationServiceDisabled =>
      'Les services de localisation sont désactivés. Activez le GPS pour continuer.';

  @override
  String get openLocationSettingsButton =>
      'Ouvrir les paramètres de localisation';

  @override
  String get genericErrorMessage =>
      'Une erreur s\'est produite. Veuillez réessayer plus tard.';

  @override
  String distanceInKm(String distance) {
    return '$distance km';
  }

  @override
  String yourLocationLabel(String address) {
    return 'Votre position : $address';
  }

  @override
  String get languageMenuTooltip => 'Langue';

  @override
  String get languageSystemDefault => 'Langue du système';

  @override
  String get themeMenuTooltip => 'Thème';

  @override
  String get themeModeLight => 'Clair';

  @override
  String get themeModeDark => 'Sombre';

  @override
  String get themeModeSystem => 'Thème du système';

  @override
  String get settingsTooltip => 'Paramètres';

  @override
  String get authDisclaimer =>
      'Un compte n\'est pas nécessaire pour utiliser le localisateur de bureaux. La connexion est facultative et ne débloque pas encore de fonctionnalités supplémentaires.';

  @override
  String get unofficialAppNotice =>
      'Ceci est un projet indépendant et n\'est pas affilié à LM+.';

  @override
  String get openInMapsHint => 'Appuyez pour ouvrir dans Maps';

  @override
  String get officeOpenNow => 'Ouvert maintenant';

  @override
  String get officeClosedNow => 'Fermé maintenant';

  @override
  String get officeTypeFilterOffices => 'Bureaux';

  @override
  String get officeTypeFilterMailboxes => 'Boîtes aux lettres';

  @override
  String get headOfficeTooltip => 'Siège social';

  @override
  String get headOfficeTitle => 'Siège social de LM+';

  @override
  String get countryBelgium => 'Belgique';

  @override
  String get logoutConfirmTitle => 'Se déconnecter ?';

  @override
  String get logoutConfirmMessage => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get accountTooltip => 'Compte';

  @override
  String accountSignedInAs(String email) {
    return 'Connecté en tant que $email';
  }
}
