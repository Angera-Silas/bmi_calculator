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
  String get invalidMetricInput =>
      'Please check your measurements — some values are invalid.';

  @override
  String get advancedMetricsTitle => 'Advanced Metrics (Optional)';

  @override
  String get advancedMetricsSubtitle =>
      'Add body measurements for extra health insights (cm / bpm)';

  @override
  String get waistCircumference => 'Waist circumference';

  @override
  String get waistHint => 'e.g. 84';

  @override
  String get neckCircumference => 'Neck circumference';

  @override
  String get neckHint => 'e.g. 38';

  @override
  String get hipCircumference => 'Hip circumference';

  @override
  String get hipHint => 'e.g. 96';

  @override
  String get restingHeartRate => 'Resting heart rate';

  @override
  String get restingHeartRateHint => 'e.g. 68';

  @override
  String get healthMetricsTitle => 'Health Metrics';

  @override
  String get waistToHeightRatioLabel => 'Waist-to-Height Ratio';

  @override
  String get bodyFatLabel => 'Body Fat';

  @override
  String get metabolicAgeLabel => 'Metabolic Age';

  @override
  String get vo2maxLabel => 'VO2max (estimate)';

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

  @override
  String get trackingSectionTitle => 'Health Tracking';

  @override
  String get trackingSectionSubtitle =>
      'Log and monitor additional vital metrics';

  @override
  String get bpCardTitle => 'Blood Pressure';

  @override
  String get bpCardSubtitle =>
      'Systolic / diastolic tracking with WHO categories';

  @override
  String get bpOpen => 'Open';

  @override
  String get bpTitle => 'Blood Pressure';

  @override
  String get bpSaved => 'Reading saved';

  @override
  String get bpHistoryTitle => 'BP History';

  @override
  String get bpHistoryEmpty =>
      'No blood pressure readings yet.\nAdd one to start the trend.';

  @override
  String get bpTrendTitle => 'Trend';

  @override
  String get bpReadingsTitle => 'Readings';

  @override
  String get bpCategoryLabel => 'WHO Category:';

  @override
  String get bpSystolic => 'Systolic (top number)';

  @override
  String get bpDiastolic => 'Diastolic (bottom number)';

  @override
  String get bpPulse => 'Pulse (optional)';

  @override
  String get bpPulseHint => 'e.g. 72';

  @override
  String get bpPulseUnit => 'bpm';

  @override
  String get bpNotes => 'Notes';

  @override
  String get bpNotesHint => 'e.g. after morning walk';

  @override
  String get bpSave => 'Save Reading';

  @override
  String get bpCategoryNormal => 'Normal';

  @override
  String get bpCategoryElevated => 'Elevated';

  @override
  String get bpCategoryStage1 => 'High — Stage 1';

  @override
  String get bpCategoryStage2 => 'High — Stage 2';

  @override
  String get bpCategoryCrisis => 'Crisis';

  @override
  String get bsCardTitle => 'Blood Sugar';

  @override
  String get bsCardSubtitle => 'Glucose tracking with ADA categories';

  @override
  String get bsTitle => 'Blood Sugar';

  @override
  String get bsSaved => 'Reading saved';

  @override
  String get bsHistoryTitle => 'Glucose History';

  @override
  String get bsHistoryEmpty =>
      'No blood sugar readings yet.\nAdd one to start the trend.';

  @override
  String get bsTrendTitle => 'Trend';

  @override
  String get bsReadingsTitle => 'Readings';

  @override
  String get bsStatusLabel => 'ADA Status:';

  @override
  String get bsStatusNormal => 'Normal';

  @override
  String get bsStatusPrediabetes => 'Prediabetes';

  @override
  String get bsStatusDiabetes => 'Diabetes';

  @override
  String get bsLevel => 'Glucose Level';

  @override
  String get bsTypeLabel => 'Measurement Type';

  @override
  String get bsTypeFasting => 'Fasting';

  @override
  String get bsTypePostMeal => 'Post-meal';

  @override
  String get bsTypeRandom => 'Random';

  @override
  String get bsMealContext => 'Meal context (optional)';

  @override
  String get bsMealBeforeBreakfast => 'Before breakfast';

  @override
  String get bsMealAfterBreakfast => 'After breakfast';

  @override
  String get bsMealBeforeLunch => 'Before lunch';

  @override
  String get bsMealAfterLunch => 'After lunch';

  @override
  String get bsMealBeforeDinner => 'Before dinner';

  @override
  String get bsMealAfterDinner => 'After dinner';

  @override
  String get bsMealBedtime => 'Bedtime';

  @override
  String get bsNotes => 'Notes';

  @override
  String get bsNotesHint => 'e.g. took medication before reading';

  @override
  String get bsSave => 'Save Reading';

  @override
  String get bsEstimatedA1c => 'Est. A1C';

  @override
  String get bsA1cDisclosure =>
      'Estimated from average glucose — not a substitute for a lab test.';

  @override
  String get tabDashboard => 'Dashboard';

  @override
  String get subtitleDashboard => 'Your health at a glance';

  @override
  String get healthScoreTitle => 'Health Score';

  @override
  String get healthScoreNoData => 'Add measurements to see your health score';

  @override
  String get healthScorePillars => 'Score Breakdown';

  @override
  String get scoreExcellent => 'Excellent';

  @override
  String get scoreVeryGood => 'Very Good';

  @override
  String get scoreGood => 'Good';

  @override
  String get scoreFair => 'Fair';

  @override
  String get scoreNeedsImprovement => 'Needs Improvement';

  @override
  String get dashboardBmi => 'BMI';

  @override
  String get dashboardBp => 'Blood Pressure';

  @override
  String get dashboardGlucose => 'Glucose';

  @override
  String get dashboardAdvanced => 'Advanced';

  @override
  String get dashboardWhtr => 'Waist-to-height ratio';

  @override
  String get dashboardCorrelationTitle => 'BMI vs Glucose Correlation';

  @override
  String get healthScoreRecommendations => 'Recommendations';

  @override
  String get dashboardRecentBp => 'Latest Blood Pressure';

  @override
  String get dashboardRecentGlucose => 'Glucose Trend';

  @override
  String get recHealthyWeight => 'Reach a healthy weight';

  @override
  String get recHealthyWeightDetail =>
      'Aim for a BMI between 18.5 and 25 to reduce cardiovascular risk.';

  @override
  String get recHypertension => 'Manage blood pressure';

  @override
  String get recHypertensionDetail =>
      'Reduce sodium, exercise regularly, and track readings in the app.';

  @override
  String get recGlucose => 'Monitor blood sugar';

  @override
  String get recGlucoseDetail =>
      'Limit refined carbs and follow up with your clinician if levels stay elevated.';

  @override
  String get recCardio => 'Boost cardiovascular fitness';

  @override
  String get recCardioDetail =>
      'Regular aerobic activity can lower your resting heart rate over time.';

  @override
  String get recWaist => 'Reduce waist circumference';

  @override
  String get recWaistDetail =>
      'Target a waist-to-height ratio under 0.5 for better metabolic health.';

  @override
  String get recOnTrack => 'Great progress!';

  @override
  String get recOnTrackDetail =>
      'Your key metrics look healthy. Keep logging to maintain your score.';

  @override
  String get achievementCelebrationLabel => 'Achievement unlocked';

  @override
  String get achievementUnlocked => 'ACHIEVEMENT UNLOCKED · +';

  @override
  String get achievementNice => 'Nice!';

  @override
  String get achFirstCalculationTitle => 'First Calculation';

  @override
  String get achFirstCalculationDesc =>
      'Calculate your BMI for the first time.';

  @override
  String get achTenCalculationsTitle => 'Getting Started';

  @override
  String get achTenCalculationsDesc => 'Log 10 BMI calculations.';

  @override
  String get achFiftyCalculationsTitle => 'Power User';

  @override
  String get achFiftyCalculationsDesc => 'Log 50 BMI calculations.';

  @override
  String get achHundredCalculationsTitle => 'BMI Legend';

  @override
  String get achHundredCalculationsDesc => 'Log 100 BMI calculations.';

  @override
  String get achHealthyBmiTitle => 'Healthy Range';

  @override
  String get achHealthyBmiDesc => 'Record a BMI between 18.5 and 24.9.';

  @override
  String get achHealthyBpTitle => 'Calm & Normal';

  @override
  String get achHealthyBpDesc => 'Log a normal blood pressure reading.';

  @override
  String get achHealthyGlucoseTitle => 'Steady Glucose';

  @override
  String get achHealthyGlucoseDesc => 'Log a normal blood sugar reading.';

  @override
  String get achAllMetricsHealthyTitle => 'Full Bill of Health';

  @override
  String get achAllMetricsHealthyDesc =>
      'Have healthy BMI, blood pressure, and glucose readings.';

  @override
  String get achFirstBpTitle => 'First BP Reading';

  @override
  String get achFirstBpDesc => 'Log your first blood pressure reading.';

  @override
  String get achTenBpTitle => 'BP Watcher';

  @override
  String get achTenBpDesc => 'Log 10 blood pressure readings.';

  @override
  String get achFirstGlucoseTitle => 'First Glucose Reading';

  @override
  String get achFirstGlucoseDesc => 'Log your first blood sugar reading.';

  @override
  String get achTenGlucoseTitle => 'Glucose Observer';

  @override
  String get achTenGlucoseDesc => 'Log 10 blood sugar readings.';

  @override
  String get achThreeDayStreakTitle => 'Three in a Row';

  @override
  String get achThreeDayStreakDesc => 'Log a measurement 3 days in a row.';

  @override
  String get achSevenDayStreakTitle => 'Weekly Habit';

  @override
  String get achSevenDayStreakDesc => 'Log a measurement 7 days in a row.';

  @override
  String get achFourteenDayStreakTitle => 'Two Fortnights';

  @override
  String get achFourteenDayStreakDesc => 'Log a measurement 14 days in a row.';

  @override
  String get achThirtyDayStreakTitle => 'Unstoppable';

  @override
  String get achThirtyDayStreakDesc => 'Log a measurement 30 days in a row.';

  @override
  String get achPerfectWeekTitle => 'Perfect Week';

  @override
  String get achPerfectWeekDesc => 'Keep a 7-day best streak.';

  @override
  String get achOnARollTitle => 'On a Roll';

  @override
  String get achOnARollDesc => 'Log 5 measurements in a single day.';

  @override
  String get achEarlyBirdTitle => 'Early Bird';

  @override
  String get achEarlyBirdDesc => 'Log a measurement before 9 AM.';

  @override
  String get achNightOwlTitle => 'Night Owl';

  @override
  String get achNightOwlDesc => 'Log a measurement after 9 PM.';

  @override
  String get achAllTrackerTypesTitle => 'Total Tracker';

  @override
  String get achAllTrackerTypesDesc =>
      'Log a BMI, blood pressure, and glucose measurement.';

  @override
  String get achDashboardExcellentTitle => 'Peak Health';

  @override
  String get achDashboardExcellentDesc =>
      'Reach an excellent health score of 90+.';

  @override
  String get challengeLogBmiTitle => 'Log a BMI';

  @override
  String get challengeLogBmiDesc => 'Calculate your BMI once today.';

  @override
  String get challengeLogBpTitle => 'Check Blood Pressure';

  @override
  String get challengeLogBpDesc => 'Take a blood pressure reading today.';

  @override
  String get challengeLogGlucoseTitle => 'Check Glucose';

  @override
  String get challengeLogGlucoseDesc => 'Log a blood sugar reading today.';

  @override
  String get challengeLogAnyThreeTitle => 'Three Logs';

  @override
  String get challengeLogAnyThreeDesc => 'Log any 3 measurements today.';

  @override
  String get challengeLogHealthyTitle => 'Healthy Reading';

  @override
  String get challengeLogHealthyDesc =>
      'Log any reading in the normal range today.';

  @override
  String get dailyChallengeToday => 'Today\'s Challenge';

  @override
  String challengePointsFormat(Object points) {
    return '+$points pts';
  }

  @override
  String get challengeTierEasy => 'Easy';

  @override
  String get challengeTierMedium => 'Medium';

  @override
  String get challengeTierHard => 'Hard';

  @override
  String get challengeCompleted => 'CHALLENGE COMPLETED · +';

  @override
  String get challengeHistoryTitle => 'Challenge History';

  @override
  String get challengeHistoryError => 'Couldn\'t load challenge history.';

  @override
  String get challengeHistoryEmpty =>
      'No challenges yet. Check back tomorrow for your first one!';

  @override
  String get reminderSettingsTitle => 'Smart Reminders';

  @override
  String get reminderBmiTitle => 'Weight Check Reminder';

  @override
  String get reminderBmiBody =>
      'Time for a quick BMI calculation to keep your progress updated!';

  @override
  String get reminderHydrationTitle => 'Hydration Check-In';

  @override
  String get reminderHydrationBody =>
      'Drink some water! Staying hydrated supports metabolic health.';

  @override
  String get reminderActivityTitle => 'Get Moving Prompt';

  @override
  String get reminderActivityBody =>
      'Time for a stretch or a short walk. Keep active!';

  @override
  String get reminderHealthTipTitle => 'Daily Health Tip';

  @override
  String get reminderHealthTipBody =>
      'Open the app for a quick daily health insight to guide your journey.';

  @override
  String get reminderMedicationTitle => 'Medication Reminder';

  @override
  String get reminderMedicationBody =>
      'Friendly reminder: take your scheduled medicine or vitamins.';

  @override
  String get reminderChallengeTitle => 'Daily Challenge';

  @override
  String get reminderChallengeBody =>
      'Don\'t miss out on today\'s challenge! Complete it to earn points.';

  @override
  String get remindersLabel => 'Medication label';

  @override
  String get remindersTime => 'Time';

  @override
  String get remindersDays => 'Days';

  @override
  String get remindersEnabled => 'Enabled';

  @override
  String get everyday => 'Every day';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get weekends => 'Weekends';

  @override
  String get customDays => 'Custom';

  @override
  String get deleteReminder => 'Delete Reminder';

  @override
  String get addCustomMedication => 'Add Custom Medication Reminder';

  @override
  String get reminderSmartHint =>
      'Auto-skipped today once you log the matching metric';

  @override
  String get medicationNameHint => 'e.g. Vitamin D';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get achievementsError => 'Couldn\'t load your achievements.';

  @override
  String get achievementsTotalPoints => 'Total Points';

  @override
  String get achievementsCurrentStreak => 'Current Streak';

  @override
  String get achievementsBestStreak => 'Best Streak';

  @override
  String achievementsUnlockedCount(int count, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count of $total unlocked',
      one: '1 of $total unlocked',
    );
    return '$_temp0';
  }

  @override
  String achievementsStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get wearableTitle => 'Health Data';

  @override
  String get wearableConnectTitle => 'Connect health data';

  @override
  String get wearableConnectSubtitle =>
      'Link Google Health Connect or Apple Health to pull your fitness vitals into your Insights.';

  @override
  String get wearableGrantBtn => 'Grant Access';

  @override
  String get wearableGrantingBtn => 'Requesting access…';

  @override
  String get wearableGrantedTitle => 'Connected';

  @override
  String get wearableGrantedSubtitle =>
      'Health data is flowing into your Insights.';

  @override
  String get wearableRevokeBtn => 'Disconnect';

  @override
  String get wearableRefreshBtn => 'Refresh';

  @override
  String get wearableDryRun => 'No measurements found in the last 24 hours.';

  @override
  String get wearableRevokedSubtitle =>
      'You are no longer connected to health data.';

  @override
  String get wearableStepInPerm =>
      'Steps are read as an activity summary; the app needs Activity Recognition.';

  @override
  String get wearableErrorGeneric =>
      'Could not connect to health data. Please make sure Health Connect is installed (Android) or Health is allowed in Settings (iOS).';

  @override
  String get wearableErrorPermission =>
      'Access was denied. You can re-enable access from Health Connect on your device.';

  @override
  String get wearableImportBtn => 'Import to history';

  @override
  String wearableImportSuccess(int count) {
    return '$count readings added';
  }

  @override
  String get wearableImportNothing => 'No new readings to add';

  @override
  String get wearableAutoFillUse => 'Use';

  @override
  String get metricSteps => 'Steps';

  @override
  String get metricWeight => 'Weight';

  @override
  String get metricBloodPressure => 'Blood pressure';

  @override
  String get metricGlucose => 'Glucose';

  @override
  String get metricHeartRate => 'Heart rate';

  @override
  String get metricRestingHr => 'Resting HR';

  @override
  String get metricWater => 'Water';

  @override
  String get metricPermissions => 'Permissions';

  @override
  String wearableValidationRejected(int count) {
    return '$count reading(s) rejected (out of range)';
  }

  @override
  String get exportTitle => 'Export Health Report';

  @override
  String get exportSubtitle =>
      'Download your health, weight, and vitals history';

  @override
  String get exportBtn => 'Export';

  @override
  String get exportFormatLabel => 'Format';

  @override
  String get exportAnonymizeLabel => 'Anonymize data';

  @override
  String get exportAnonymizeSub => 'Hide personal details like emails and ID';

  @override
  String get exportShareBtn => 'Generate and Share';
}
