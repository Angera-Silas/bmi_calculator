// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Calculateur IMC';

  @override
  String get appTagline => 'Suivre · Comprendre · Améliorer';

  @override
  String get trackHealthJourney => 'Suivez votre parcours santé';

  @override
  String get tabCalculate => 'Calculer';

  @override
  String get tabHistory => 'Historique';

  @override
  String get tabInsights => 'Statistiques';

  @override
  String get subtitleCalculate => 'Entrez vos mesures ci-dessous';

  @override
  String get subtitleHistory => 'Vos calculs IMC précédents';

  @override
  String get subtitleInsights => 'Tendances et analyses';

  @override
  String get liveBmiPreview => 'Aperçu IMC en direct';

  @override
  String get metricUnits => 'Métrique (cm/kg)';

  @override
  String get imperialUnits => 'Impérial (ft/lbs)';

  @override
  String get biologicalSex => 'Sexe biologique';

  @override
  String get male => 'Masculin';

  @override
  String get female => 'Féminin';

  @override
  String get height => 'Taille';

  @override
  String get weight => 'Poids';

  @override
  String get age => 'Âge';

  @override
  String get years => 'ans';

  @override
  String get healthConditions => 'Conditions de santé (facultatif)';

  @override
  String get pregnancyStatus => 'État de grossesse (facultatif)';

  @override
  String get prePregnancyWeight => 'Poids avant grossesse (facultatif)';

  @override
  String get weightInKg => 'Poids en kg';

  @override
  String get weightInLbs => 'Poids en lbs';

  @override
  String get calculateBmi => 'Calculer l\'IMC';

  @override
  String get selectGenderError =>
      'Veuillez sélectionner votre sexe pour continuer';

  @override
  String get signInToSave =>
      'Veuillez vous connecter pour sauvegarder votre calcul';

  @override
  String get shortUnderweight => '· Insuffisance pondérale';

  @override
  String get shortNormal => '· Normal';

  @override
  String get shortOverweight => '· Surpoids';

  @override
  String get shortObese => '· Obèse';

  @override
  String get yourResults => 'Vos Résultats';

  @override
  String get bodyMassIndex => 'Indice de Masse Corporelle';

  @override
  String get whatThisMeans => 'Ce que cela signifie';

  @override
  String get idealWeightRange => 'Plage de Poids Idéale';

  @override
  String get minLabel => 'Min';

  @override
  String get maxLabel => 'Max';

  @override
  String get dailyCalories => 'Calories Quotidiennes';

  @override
  String get kcalPerDay => 'kcal/jour';

  @override
  String get waterIntake => 'Apport en Eau';

  @override
  String get litresPerDay => 'litres/jour';

  @override
  String get healthConsideration => 'Considération de Santé';

  @override
  String get nutritionRecommendations => 'Recommandations Nutritionnelles';

  @override
  String get dailyMealPlan => 'Plan de Repas Quotidien';

  @override
  String get macronutrientBalance => 'Équilibre des Macronutriments';

  @override
  String get focusFoods => 'Aliments Prioritaires';

  @override
  String get keyRecommendations => 'Recommandations Clés';

  @override
  String get bmiScale => 'Échelle IMC';

  @override
  String get reCalculate => 'Recalculer';

  @override
  String get resultCopied => 'Résultat copié dans le presse-papiers!';

  @override
  String get copyToClipboard => 'Copier dans le presse-papiers';

  @override
  String moreRecommendations(int count) {
    return '... et $count recommandations supplémentaires';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'Mon IMC est $bmi — $category\n$interpretation\nSuivi avec BMI Calculator App';
  }

  @override
  String get bmiSeverelyUnderweight => 'Insuffisance pondérale sévère';

  @override
  String get bmiUnderweight => 'Insuffisance pondérale';

  @override
  String get bmiNormalWeight => 'Poids normal';

  @override
  String get bmiOverweight => 'Surpoids';

  @override
  String get bmiObeseI => 'Obésité Classe I';

  @override
  String get bmiObeseII => 'Obésité Classe II';

  @override
  String get bmiSeverelyObese => 'Obésité sévère';

  @override
  String get profile => 'Profil';

  @override
  String get edit => 'Modifier';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get guestUser => 'Utilisateur invité';

  @override
  String get guestModeLocal => 'Mode invité · données stockées localement';

  @override
  String get guestModeBanner =>
      'Mode invité — les données sont stockées uniquement localement. Créez un compte pour synchroniser sur tous vos appareils.';

  @override
  String get personalInformation => 'Informations Personnelles';

  @override
  String get fullName => 'Nom complet';

  @override
  String get email => 'E-mail';

  @override
  String get phone => 'Téléphone';

  @override
  String get notAvailable => 'N/D';

  @override
  String get account => 'Compte';

  @override
  String get totalChecks => 'Total des contrôles';

  @override
  String get averageBmi => 'IMC moyen';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get signIn => 'Se connecter';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get leaveGuestMode => 'Quitter le mode invité';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String get leaveGuestTitle => 'Quitter le mode invité?';

  @override
  String get signOutTitle => 'Se déconnecter?';

  @override
  String get leaveGuestContent =>
      'Vos données locales seront effacées. Connectez-vous ou créez un compte pour conserver votre historique.';

  @override
  String get signOutContent =>
      'Vous pouvez vous reconnecter à tout moment pour accéder à vos données synchronisées.';

  @override
  String get leave => 'Quitter';

  @override
  String get deleteAccountTitle => 'Supprimer le compte?';

  @override
  String get deleteAccountContent =>
      'Ceci supprimera définitivement votre compte et toutes vos données. Cette action est irréversible.';

  @override
  String get delete => 'Supprimer';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get signInToContinue => 'Connectez-vous pour continuer';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get continueAsGuest => 'Continuer en tant qu\'invité';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte?';

  @override
  String get createOne => 'En créer un';

  @override
  String get emailRequired => 'L\'e-mail est requis';

  @override
  String get emailInvalid => 'Entrez une adresse e-mail valide';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get createAccountTitle => 'Créer un compte';

  @override
  String get startTrackingToday =>
      'Commencez à suivre votre santé aujourd\'hui';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte?';

  @override
  String get signInLink => 'Se connecter';

  @override
  String get nameRequired => 'Le nom est requis';

  @override
  String get nameShort => 'Entrez votre nom complet';

  @override
  String get phoneRequired => 'Le numéro de téléphone est requis';

  @override
  String get phoneInvalid => 'Entrez un numéro de téléphone valide';

  @override
  String get confirmPasswordRequired => 'Veuillez confirmer votre mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String passwordStrengthLabel(String level) {
    return 'Force du mot de passe : $level';
  }

  @override
  String get passwordWeak => 'Faible';

  @override
  String get passwordMedium => 'Moyen';

  @override
  String get passwordStrong => 'Fort';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordSubtitle =>
      'Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get sendResetLink => 'Envoyer le lien';

  @override
  String get checkInbox => 'Vérifiez votre boîte de réception';

  @override
  String resetLinkSentTo(String email) {
    return 'Nous avons envoyé un lien de réinitialisation à\n$email';
  }

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String get noHistoryYet => 'Pas encore d\'historique';

  @override
  String get noHistorySubtitle =>
      'Calculez votre IMC dans l\'onglet Accueil et votre historique apparaîtra ici.';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get yourProgress => 'Votre Progression';

  @override
  String entriesCount(int count) {
    return '$count entrées';
  }

  @override
  String entryCount(int count) {
    return '$count entrée';
  }

  @override
  String get average => 'Moyenne';

  @override
  String get lowest => 'Minimum';

  @override
  String get highest => 'Maximum';

  @override
  String get trend => 'Tendance';

  @override
  String get deleteRecordTitle => 'Supprimer l\'enregistrement?';

  @override
  String get deleteRecordContent =>
      'Ceci supprimera définitivement cet enregistrement IMC.';

  @override
  String get failedToLoadHistory => 'Échec du chargement de l\'historique';

  @override
  String get retry => 'Réessayer';

  @override
  String get avgBmi => 'IMC Moy.';

  @override
  String get latestBmi => 'Dernier IMC';

  @override
  String get bestBmi => 'Meilleur IMC';

  @override
  String get bmiTrend => 'Tendance IMC';

  @override
  String lastNMeasurements(int count) {
    return '$count dernières mesures';
  }

  @override
  String get categoryDistribution => 'Répartition par catégorie';

  @override
  String basedOnAllRecords(int count) {
    return 'Basé sur $count enregistrements';
  }

  @override
  String get recentMeasurements => 'Mesures Récentes';

  @override
  String get last5Entries => '5 dernières entrées';

  @override
  String get noDataYet => 'Pas encore de données';

  @override
  String get noDataSubtitle =>
      'Commencez à suivre votre IMC et vos statistiques apparaîtront ici.';
}
