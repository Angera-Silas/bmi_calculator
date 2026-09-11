// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hausa (`ha`).
class AppLocalizationsHa extends AppLocalizations {
  AppLocalizationsHa([String locale = 'ha']) : super(locale);

  @override
  String get appTitle => 'Ƙididdigan BMI';

  @override
  String get appTagline => 'Bincika · Fahimta · Inganta';

  @override
  String get trackHealthJourney => 'Bincika tafiyar lafiyar ku';

  @override
  String get tabCalculate => 'Ƙidaya';

  @override
  String get tabHistory => 'Tarihi';

  @override
  String get tabInsights => 'Kididdiga';

  @override
  String get subtitleCalculate => 'Shigar da aunanni ku a ƙasa';

  @override
  String get subtitleHistory => 'Lissafin BMI ku na da';

  @override
  String get subtitleInsights => 'Yanayi da bincike';

  @override
  String get liveBmiPreview => 'Kallon BMI na kai tsaye';

  @override
  String get metricUnits => 'Metric (cm/kg)';

  @override
  String get imperialUnits => 'Imperial (ft/lbs)';

  @override
  String get biologicalSex => 'Jinsi ta halitta';

  @override
  String get male => 'Namiji';

  @override
  String get female => 'Mace';

  @override
  String get height => 'Tsawo';

  @override
  String get weight => 'Nauyi';

  @override
  String get age => 'Shekaru';

  @override
  String get years => 'shk';

  @override
  String get healthConditions => 'Yanayin Lafiya (zaɓi)';

  @override
  String get pregnancyStatus => 'Yanayin Ciki (zaɓi)';

  @override
  String get prePregnancyWeight => 'Nauyi kafin ciki (zaɓi)';

  @override
  String get weightInKg => 'Nauyi a kg';

  @override
  String get weightInLbs => 'Nauyi a lbs';

  @override
  String get calculateBmi => 'Ƙidaya BMI';

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
  String get selectGenderError => 'Don Allah zaɓi jinsinka don ci gaba';

  @override
  String get signInToSave => 'Don Allah shiga don adana lissafi';

  @override
  String get shortUnderweight => '· Ƙarancin nauyi';

  @override
  String get shortNormal => '· Al\'ada';

  @override
  String get shortOverweight => '· Yawan nauyi';

  @override
  String get shortObese => '· Kiba';

  @override
  String get yourResults => 'Sakamakon Ku';

  @override
  String get bodyMassIndex => 'Gwajin Nauyin Jiki';

  @override
  String get whatThisMeans => 'Menene ma\'anar wannan';

  @override
  String get idealWeightRange => 'Kewayon Nauyi Mafi Kyau';

  @override
  String get minLabel => 'Ƙarami';

  @override
  String get maxLabel => 'Mafi girma';

  @override
  String get dailyCalories => 'Adadin Kalori Kowace Rana';

  @override
  String get kcalPerDay => 'kcal/rana';

  @override
  String get waterIntake => 'Shan Ruwa';

  @override
  String get litresPerDay => 'lita/rana';

  @override
  String get healthConsideration => 'Gargaɗi na Lafiya';

  @override
  String get nutritionRecommendations => 'Shawarwarin Abinci Mai Gina Jiki';

  @override
  String get dailyMealPlan => 'Shirin Abinci na Kowace Rana';

  @override
  String get macronutrientBalance => 'Daidaituwar Abinci Mai Gina Jiki';

  @override
  String get focusFoods => 'Abincin Mafi Muhimmanci';

  @override
  String get keyRecommendations => 'Muhimman Shawarwari';

  @override
  String get bmiScale => 'Ma\'aunin BMI';

  @override
  String get reCalculate => 'Ƙidaya Sake';

  @override
  String get resultCopied => 'An kwafi sakamakon!';

  @override
  String get copyToClipboard => 'Kwafi sakamakon';

  @override
  String moreRecommendations(int count) {
    return '... da kuma shawarwari $count ƙari';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'BMI na shine $bmi — $category\n$interpretation\nAn bincika da BMI Calculator App';
  }

  @override
  String get bmiSeverelyUnderweight => 'Ƙarancin Nauyi Sosai';

  @override
  String get bmiUnderweight => 'Ƙarancin Nauyi';

  @override
  String get bmiNormalWeight => 'Nauyin Al\'ada';

  @override
  String get bmiOverweight => 'Yawan Nauyi';

  @override
  String get bmiObeseI => 'Kiba Daraja na I';

  @override
  String get bmiObeseII => 'Kiba Daraja na II';

  @override
  String get bmiSeverelyObese => 'Kiba Mai Tsanani';

  @override
  String get profile => 'Bayanai na';

  @override
  String get edit => 'Gyara';

  @override
  String get cancel => 'Soke';

  @override
  String get save => 'Adana';

  @override
  String get guestUser => 'Baƙon Mai amfani';

  @override
  String get guestModeLocal =>
      'Yanayin baƙo · bayanan an adana a wannan na\'ura';

  @override
  String get guestModeBanner =>
      'Yanayin baƙo — an adana bayanan a wannan na\'ura kawai. Ƙirƙiri asusun don daidaita tsakanin na\'urorin.';

  @override
  String get personalInformation => 'Bayanan Kai';

  @override
  String get fullName => 'Cikakken suna';

  @override
  String get email => 'Imel';

  @override
  String get phone => 'Waya';

  @override
  String get notAvailable => 'Babu';

  @override
  String get account => 'Asusun';

  @override
  String get totalChecks => 'Jimillar Gwaji';

  @override
  String get averageBmi => 'Matsakaicin BMI';

  @override
  String get createAccount => 'Ƙirƙiri Asusun';

  @override
  String get signIn => 'Shiga';

  @override
  String get changePassword => 'Canza Kalmar Sirri';

  @override
  String get deleteAccount => 'Share Asusun';

  @override
  String get leaveGuestMode => 'Fita Daga Yanayin Baƙo';

  @override
  String get signOut => 'Fita';

  @override
  String get profileUpdated => 'An sabunta bayanai';

  @override
  String get leaveGuestTitle => 'Fita daga yanayin baƙo?';

  @override
  String get signOutTitle => 'Fita?';

  @override
  String get leaveGuestContent =>
      'Za a share bayananku na gida. Shiga ko ƙirƙiri asusun don adana tarihin ku.';

  @override
  String get signOutContent => 'Zaku iya shiga sake a kowane lokaci.';

  @override
  String get leave => 'Fita';

  @override
  String get deleteAccountTitle => 'Share asusun?';

  @override
  String get deleteAccountContent =>
      'Wannan zai share asusun ku da duk bayananku har abada. Ba za a iya mayar da hankali ba.';

  @override
  String get delete => 'Share';

  @override
  String get language => 'Harshe';

  @override
  String get selectLanguage => 'Zaɓi harshe';

  @override
  String get welcomeBack => 'Barka da dawowar ku';

  @override
  String get signInToContinue => 'Shiga don ci gaba';

  @override
  String get emailAddress => 'Adireshin imel';

  @override
  String get password => 'Kalmar sirri';

  @override
  String get forgotPassword => 'Kun manta kalmar sirri?';

  @override
  String get continueAsGuest => 'Ci gaba a matsayin baƙo';

  @override
  String get dontHaveAccount => 'Babu asusun?';

  @override
  String get createOne => 'Ƙirƙiri ɗaya';

  @override
  String get emailRequired => 'Ana buƙatar imel';

  @override
  String get emailInvalid => 'Shigar da adireshin imel mai inganci';

  @override
  String get passwordRequired => 'Ana buƙatar kalmar sirri';

  @override
  String get passwordTooShort =>
      'Kalmar sirri dole ta kasance haruffa 6 aƙalla';

  @override
  String get createAccountTitle => 'Ƙirƙiri Asusun';

  @override
  String get startTrackingToday => 'Fara binciken lafiyar ku yau';

  @override
  String get phoneNumber => 'Lambar waya';

  @override
  String get confirmPassword => 'Tabbatar da kalmar sirri';

  @override
  String get alreadyHaveAccount => 'Kuna da asusun?';

  @override
  String get signInLink => 'Shiga';

  @override
  String get nameRequired => 'Ana buƙatar suna';

  @override
  String get nameShort => 'Shigar da cikakken sunanka';

  @override
  String get phoneRequired => 'Ana buƙatar lambar waya';

  @override
  String get phoneInvalid => 'Shigar da lambar waya mai inganci';

  @override
  String get confirmPasswordRequired => 'Don Allah tabbatar da kalmar sirri';

  @override
  String get passwordsDoNotMatch => 'Kalmomin sirri bai yi daidai ba';

  @override
  String passwordStrengthLabel(String level) {
    return 'Ƙarfin kalmar sirri: $level';
  }

  @override
  String get passwordWeak => 'Mai rauni';

  @override
  String get passwordMedium => 'Matsakaici';

  @override
  String get passwordStrong => 'Mai ƙarfi';

  @override
  String get resetPasswordTitle => 'Sake Saita Kalmar Sirri';

  @override
  String get resetPasswordSubtitle =>
      'Shigar da imelku kuma za mu aika muku da haɗin don sake saita kalmar sirri.';

  @override
  String get sendResetLink => 'Aika Haɗin';

  @override
  String get checkInbox => 'Bincika akwatin saƙon ku';

  @override
  String resetLinkSentTo(String email) {
    return 'Mun aika da haɗin sake saita kalmar sirri zuwa\n$email';
  }

  @override
  String get backToSignIn => 'Koma shiga';

  @override
  String get noHistoryYet => 'Babu tarihi tukuna';

  @override
  String get noHistorySubtitle =>
      'Ƙidaya BMI ku a cikin shafin Ƙidaya kuma tarihin ku zai bayyana a nan.';

  @override
  String get today => 'Yau';

  @override
  String get yesterday => 'Jiya';

  @override
  String get yourProgress => 'Ci Gabanka';

  @override
  String entriesCount(int count) {
    return 'bayanai $count';
  }

  @override
  String entryCount(int count) {
    return 'bayani $count';
  }

  @override
  String get average => 'Matsakaici';

  @override
  String get lowest => 'Ƙarami';

  @override
  String get highest => 'Mafi girma';

  @override
  String get trend => 'Yanayi';

  @override
  String get deleteRecordTitle => 'Share rikodin?';

  @override
  String get deleteRecordContent => 'Za a share wannan rikodin BMI har abada.';

  @override
  String get failedToLoadHistory => 'Kasa loda tarihi';

  @override
  String get retry => 'Gwada sake';

  @override
  String get avgBmi => 'Matsakaicin BMI';

  @override
  String get latestBmi => 'BMI na Ƙarshe';

  @override
  String get bestBmi => 'Mafi Kyawun BMI';

  @override
  String get bmiTrend => 'Yanayin BMI';

  @override
  String lastNMeasurements(int count) {
    return 'Aunannin $count na ƙarshe';
  }

  @override
  String get categoryDistribution => 'Rarraba Rukuni';

  @override
  String basedOnAllRecords(int count) {
    return 'Bisa ga rikodin $count duka';
  }

  @override
  String get recentMeasurements => 'Aunannin Kwanan Nan';

  @override
  String get last5Entries => 'Bayanai 5 na ƙarshe';

  @override
  String get noDataYet => 'Babu bayanai tukuna';

  @override
  String get noDataSubtitle =>
      'Fara binciken BMI ku kuma kididdigan ku zai bayyana a nan.';

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
