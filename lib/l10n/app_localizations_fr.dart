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
  String get appTagline =>
      'Trouvez rapidement le bureau LM+ le plus proche de vous.';

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
  String get privacyNoticeTooltip => 'Politique de confidentialité';

  @override
  String get privacyPolicyButton => 'Politique de confidentialité';

  @override
  String get aboutTooltip => 'À propos de cette app';

  @override
  String get aboutDeveloperLabel => 'Créé par';

  @override
  String get aboutPortfolioButton => 'Portfolio';

  @override
  String get aboutGithubButton => 'GitHub';

  @override
  String get aboutDocsButton => 'Documentation technique';

  @override
  String get findNearestOfficeButton => 'Utiliser ma position';

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
  String get themeMenuTooltip => 'Thème';

  @override
  String get themeModeLight => 'Clair';

  @override
  String get themeModeDark => 'Sombre';

  @override
  String get themeModeSystem => 'Système';

  @override
  String get settingsTooltip => 'Paramètres';

  @override
  String get authDisclaimerIntro =>
      'Un compte n\'est pas nécessaire pour utiliser le localisateur de bureaux.';

  @override
  String get authDisclaimerSync =>
      'La connexion est facultative; elle synchronise automatiquement vos bureaux enregistrés sur tous vos appareils.';

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

  @override
  String get photoShareTooltip => 'Prendre une photo à partager';

  @override
  String get photoRetakeButton => 'Reprendre';

  @override
  String get photoShareButton => 'Partager';

  @override
  String get photoShareSubject => 'Photo de LM+ Locator';

  @override
  String get locatorTabLabel => 'Localisateur';

  @override
  String get photoShareTabLabel => 'Partager une photo';

  @override
  String get photoShareExperimentalNotice => 'Fonctionnalité expérimentale';

  @override
  String get searchByAddressButton => 'Ou recherchez par adresse';

  @override
  String get addressSearchTitle => 'Rechercher par adresse';

  @override
  String get addressInputLabel => 'Adresse';

  @override
  String get addressSearchSubmitButton => 'Rechercher';

  @override
  String get addressNotFoundError =>
      'Adresse introuvable. Essayez une autre adresse.';

  @override
  String get resultsFilterHint => 'Filtrer par nom, rue ou numéro';

  @override
  String get resultsFilterNoMatches =>
      'Aucun bureau ou boîte aux lettres trouvé.';

  @override
  String get visitWebsiteButton => 'Visiter le site web';

  @override
  String get addressSuggestionsAttribution =>
      'Suggestions d\'adresses via OpenStreetMap';

  @override
  String get deleteAccountButton => 'Supprimer le compte';

  @override
  String get deleteAccountConfirmTitle => 'Supprimer le compte ?';

  @override
  String get deleteAccountConfirmMessage =>
      'Cette action supprime définitivement votre compte. Cette action est irréversible.';

  @override
  String get reauthenticateTitle => 'Confirmez votre mot de passe';

  @override
  String get reauthenticateMessage =>
      'Pour votre sécurité, veuillez ressaisir votre mot de passe pour continuer.';

  @override
  String get reauthenticateButton => 'Confirmer';

  @override
  String get invalidCredentialsError => 'E-mail ou mot de passe incorrect.';

  @override
  String get emailAlreadyInUseError =>
      'Un compte existe déjà avec cette adresse e-mail.';

  @override
  String get weakPasswordError =>
      'Choisissez un mot de passe plus fort (au moins 6 caractères).';

  @override
  String get forgotPasswordButton => 'Mot de passe oublié ?';

  @override
  String get passwordResetEmailSent =>
      'E-mail de réinitialisation envoyé. Vérifiez votre boîte de réception.';

  @override
  String get passwordRequiredError => 'Veuillez saisir votre mot de passe.';

  @override
  String accountIdLabel(String id) {
    return 'ID de compte : $id';
  }

  @override
  String accountCreatedLabel(String date) {
    return 'Membre depuis $date';
  }

  @override
  String get accountDeletedMessage => 'Compte supprimé avec succès.';

  @override
  String get networkErrorMessage =>
      'Pas de connexion internet. Vérifiez votre connexion et réessayez.';

  @override
  String get tooManyRequestsError =>
      'Trop de tentatives. Patientez un moment et réessayez.';

  @override
  String get userDisabledError => 'Ce compte a été désactivé.';

  @override
  String get favoritesTabLabel => 'Enregistrés';

  @override
  String get favoritesEmptyTitle => 'Aucun bureau enregistré';

  @override
  String get favoritesEmptySubtitle =>
      'Appuyez sur le signet d\'une fiche de bureau pour l\'enregistrer.';

  @override
  String get favoriteAddTooltip => 'Enregistrer le bureau';

  @override
  String get favoriteRemoveTooltip => 'Retirer des enregistrés';

  @override
  String get favoritesSyncedNotice => 'Synchronisé avec votre compte';

  @override
  String get favoritesSignInToSync =>
      'Connectez-vous pour enregistrer cette liste dans votre compte';

  @override
  String get offlineBannerMessage =>
      'Hors ligne — la recherche GPS fonctionne toujours';

  @override
  String get addressSearchOfflineError =>
      'Hors ligne — seule la recherche GPS est disponible';

  @override
  String get openingHoursTitle => 'Heures d\'ouverture';

  @override
  String get openingHoursClosed => 'Fermé';

  @override
  String get openingHoursTodayLabel => '(aujourd\'hui)';

  @override
  String get viewOpeningHoursHint => 'Voir les heures d\'ouverture';

  @override
  String get messagesTabLabel => 'Messages';

  @override
  String get chatInputHint => 'Écrire un message...';

  @override
  String get chatSendTooltip => 'Envoyer';

  @override
  String get messagesDentalReimbursementTitle =>
      'Remboursement soins dentaires';

  @override
  String get messagesAddressChangeTitle => 'Changement d\'adresse';

  @override
  String get messagesMembershipCardTitle =>
      'Remplacement de la carte de membre';

  @override
  String get messagesDentalReimbursementUserQuestion =>
      'Bonjour, j\'ai introduit une demande de soins dentaires la semaine dernière — y a-t-il du nouveau concernant le remboursement ?';

  @override
  String get messagesDentalReimbursementOfficeAck =>
      'Je vérifie cela pour vous, un instant.';

  @override
  String get messagesDentalReimbursementOfficeApproved =>
      'Votre demande a été approuvée. Le remboursement sera viré dans les 5 jours ouvrables.';

  @override
  String get messagesDentalReimbursementOfficeFollowup =>
      'Puis-je encore vous aider pour autre chose ?';

  @override
  String get messagesAddressChangeUserQuestion =>
      'Bonjour, j\'ai récemment déménagé — dois-je moi-même mettre à jour mon adresse chez vous ?';

  @override
  String get messagesAddressChangeOfficeReply =>
      'Ce n\'est pas nécessaire — nous avons reçu la mise à jour automatiquement via le registre de la population. Votre dossier est à jour.';

  @override
  String get messagesMembershipCardOfficeReminder =>
      'Rappel : votre nouvelle carte de membre est prête à être retirée à notre guichet.';

  @override
  String get messagesCannedReply1 =>
      'Merci pour votre message ! Nous reviendrons vers vous rapidement.';

  @override
  String get messagesCannedReply2 =>
      'Bien reçu — quelqu\'un de notre équipe vous contactera bientôt.';

  @override
  String get messagesCannedReply3 =>
      'Merci de nous avoir contactés. Nous allons examiner cela et répondre dès que possible.';

  @override
  String get messagesExperimentalNotice => 'Fonctionnalité expérimentale';
}
