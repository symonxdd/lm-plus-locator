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
  String get emailTab => 'E-mail';

  @override
  String get phoneTab => 'Téléphone';

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
  String get phoneLoginTitle => 'Connexion avec un numéro de téléphone';

  @override
  String get phoneLabel => 'Numéro de téléphone (ex. +32470123456)';

  @override
  String get phoneValidationError =>
      'Veuillez saisir un numéro de téléphone valide avec l\'indicatif du pays (+32...).';

  @override
  String get sendVerificationCode => 'Envoyer le code de vérification';

  @override
  String get verificationFailed => 'Échec de la vérification.';

  @override
  String get verificationCodeTitle => 'Code de vérification';

  @override
  String otpSentMessage(String phoneNumber) {
    return 'Nous avons envoyé un code au $phoneNumber.';
  }

  @override
  String get verificationCodeLabel => 'Code de vérification';

  @override
  String get verificationCodeValidationError => 'Veuillez saisir le code reçu.';

  @override
  String get confirmButton => 'Confirmer';

  @override
  String get invalidVerificationCode => 'Code de vérification invalide.';

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
}
