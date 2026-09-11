// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'BMI कैलकुलेटर';

  @override
  String get appTagline => 'ट्रैक करें · समझें · सुधारें';

  @override
  String get trackHealthJourney => 'अपनी स्वास्थ्य यात्रा को ट्रैक करें';

  @override
  String get tabCalculate => 'कैलकुलेट';

  @override
  String get tabHistory => 'इतिहास';

  @override
  String get tabInsights => 'विश्लेषण';

  @override
  String get subtitleCalculate => 'नीचे अपनी माप दर्ज करें';

  @override
  String get subtitleHistory => 'आपके पिछले BMI गणनाएं';

  @override
  String get subtitleInsights => 'रुझान और विश्लेषण';

  @override
  String get liveBmiPreview => 'BMI लाइव पूर्वावलोकन';

  @override
  String get metricUnits => 'मेट्रिक (cm/kg)';

  @override
  String get imperialUnits => 'इंपीरियल (ft/lbs)';

  @override
  String get biologicalSex => 'जैविक लिंग';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get height => 'ऊंचाई';

  @override
  String get weight => 'वजन';

  @override
  String get age => 'उम्र';

  @override
  String get years => 'वर्ष';

  @override
  String get healthConditions => 'स्वास्थ्य स्थितियां (वैकल्पिक)';

  @override
  String get pregnancyStatus => 'गर्भावस्था की स्थिति (वैकल्पिक)';

  @override
  String get prePregnancyWeight => 'गर्भावस्था से पहले का वजन (वैकल्पिक)';

  @override
  String get weightInKg => 'वजन किलोग्राम में';

  @override
  String get weightInLbs => 'वजन पाउंड में';

  @override
  String get calculateBmi => 'BMI कैलकुलेट करें';

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
  String get selectGenderError => 'जारी रखने के लिए कृपया अपना लिंग चुनें';

  @override
  String get signInToSave => 'गणना सहेजने के लिए कृपया साइन इन करें';

  @override
  String get shortUnderweight => '· कम वजन';

  @override
  String get shortNormal => '· सामान्य';

  @override
  String get shortOverweight => '· अधिक वजन';

  @override
  String get shortObese => '· मोटापा';

  @override
  String get yourResults => 'आपके परिणाम';

  @override
  String get bodyMassIndex => 'बॉडी मास इंडेक्स';

  @override
  String get whatThisMeans => 'इसका क्या मतलब है';

  @override
  String get idealWeightRange => 'आदर्श वजन सीमा';

  @override
  String get minLabel => 'न्यूनतम';

  @override
  String get maxLabel => 'अधिकतम';

  @override
  String get dailyCalories => 'दैनिक कैलोरी';

  @override
  String get kcalPerDay => 'kcal/दिन';

  @override
  String get waterIntake => 'पानी का सेवन';

  @override
  String get litresPerDay => 'लीटर/दिन';

  @override
  String get healthConsideration => 'स्वास्थ्य संबंधी विचार';

  @override
  String get nutritionRecommendations => 'पोषण संबंधी सिफारिशें';

  @override
  String get dailyMealPlan => 'दैनिक भोजन योजना';

  @override
  String get macronutrientBalance => 'मैक्रोन्यूट्रिएंट संतुलन';

  @override
  String get focusFoods => 'मुख्य खाद्य पदार्थ';

  @override
  String get keyRecommendations => 'मुख्य सिफारिशें';

  @override
  String get bmiScale => 'BMI स्केल';

  @override
  String get reCalculate => 'पुनः गणना';

  @override
  String get resultCopied => 'परिणाम क्लिपबोर्ड पर कॉपी हुआ!';

  @override
  String get copyToClipboard => 'क्लिपबोर्ड पर कॉपी करें';

  @override
  String moreRecommendations(int count) {
    return '... और $count अधिक सिफारिशें';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'मेरा BMI $bmi है — $category\n$interpretation\nBMI Calculator App से ट्रैक किया';
  }

  @override
  String get bmiSeverelyUnderweight => 'गंभीर रूप से कम वजन';

  @override
  String get bmiUnderweight => 'कम वजन';

  @override
  String get bmiNormalWeight => 'सामान्य वजन';

  @override
  String get bmiOverweight => 'अधिक वजन';

  @override
  String get bmiObeseI => 'मोटापा कक्षा I';

  @override
  String get bmiObeseII => 'मोटापा कक्षा II';

  @override
  String get bmiSeverelyObese => 'गंभीर मोटापा';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get edit => 'संपादित करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get guestUser => 'अतिथि उपयोगकर्ता';

  @override
  String get guestModeLocal => 'अतिथि मोड · डेटा स्थानीय रूप से संग्रहीत';

  @override
  String get guestModeBanner =>
      'अतिथि मोड — डेटा केवल स्थानीय रूप से संग्रहीत है। डिवाइस में सिंक करने के लिए खाता बनाएं।';

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get email => 'ईमेल';

  @override
  String get phone => 'फोन';

  @override
  String get notAvailable => 'उपलब्ध नहीं';

  @override
  String get account => 'खाता';

  @override
  String get totalChecks => 'कुल जांच';

  @override
  String get averageBmi => 'औसत BMI';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get leaveGuestMode => 'अतिथि मोड छोड़ें';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get profileUpdated => 'प्रोफ़ाइल अपडेट हुई';

  @override
  String get leaveGuestTitle => 'अतिथि मोड छोड़ें?';

  @override
  String get signOutTitle => 'साइन आउट करें?';

  @override
  String get leaveGuestContent =>
      'आपका स्थानीय डेटा मिट जाएगा। इतिहास रखने के लिए साइन इन करें या खाता बनाएं।';

  @override
  String get signOutContent => 'आप किसी भी समय वापस साइन इन कर सकते हैं।';

  @override
  String get leave => 'छोड़ें';

  @override
  String get deleteAccountTitle => 'खाता हटाएं?';

  @override
  String get deleteAccountContent =>
      'इससे आपका खाता और सभी डेटा स्थायी रूप से हट जाएगा। यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get delete => 'हटाएं';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है';

  @override
  String get signInToContinue => 'जारी रखने के लिए साइन इन करें';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get password => 'पासवर्ड';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get continueAsGuest => 'अतिथि के रूप में जारी रखें';

  @override
  String get dontHaveAccount => 'खाता नहीं है?';

  @override
  String get createOne => 'बनाएं';

  @override
  String get emailRequired => 'ईमेल आवश्यक है';

  @override
  String get emailInvalid => 'एक मान्य ईमेल पता दर्ज करें';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get createAccountTitle => 'खाता बनाएं';

  @override
  String get startTrackingToday => 'आज से अपनी स्वास्थ्य ट्रैकिंग शुरू करें';

  @override
  String get phoneNumber => 'फोन नंबर';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है?';

  @override
  String get signInLink => 'साइन इन करें';

  @override
  String get nameRequired => 'नाम आवश्यक है';

  @override
  String get nameShort => 'अपना पूरा नाम दर्ज करें';

  @override
  String get phoneRequired => 'फोन नंबर आवश्यक है';

  @override
  String get phoneInvalid => 'एक मान्य फोन नंबर दर्ज करें';

  @override
  String get confirmPasswordRequired => 'कृपया पासवर्ड की पुष्टि करें';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String passwordStrengthLabel(String level) {
    return 'पासवर्ड की मजबूती: $level';
  }

  @override
  String get passwordWeak => 'कमजोर';

  @override
  String get passwordMedium => 'मध्यम';

  @override
  String get passwordStrong => 'मजबूत';

  @override
  String get resetPasswordTitle => 'पासवर्ड रीसेट करें';

  @override
  String get resetPasswordSubtitle =>
      'अपना ईमेल पता दर्ज करें और हम आपको पासवर्ड रीसेट लिंक भेजेंगे।';

  @override
  String get sendResetLink => 'रीसेट लिंक भेजें';

  @override
  String get checkInbox => 'अपना इनबॉक्स जांचें';

  @override
  String resetLinkSentTo(String email) {
    return 'हमने पासवर्ड रीसेट लिंक भेजा\n$email';
  }

  @override
  String get backToSignIn => 'साइन इन पर वापस जाएं';

  @override
  String get noHistoryYet => 'अभी तक कोई इतिहास नहीं';

  @override
  String get noHistorySubtitle =>
      'होम टैब पर BMI कैलकुलेट करें और आपका इतिहास यहां दिखेगा।';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get yourProgress => 'आपकी प्रगति';

  @override
  String entriesCount(int count) {
    return '$count प्रविष्टियां';
  }

  @override
  String entryCount(int count) {
    return '$count प्रविष्टि';
  }

  @override
  String get average => 'औसत';

  @override
  String get lowest => 'न्यूनतम';

  @override
  String get highest => 'अधिकतम';

  @override
  String get trend => 'रुझान';

  @override
  String get deleteRecordTitle => 'रिकॉर्ड हटाएं?';

  @override
  String get deleteRecordContent =>
      'यह BMI रिकॉर्ड स्थायी रूप से हटा दिया जाएगा।';

  @override
  String get failedToLoadHistory => 'इतिहास लोड करने में विफल';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get avgBmi => 'औसत BMI';

  @override
  String get latestBmi => 'नवीनतम BMI';

  @override
  String get bestBmi => 'सर्वश्रेष्ठ BMI';

  @override
  String get bmiTrend => 'BMI रुझान';

  @override
  String lastNMeasurements(int count) {
    return 'अंतिम $count माप';
  }

  @override
  String get categoryDistribution => 'श्रेणी वितरण';

  @override
  String basedOnAllRecords(int count) {
    return '$count रिकॉर्ड के आधार पर';
  }

  @override
  String get recentMeasurements => 'हाल के माप';

  @override
  String get last5Entries => 'अंतिम 5 प्रविष्टियां';

  @override
  String get noDataYet => 'अभी तक कोई डेटा नहीं';

  @override
  String get noDataSubtitle =>
      'BMI ट्रैक करना शुरू करें और आपके आंकड़े यहां दिखेंगे।';

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
