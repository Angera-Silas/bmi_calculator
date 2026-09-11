// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appTitle => 'Kikokotoo cha BMI';

  @override
  String get appTagline => 'Fuatilia · Elewa · Boresha';

  @override
  String get trackHealthJourney => 'Fuatilia safari yako ya afya';

  @override
  String get tabCalculate => 'Hesabu';

  @override
  String get tabHistory => 'Historia';

  @override
  String get tabInsights => 'Takwimu';

  @override
  String get subtitleCalculate => 'Ingiza vipimo vyako hapa chini';

  @override
  String get subtitleHistory => 'Mahesabu yako ya BMI yaliyopita';

  @override
  String get subtitleInsights => 'Mwenendo na uchambuzi';

  @override
  String get liveBmiPreview => 'Muonekano wa BMI moja kwa moja';

  @override
  String get metricUnits => 'Metriki (cm/kg)';

  @override
  String get imperialUnits => 'Imperial (ft/lbs)';

  @override
  String get biologicalSex => 'Jinsia ya kibiolojia';

  @override
  String get male => 'Mwanaume';

  @override
  String get female => 'Mwanamke';

  @override
  String get height => 'Urefu';

  @override
  String get weight => 'Uzito';

  @override
  String get age => 'Umri';

  @override
  String get years => 'maka';

  @override
  String get healthConditions => 'Hali za kiafya (si lazima)';

  @override
  String get pregnancyStatus => 'Hali ya ujauzito (si lazima)';

  @override
  String get prePregnancyWeight => 'Uzito kabla ya ujauzito (si lazima)';

  @override
  String get weightInKg => 'Uzito kwa kg';

  @override
  String get weightInLbs => 'Uzito kwa lbs';

  @override
  String get calculateBmi => 'Hesabu BMI';

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
  String get selectGenderError => 'Tafadhali chagua jinsia yako ili kuendelea';

  @override
  String get signInToSave => 'Tafadhali ingia ili kuhifadhi hesabu yako';

  @override
  String get shortUnderweight => '· Uzito mdogo';

  @override
  String get shortNormal => '· Kawaida';

  @override
  String get shortOverweight => '· Uzito mwingi';

  @override
  String get shortObese => '· Unene';

  @override
  String get yourResults => 'Matokeo Yako';

  @override
  String get bodyMassIndex => 'Kiindeksi cha Uzito wa Mwili';

  @override
  String get whatThisMeans => 'Hii inamaanisha nini';

  @override
  String get idealWeightRange => 'Anuwai ya Uzito Bora';

  @override
  String get minLabel => 'Kiwango cha chini';

  @override
  String get maxLabel => 'Kiwango cha juu';

  @override
  String get dailyCalories => 'Kalori za Kila Siku';

  @override
  String get kcalPerDay => 'kcal/siku';

  @override
  String get waterIntake => 'Ulaji wa Maji';

  @override
  String get litresPerDay => 'lita/siku';

  @override
  String get healthConsideration => 'Onyo la Kiafya';

  @override
  String get nutritionRecommendations => 'Mapendekezo ya Lishe';

  @override
  String get dailyMealPlan => 'Mpango wa Chakula wa Kila Siku';

  @override
  String get macronutrientBalance => 'Usawa wa Virutubisho Vikuu';

  @override
  String get focusFoods => 'Vyakula vya Msingi';

  @override
  String get keyRecommendations => 'Mapendekezo Muhimu';

  @override
  String get bmiScale => 'Kiwango cha BMI';

  @override
  String get reCalculate => 'Hesabu Tena';

  @override
  String get resultCopied => 'Matokeo yamenakiliwa kwenye ubao wa kunakili!';

  @override
  String get copyToClipboard => 'Nakili kwenye ubao wa kunakili';

  @override
  String moreRecommendations(int count) {
    return '... na mapendekezo $count zaidi';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'BMI yangu ni $bmi — $category\n$interpretation\nImefuatiliwa na BMI Calculator App';
  }

  @override
  String get bmiSeverelyUnderweight => 'Uzito Mdogo Sana';

  @override
  String get bmiUnderweight => 'Uzito Mdogo';

  @override
  String get bmiNormalWeight => 'Uzito wa Kawaida';

  @override
  String get bmiOverweight => 'Uzito Mwingi';

  @override
  String get bmiObeseI => 'Unene Daraja I';

  @override
  String get bmiObeseII => 'Unene Daraja II';

  @override
  String get bmiSeverelyObese => 'Unene Mkubwa Sana';

  @override
  String get profile => 'Wasifu';

  @override
  String get edit => 'Hariri';

  @override
  String get cancel => 'Ghairi';

  @override
  String get save => 'Hifadhi';

  @override
  String get guestUser => 'Mtumiaji Mgeni';

  @override
  String get guestModeLocal =>
      'Hali ya mgeni · data imehifadhiwa ndani ya kifaa';

  @override
  String get guestModeBanner =>
      'Hali ya mgeni — data imehifadhiwa ndani ya kifaa tu. Fungua akaunti ili kusawazisha kwenye vifaa vyote.';

  @override
  String get personalInformation => 'Taarifa za Kibinafsi';

  @override
  String get fullName => 'Jina kamili';

  @override
  String get email => 'Barua pepe';

  @override
  String get phone => 'Simu';

  @override
  String get notAvailable => 'Haipatikani';

  @override
  String get account => 'Akaunti';

  @override
  String get totalChecks => 'Jumla ya Ukaguzi';

  @override
  String get averageBmi => 'BMI ya Wastani';

  @override
  String get createAccount => 'Fungua Akaunti';

  @override
  String get signIn => 'Ingia';

  @override
  String get changePassword => 'Badilisha Nenosiri';

  @override
  String get deleteAccount => 'Futa Akaunti';

  @override
  String get leaveGuestMode => 'Acha Hali ya Mgeni';

  @override
  String get signOut => 'Toka';

  @override
  String get profileUpdated => 'Wasifu umesasishwa';

  @override
  String get leaveGuestTitle => 'Acha hali ya mgeni?';

  @override
  String get signOutTitle => 'Toka?';

  @override
  String get leaveGuestContent =>
      'Data yako ya ndani itafutwa. Ingia au fungua akaunti ili kuhifadhi historia yako.';

  @override
  String get signOutContent => 'Unaweza kuingia tena wakati wowote.';

  @override
  String get leave => 'Acha';

  @override
  String get deleteAccountTitle => 'Futa akaunti?';

  @override
  String get deleteAccountContent =>
      'Hii itafuta akaunti yako na data yote kwa kudumu. Haiwezi kurejeshwa.';

  @override
  String get delete => 'Futa';

  @override
  String get language => 'Lugha';

  @override
  String get selectLanguage => 'Chagua lugha';

  @override
  String get welcomeBack => 'Karibu tena';

  @override
  String get signInToContinue => 'Ingia ili kuendelea';

  @override
  String get emailAddress => 'Anwani ya barua pepe';

  @override
  String get password => 'Nenosiri';

  @override
  String get forgotPassword => 'Umesahau nenosiri?';

  @override
  String get continueAsGuest => 'Endelea kama mgeni';

  @override
  String get dontHaveAccount => 'Huna akaunti?';

  @override
  String get createOne => 'Fungua moja';

  @override
  String get emailRequired => 'Barua pepe inahitajika';

  @override
  String get emailInvalid => 'Ingiza anwani sahihi ya barua pepe';

  @override
  String get passwordRequired => 'Nenosiri linahitajika';

  @override
  String get passwordTooShort => 'Nenosiri lazima liwe na angalau herufi 6';

  @override
  String get createAccountTitle => 'Fungua Akaunti';

  @override
  String get startTrackingToday => 'Anza kufuatilia afya yako leo';

  @override
  String get phoneNumber => 'Nambari ya simu';

  @override
  String get confirmPassword => 'Thibitisha nenosiri';

  @override
  String get alreadyHaveAccount => 'Tayari una akaunti?';

  @override
  String get signInLink => 'Ingia';

  @override
  String get nameRequired => 'Jina linahitajika';

  @override
  String get nameShort => 'Ingiza jina lako kamili';

  @override
  String get phoneRequired => 'Nambari ya simu inahitajika';

  @override
  String get phoneInvalid => 'Ingiza nambari sahihi ya simu';

  @override
  String get confirmPasswordRequired => 'Tafadhali thibitisha nenosiri lako';

  @override
  String get passwordsDoNotMatch => 'Manenosiri hayafanani';

  @override
  String passwordStrengthLabel(String level) {
    return 'Nguvu ya nenosiri: $level';
  }

  @override
  String get passwordWeak => 'Dhaifu';

  @override
  String get passwordMedium => 'Wastani';

  @override
  String get passwordStrong => 'Imara';

  @override
  String get resetPasswordTitle => 'Weka Upya Nenosiri';

  @override
  String get resetPasswordSubtitle =>
      'Ingiza barua pepe yako na tutakutumia kiungo cha kuweka upya nenosiri.';

  @override
  String get sendResetLink => 'Tuma Kiungo';

  @override
  String get checkInbox => 'Angalia sanduku lako la barua pepe';

  @override
  String resetLinkSentTo(String email) {
    return 'Tumetuma kiungo cha kuweka upya nenosiri kwa\n$email';
  }

  @override
  String get backToSignIn => 'Rudi kuingia';

  @override
  String get noHistoryYet => 'Hakuna historia bado';

  @override
  String get noHistorySubtitle =>
      'Hesabu BMI yako kwenye kichupo cha Nyumbani na historia yako itaonekana hapa.';

  @override
  String get today => 'Leo';

  @override
  String get yesterday => 'Jana';

  @override
  String get yourProgress => 'Maendeleo Yako';

  @override
  String entriesCount(int count) {
    return 'maingizo $count';
  }

  @override
  String entryCount(int count) {
    return 'kuingiza $count';
  }

  @override
  String get average => 'Wastani';

  @override
  String get lowest => 'Chini';

  @override
  String get highest => 'Juu';

  @override
  String get trend => 'Mwenendo';

  @override
  String get deleteRecordTitle => 'Futa rekodi?';

  @override
  String get deleteRecordContent => 'Rekodi hii ya BMI itafutwa kwa kudumu.';

  @override
  String get failedToLoadHistory => 'Imeshindwa kupakia historia';

  @override
  String get retry => 'Jaribu tena';

  @override
  String get avgBmi => 'BMI ya wastani';

  @override
  String get latestBmi => 'BMI ya hivi karibuni';

  @override
  String get bestBmi => 'BMI Bora';

  @override
  String get bmiTrend => 'Mwenendo wa BMI';

  @override
  String lastNMeasurements(int count) {
    return 'Vipimo $count vya mwisho';
  }

  @override
  String get categoryDistribution => 'Usambazaji wa Makundi';

  @override
  String basedOnAllRecords(int count) {
    return 'Kulingana na rekodi $count zote';
  }

  @override
  String get recentMeasurements => 'Vipimo vya Hivi Karibuni';

  @override
  String get last5Entries => 'Maingizo 5 ya mwisho';

  @override
  String get noDataYet => 'Hakuna data bado';

  @override
  String get noDataSubtitle =>
      'Anza kufuatilia BMI yako na takwimu zako zitaonekana hapa.';

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
