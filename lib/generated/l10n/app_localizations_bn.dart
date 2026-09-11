// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'BMI ক্যালকুলেটর';

  @override
  String get appTagline => 'ট্র্যাক করুন · বুঝুন · উন্নত করুন';

  @override
  String get trackHealthJourney => 'আপনার স্বাস্থ্য যাত্রা ট্র্যাক করুন';

  @override
  String get tabCalculate => 'হিসাব';

  @override
  String get tabHistory => 'ইতিহাস';

  @override
  String get tabInsights => 'বিশ্লেষণ';

  @override
  String get subtitleCalculate => 'নিচে আপনার পরিমাপ দিন';

  @override
  String get subtitleHistory => 'আপনার আগের BMI গণনা';

  @override
  String get subtitleInsights => 'প্রবণতা ও বিশ্লেষণ';

  @override
  String get liveBmiPreview => 'লাইভ BMI পূর্বরূপ';

  @override
  String get metricUnits => 'মেট্রিক (cm/kg)';

  @override
  String get imperialUnits => 'ইম্পেরিয়াল (ft/lbs)';

  @override
  String get biologicalSex => 'জৈবিক লিঙ্গ';

  @override
  String get male => 'পুরুষ';

  @override
  String get female => 'মহিলা';

  @override
  String get height => 'উচ্চতা';

  @override
  String get weight => 'ওজন';

  @override
  String get age => 'বয়স';

  @override
  String get years => 'বছর';

  @override
  String get healthConditions => 'স্বাস্থ্য অবস্থা (ঐচ্ছিক)';

  @override
  String get pregnancyStatus => 'গর্ভাবস্থার অবস্থা (ঐচ্ছিক)';

  @override
  String get prePregnancyWeight => 'গর্ভাবস্থার আগের ওজন (ঐচ্ছিক)';

  @override
  String get weightInKg => 'ওজন কিলোগ্রামে';

  @override
  String get weightInLbs => 'ওজন পাউন্ডে';

  @override
  String get calculateBmi => 'BMI হিসাব করুন';

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
  String get selectGenderError => 'চালিয়ে যেতে আপনার লিঙ্গ নির্বাচন করুন';

  @override
  String get signInToSave => 'গণনা সংরক্ষণ করতে সাইন ইন করুন';

  @override
  String get shortUnderweight => '· কম ওজন';

  @override
  String get shortNormal => '· স্বাভাবিক';

  @override
  String get shortOverweight => '· অতিরিক্ত ওজন';

  @override
  String get shortObese => '· স্থূলতা';

  @override
  String get yourResults => 'আপনার ফলাফল';

  @override
  String get bodyMassIndex => 'বডি মাস ইনডেক্স';

  @override
  String get whatThisMeans => 'এর মানে কী';

  @override
  String get idealWeightRange => 'আদর্শ ওজনের পরিসর';

  @override
  String get minLabel => 'সর্বনিম্ন';

  @override
  String get maxLabel => 'সর্বোচ্চ';

  @override
  String get dailyCalories => 'দৈনিক ক্যালোরি';

  @override
  String get kcalPerDay => 'kcal/দিন';

  @override
  String get waterIntake => 'পানি গ্রহণ';

  @override
  String get litresPerDay => 'লিটার/দিন';

  @override
  String get healthConsideration => 'স্বাস্থ্য সংক্রান্ত বিষয়';

  @override
  String get nutritionRecommendations => 'পুষ্টি পরামর্শ';

  @override
  String get dailyMealPlan => 'দৈনিক খাবার পরিকল্পনা';

  @override
  String get macronutrientBalance => 'ম্যাক্রোনিউট্রিয়েন্ট ব্যালেন্স';

  @override
  String get focusFoods => 'মূল খাবার';

  @override
  String get keyRecommendations => 'মূল পরামর্শ';

  @override
  String get bmiScale => 'BMI স্কেল';

  @override
  String get reCalculate => 'পুনরায় হিসাব';

  @override
  String get resultCopied => 'ফলাফল ক্লিপবোর্ডে কপি হয়েছে!';

  @override
  String get copyToClipboard => 'ক্লিপবোর্ডে কপি করুন';

  @override
  String moreRecommendations(int count) {
    return '... এবং আরও $countটি পরামর্শ';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'আমার BMI $bmi — $category\n$interpretation\nBMI Calculator App দিয়ে ট্র্যাক করা';
  }

  @override
  String get bmiSeverelyUnderweight => 'গুরুতর কম ওজন';

  @override
  String get bmiUnderweight => 'কম ওজন';

  @override
  String get bmiNormalWeight => 'স্বাভাবিক ওজন';

  @override
  String get bmiOverweight => 'অতিরিক্ত ওজন';

  @override
  String get bmiObeseI => 'স্থূলতা শ্রেণী I';

  @override
  String get bmiObeseII => 'স্থূলতা শ্রেণী II';

  @override
  String get bmiSeverelyObese => 'গুরুতর স্থূলতা';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get cancel => 'বাতিল';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get guestUser => 'অতিথি ব্যবহারকারী';

  @override
  String get guestModeLocal => 'অতিথি মোড · ডেটা স্থানীয়ভাবে সংরক্ষিত';

  @override
  String get guestModeBanner =>
      'অতিথি মোড — ডেটা শুধুমাত্র স্থানীয়ভাবে সংরক্ষিত। ডিভাইসে সিঙ্ক করতে অ্যাকাউন্ট তৈরি করুন।';

  @override
  String get personalInformation => 'ব্যক্তিগত তথ্য';

  @override
  String get fullName => 'পূর্ণ নাম';

  @override
  String get email => 'ইমেল';

  @override
  String get phone => 'ফোন';

  @override
  String get notAvailable => 'N/A';

  @override
  String get account => 'অ্যাকাউন্ট';

  @override
  String get totalChecks => 'মোট পরীক্ষা';

  @override
  String get averageBmi => 'গড় BMI';

  @override
  String get createAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get changePassword => 'পাসওয়ার্ড পরিবর্তন';

  @override
  String get deleteAccount => 'অ্যাকাউন্ট মুছুন';

  @override
  String get leaveGuestMode => 'অতিথি মোড ছাড়ুন';

  @override
  String get signOut => 'সাইন আউট';

  @override
  String get profileUpdated => 'প্রোফাইল আপডেট হয়েছে';

  @override
  String get leaveGuestTitle => 'অতিথি মোড ছাড়বেন?';

  @override
  String get signOutTitle => 'সাইন আউট করবেন?';

  @override
  String get leaveGuestContent =>
      'আপনার স্থানীয় ডেটা মুছে যাবে। ইতিহাস রাখতে সাইন ইন করুন বা অ্যাকাউন্ট তৈরি করুন।';

  @override
  String get signOutContent => 'আপনি যেকোনো সময় আবার সাইন ইন করতে পারবেন।';

  @override
  String get leave => 'ছাড়ুন';

  @override
  String get deleteAccountTitle => 'অ্যাকাউন্ট মুছবেন?';

  @override
  String get deleteAccountContent =>
      'এটি আপনার অ্যাকাউন্ট এবং সমস্ত ডেটা স্থায়ীভাবে মুছে দেবে। এটি পূর্বাবস্থায় ফেরানো যাবে না।';

  @override
  String get delete => 'মুছুন';

  @override
  String get language => 'ভাষা';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get welcomeBack => 'আবার স্বাগতম';

  @override
  String get signInToContinue => 'চালিয়ে যেতে সাইন ইন করুন';

  @override
  String get emailAddress => 'ইমেল ঠিকানা';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get continueAsGuest => 'অতিথি হিসেবে চালিয়ে যান';

  @override
  String get dontHaveAccount => 'অ্যাকাউন্ট নেই?';

  @override
  String get createOne => 'তৈরি করুন';

  @override
  String get emailRequired => 'ইমেল প্রয়োজন';

  @override
  String get emailInvalid => 'একটি বৈধ ইমেল ঠিকানা দিন';

  @override
  String get passwordRequired => 'পাসওয়ার্ড প্রয়োজন';

  @override
  String get passwordTooShort => 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষর হতে হবে';

  @override
  String get createAccountTitle => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get startTrackingToday => 'আজই আপনার স্বাস্থ্য ট্র্যাকিং শুরু করুন';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get alreadyHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে?';

  @override
  String get signInLink => 'সাইন ইন';

  @override
  String get nameRequired => 'নাম প্রয়োজন';

  @override
  String get nameShort => 'আপনার পূর্ণ নাম দিন';

  @override
  String get phoneRequired => 'ফোন নম্বর প্রয়োজন';

  @override
  String get phoneInvalid => 'একটি বৈধ ফোন নম্বর দিন';

  @override
  String get confirmPasswordRequired => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get passwordsDoNotMatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String passwordStrengthLabel(String level) {
    return 'পাসওয়ার্ডের শক্তি: $level';
  }

  @override
  String get passwordWeak => 'দুর্বল';

  @override
  String get passwordMedium => 'মাঝারি';

  @override
  String get passwordStrong => 'শক্তিশালী';

  @override
  String get resetPasswordTitle => 'পাসওয়ার্ড রিসেট করুন';

  @override
  String get resetPasswordSubtitle =>
      'আপনার ইমেল দিন এবং আমরা পাসওয়ার্ড রিসেট লিঙ্ক পাঠাব।';

  @override
  String get sendResetLink => 'রিসেট লিঙ্ক পাঠান';

  @override
  String get checkInbox => 'আপনার ইনবক্স দেখুন';

  @override
  String resetLinkSentTo(String email) {
    return 'আমরা পাসওয়ার্ড রিসেট লিঙ্ক পাঠিয়েছি\n$email';
  }

  @override
  String get backToSignIn => 'সাইন ইনে ফিরুন';

  @override
  String get noHistoryYet => 'এখনো কোনো ইতিহাস নেই';

  @override
  String get noHistorySubtitle =>
      'হোম ট্যাবে BMI হিসাব করুন এবং আপনার ইতিহাস এখানে দেখা যাবে।';

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String get yourProgress => 'আপনার অগ্রগতি';

  @override
  String entriesCount(int count) {
    return '$countটি এন্ট্রি';
  }

  @override
  String entryCount(int count) {
    return '$countটি এন্ট্রি';
  }

  @override
  String get average => 'গড়';

  @override
  String get lowest => 'সর্বনিম্ন';

  @override
  String get highest => 'সর্বোচ্চ';

  @override
  String get trend => 'প্রবণতা';

  @override
  String get deleteRecordTitle => 'রেকর্ড মুছবেন?';

  @override
  String get deleteRecordContent => 'এই BMI রেকর্ড স্থায়ীভাবে মুছে যাবে।';

  @override
  String get failedToLoadHistory => 'ইতিহাস লোড করতে ব্যর্থ';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get avgBmi => 'গড় BMI';

  @override
  String get latestBmi => 'সর্বশেষ BMI';

  @override
  String get bestBmi => 'সেরা BMI';

  @override
  String get bmiTrend => 'BMI প্রবণতা';

  @override
  String lastNMeasurements(int count) {
    return 'শেষ $countটি পরিমাপ';
  }

  @override
  String get categoryDistribution => 'বিভাগ বিতরণ';

  @override
  String basedOnAllRecords(int count) {
    return '$countটি রেকর্ডের ভিত্তিতে';
  }

  @override
  String get recentMeasurements => 'সাম্প্রতিক পরিমাপ';

  @override
  String get last5Entries => 'শেষ ৫টি এন্ট্রি';

  @override
  String get noDataYet => 'এখনো কোনো ডেটা নেই';

  @override
  String get noDataSubtitle =>
      'BMI ট্র্যাক করা শুরু করুন এবং আপনার বিশ্লেষণ এখানে দেখা যাবে।';

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
