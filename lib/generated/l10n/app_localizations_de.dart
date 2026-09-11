// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'BMI-Rechner';

  @override
  String get appTagline => 'Verfolgen · Verstehen · Verbessern';

  @override
  String get trackHealthJourney => 'Verfolge deine Gesundheitsreise';

  @override
  String get tabCalculate => 'Berechnen';

  @override
  String get tabHistory => 'Verlauf';

  @override
  String get tabInsights => 'Statistiken';

  @override
  String get subtitleCalculate => 'Gib deine Maße unten ein';

  @override
  String get subtitleHistory => 'Deine früheren BMI-Berechnungen';

  @override
  String get subtitleInsights => 'Trends und Analysen';

  @override
  String get liveBmiPreview => 'Live-BMI-Vorschau';

  @override
  String get metricUnits => 'Metrisch (cm/kg)';

  @override
  String get imperialUnits => 'Imperial (ft/lbs)';

  @override
  String get biologicalSex => 'Biologisches Geschlecht';

  @override
  String get male => 'Männlich';

  @override
  String get female => 'Weiblich';

  @override
  String get height => 'Größe';

  @override
  String get weight => 'Gewicht';

  @override
  String get age => 'Alter';

  @override
  String get years => 'J.';

  @override
  String get healthConditions => 'Gesundheitszustand (optional)';

  @override
  String get pregnancyStatus => 'Schwangerschaftsstatus (optional)';

  @override
  String get prePregnancyWeight => 'Gewicht vor Schwangerschaft (optional)';

  @override
  String get weightInKg => 'Gewicht in kg';

  @override
  String get weightInLbs => 'Gewicht in lbs';

  @override
  String get calculateBmi => 'BMI berechnen';

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
      'Bitte wähle dein Geschlecht aus, um fortzufahren';

  @override
  String get signInToSave =>
      'Bitte melde dich an, um die Berechnung zu speichern';

  @override
  String get shortUnderweight => '· Untergewicht';

  @override
  String get shortNormal => '· Normal';

  @override
  String get shortOverweight => '· Übergewicht';

  @override
  String get shortObese => '· Adipositas';

  @override
  String get yourResults => 'Deine Ergebnisse';

  @override
  String get bodyMassIndex => 'Body-Mass-Index';

  @override
  String get whatThisMeans => 'Was das bedeutet';

  @override
  String get idealWeightRange => 'Idealer Gewichtsbereich';

  @override
  String get minLabel => 'Min';

  @override
  String get maxLabel => 'Max';

  @override
  String get dailyCalories => 'Tägliche Kalorien';

  @override
  String get kcalPerDay => 'kcal/Tag';

  @override
  String get waterIntake => 'Wasseraufnahme';

  @override
  String get litresPerDay => 'Liter/Tag';

  @override
  String get healthConsideration => 'Gesundheitshinweis';

  @override
  String get nutritionRecommendations => 'Ernährungsempfehlungen';

  @override
  String get dailyMealPlan => 'Täglicher Ernährungsplan';

  @override
  String get macronutrientBalance => 'Makronährstoffbilanz';

  @override
  String get focusFoods => 'Wichtige Lebensmittel';

  @override
  String get keyRecommendations => 'Wichtigste Empfehlungen';

  @override
  String get bmiScale => 'BMI-Skala';

  @override
  String get reCalculate => 'Neu berechnen';

  @override
  String get resultCopied => 'Ergebnis in die Zwischenablage kopiert!';

  @override
  String get copyToClipboard => 'In die Zwischenablage kopieren';

  @override
  String moreRecommendations(int count) {
    return '... und $count weitere Empfehlungen';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'Mein BMI ist $bmi — $category\n$interpretation\nMit BMI Calculator App verfolgt';
  }

  @override
  String get bmiSeverelyUnderweight => 'Starkes Untergewicht';

  @override
  String get bmiUnderweight => 'Untergewicht';

  @override
  String get bmiNormalWeight => 'Normalgewicht';

  @override
  String get bmiOverweight => 'Übergewicht';

  @override
  String get bmiObeseI => 'Adipositas Grad I';

  @override
  String get bmiObeseII => 'Adipositas Grad II';

  @override
  String get bmiSeverelyObese => 'Starke Adipositas';

  @override
  String get profile => 'Profil';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get guestUser => 'Gastnutzer';

  @override
  String get guestModeLocal => 'Gastmodus · Daten lokal gespeichert';

  @override
  String get guestModeBanner =>
      'Gastmodus — Daten werden nur lokal gespeichert. Erstelle ein Konto für geräteübergreifende Synchronisierung.';

  @override
  String get personalInformation => 'Persönliche Informationen';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get email => 'E-Mail';

  @override
  String get phone => 'Telefon';

  @override
  String get notAvailable => 'N/V';

  @override
  String get account => 'Konto';

  @override
  String get totalChecks => 'Gesamte Messungen';

  @override
  String get averageBmi => 'Durchschnittlicher BMI';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get signIn => 'Anmelden';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get leaveGuestMode => 'Gastmodus verlassen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get profileUpdated => 'Profil aktualisiert';

  @override
  String get leaveGuestTitle => 'Gastmodus verlassen?';

  @override
  String get signOutTitle => 'Abmelden?';

  @override
  String get leaveGuestContent =>
      'Deine lokalen Daten werden gelöscht. Melde dich an oder erstelle ein Konto, um den Verlauf zu behalten.';

  @override
  String get signOutContent => 'Du kannst dich jederzeit wieder anmelden.';

  @override
  String get leave => 'Verlassen';

  @override
  String get deleteAccountTitle => 'Konto löschen?';

  @override
  String get deleteAccountContent =>
      'Dein Konto und alle Daten werden dauerhaft gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get delete => 'Löschen';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get signInToContinue => 'Melde dich an, um fortzufahren';

  @override
  String get emailAddress => 'E-Mail-Adresse';

  @override
  String get password => 'Passwort';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get continueAsGuest => 'Als Gast fortfahren';

  @override
  String get dontHaveAccount => 'Noch kein Konto?';

  @override
  String get createOne => 'Erstellen';

  @override
  String get emailRequired => 'E-Mail ist erforderlich';

  @override
  String get emailInvalid => 'Gib eine gültige E-Mail-Adresse ein';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get passwordTooShort => 'Das Passwort muss mindestens 6 Zeichen haben';

  @override
  String get createAccountTitle => 'Konto erstellen';

  @override
  String get startTrackingToday =>
      'Beginne noch heute mit der Gesundheitsverfolgung';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto?';

  @override
  String get signInLink => 'Anmelden';

  @override
  String get nameRequired => 'Name ist erforderlich';

  @override
  String get nameShort => 'Gib deinen vollständigen Namen ein';

  @override
  String get phoneRequired => 'Telefonnummer ist erforderlich';

  @override
  String get phoneInvalid => 'Gib eine gültige Telefonnummer ein';

  @override
  String get confirmPasswordRequired => 'Bitte bestätige dein Passwort';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String passwordStrengthLabel(String level) {
    return 'Passwortstärke: $level';
  }

  @override
  String get passwordWeak => 'Schwach';

  @override
  String get passwordMedium => 'Mittel';

  @override
  String get passwordStrong => 'Stark';

  @override
  String get resetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get resetPasswordSubtitle =>
      'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen des Passworts.';

  @override
  String get sendResetLink => 'Link senden';

  @override
  String get checkInbox => 'Überprüfe deinen Posteingang';

  @override
  String resetLinkSentTo(String email) {
    return 'Wir haben den Passwort-Reset-Link an\n$email gesendet';
  }

  @override
  String get backToSignIn => 'Zurück zur Anmeldung';

  @override
  String get noHistoryYet => 'Noch kein Verlauf';

  @override
  String get noHistorySubtitle =>
      'Berechne deinen BMI im Tab Berechnen und dein Verlauf erscheint hier.';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get yourProgress => 'Dein Fortschritt';

  @override
  String entriesCount(int count) {
    return '$count Einträge';
  }

  @override
  String entryCount(int count) {
    return '$count Eintrag';
  }

  @override
  String get average => 'Durchschnitt';

  @override
  String get lowest => 'Minimum';

  @override
  String get highest => 'Maximum';

  @override
  String get trend => 'Trend';

  @override
  String get deleteRecordTitle => 'Eintrag löschen?';

  @override
  String get deleteRecordContent =>
      'Dieser BMI-Eintrag wird dauerhaft gelöscht.';

  @override
  String get failedToLoadHistory => 'Verlauf konnte nicht geladen werden';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get avgBmi => 'Ø BMI';

  @override
  String get latestBmi => 'Letzter BMI';

  @override
  String get bestBmi => 'Bester BMI';

  @override
  String get bmiTrend => 'BMI-Trend';

  @override
  String lastNMeasurements(int count) {
    return 'Letzte $count Messungen';
  }

  @override
  String get categoryDistribution => 'Kategorieverteilung';

  @override
  String basedOnAllRecords(int count) {
    return 'Basierend auf $count Einträgen';
  }

  @override
  String get recentMeasurements => 'Neueste Messungen';

  @override
  String get last5Entries => 'Letzte 5 Einträge';

  @override
  String get noDataYet => 'Noch keine Daten';

  @override
  String get noDataSubtitle =>
      'Beginne mit der BMI-Erfassung und deine Statistiken erscheinen hier.';

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
