// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BMI计算器';

  @override
  String get appTagline => '跟踪 · 了解 · 改善';

  @override
  String get trackHealthJourney => '跟踪您的健康之旅';

  @override
  String get tabCalculate => '计算';

  @override
  String get tabHistory => '历史';

  @override
  String get tabInsights => '统计';

  @override
  String get subtitleCalculate => '在下方输入您的数据';

  @override
  String get subtitleHistory => '您的历次BMI计算';

  @override
  String get subtitleInsights => '趋势与分析';

  @override
  String get liveBmiPreview => 'BMI实时预览';

  @override
  String get metricUnits => '公制 (cm/kg)';

  @override
  String get imperialUnits => '英制 (ft/lbs)';

  @override
  String get biologicalSex => '生理性别';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get height => '身高';

  @override
  String get weight => '体重';

  @override
  String get age => '年龄';

  @override
  String get years => '岁';

  @override
  String get healthConditions => '健康状况（可选）';

  @override
  String get pregnancyStatus => '怀孕状态（可选）';

  @override
  String get prePregnancyWeight => '孕前体重（可选）';

  @override
  String get weightInKg => '体重（千克）';

  @override
  String get weightInLbs => '体重（磅）';

  @override
  String get calculateBmi => '计算BMI';

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
  String get selectGenderError => '请选择性别以继续';

  @override
  String get signInToSave => '请登录以保存计算结果';

  @override
  String get shortUnderweight => '· 体重不足';

  @override
  String get shortNormal => '· 正常';

  @override
  String get shortOverweight => '· 超重';

  @override
  String get shortObese => '· 肥胖';

  @override
  String get yourResults => '您的结果';

  @override
  String get bodyMassIndex => '身体质量指数';

  @override
  String get whatThisMeans => '这意味着什么';

  @override
  String get idealWeightRange => '理想体重范围';

  @override
  String get minLabel => '最小';

  @override
  String get maxLabel => '最大';

  @override
  String get dailyCalories => '每日卡路里';

  @override
  String get kcalPerDay => '千卡/天';

  @override
  String get waterIntake => '每日饮水量';

  @override
  String get litresPerDay => '升/天';

  @override
  String get healthConsideration => '健康注意事项';

  @override
  String get nutritionRecommendations => '营养建议';

  @override
  String get dailyMealPlan => '每日饮食计划';

  @override
  String get macronutrientBalance => '宏量营养素平衡';

  @override
  String get focusFoods => '重点食物';

  @override
  String get keyRecommendations => '关键建议';

  @override
  String get bmiScale => 'BMI量表';

  @override
  String get reCalculate => '重新计算';

  @override
  String get resultCopied => '结果已复制到剪贴板！';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String moreRecommendations(int count) {
    return '...还有$count条建议';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return '我的BMI是$bmi — $category\n$interpretation\n通过BMI Calculator App记录';
  }

  @override
  String get bmiSeverelyUnderweight => '严重体重不足';

  @override
  String get bmiUnderweight => '体重不足';

  @override
  String get bmiNormalWeight => '正常体重';

  @override
  String get bmiOverweight => '超重';

  @override
  String get bmiObeseI => '肥胖I级';

  @override
  String get bmiObeseII => '肥胖II级';

  @override
  String get bmiSeverelyObese => '极度肥胖';

  @override
  String get profile => '个人资料';

  @override
  String get edit => '编辑';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get guestUser => '访客用户';

  @override
  String get guestModeLocal => '访客模式 · 数据仅存储在本地';

  @override
  String get guestModeBanner => '访客模式 — 数据仅存储在本地。创建账号以在设备间同步。';

  @override
  String get personalInformation => '个人信息';

  @override
  String get fullName => '全名';

  @override
  String get email => '电子邮件';

  @override
  String get phone => '电话';

  @override
  String get notAvailable => 'N/A';

  @override
  String get account => '账户';

  @override
  String get totalChecks => '总检测次数';

  @override
  String get averageBmi => '平均BMI';

  @override
  String get createAccount => '创建账号';

  @override
  String get signIn => '登录';

  @override
  String get changePassword => '更改密码';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get leaveGuestMode => '退出访客模式';

  @override
  String get signOut => '退出登录';

  @override
  String get profileUpdated => '个人资料已更新';

  @override
  String get leaveGuestTitle => '退出访客模式？';

  @override
  String get signOutTitle => '退出登录？';

  @override
  String get leaveGuestContent => '您的本地数据将被清除。登录或创建账号以保留您的历史记录。';

  @override
  String get signOutContent => '您可以随时重新登录以访问同步数据。';

  @override
  String get leave => '离开';

  @override
  String get deleteAccountTitle => '删除账号？';

  @override
  String get deleteAccountContent => '这将永久删除您的账号和所有数据，此操作无法撤销。';

  @override
  String get delete => '删除';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get signInToContinue => '登录以继续';

  @override
  String get emailAddress => '电子邮件地址';

  @override
  String get password => '密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get continueAsGuest => '以访客身份继续';

  @override
  String get dontHaveAccount => '没有账号？';

  @override
  String get createOne => '创建一个';

  @override
  String get emailRequired => '电子邮件为必填项';

  @override
  String get emailInvalid => '请输入有效的电子邮件地址';

  @override
  String get passwordRequired => '密码为必填项';

  @override
  String get passwordTooShort => '密码至少需要6个字符';

  @override
  String get createAccountTitle => '创建账号';

  @override
  String get startTrackingToday => '今天开始追踪您的健康';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get alreadyHaveAccount => '已有账号？';

  @override
  String get signInLink => '登录';

  @override
  String get nameRequired => '姓名为必填项';

  @override
  String get nameShort => '请输入您的全名';

  @override
  String get phoneRequired => '电话号码为必填项';

  @override
  String get phoneInvalid => '请输入有效的电话号码';

  @override
  String get confirmPasswordRequired => '请确认您的密码';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不匹配';

  @override
  String passwordStrengthLabel(String level) {
    return '密码强度：$level';
  }

  @override
  String get passwordWeak => '弱';

  @override
  String get passwordMedium => '中';

  @override
  String get passwordStrong => '强';

  @override
  String get resetPasswordTitle => '重置密码';

  @override
  String get resetPasswordSubtitle => '输入您的电子邮件地址，我们将发送重置密码链接。';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get checkInbox => '查看您的收件箱';

  @override
  String resetLinkSentTo(String email) {
    return '我们已发送密码重置链接至\n$email';
  }

  @override
  String get backToSignIn => '返回登录';

  @override
  String get noHistoryYet => '暂无历史记录';

  @override
  String get noHistorySubtitle => '在首页计算您的BMI，历史记录将显示在此处。';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get yourProgress => '您的进度';

  @override
  String entriesCount(int count) {
    return '$count条记录';
  }

  @override
  String entryCount(int count) {
    return '$count条记录';
  }

  @override
  String get average => '平均';

  @override
  String get lowest => '最低';

  @override
  String get highest => '最高';

  @override
  String get trend => '趋势';

  @override
  String get deleteRecordTitle => '删除记录？';

  @override
  String get deleteRecordContent => '此BMI记录将被永久删除。';

  @override
  String get failedToLoadHistory => '加载历史记录失败';

  @override
  String get retry => '重试';

  @override
  String get avgBmi => '平均BMI';

  @override
  String get latestBmi => '最新BMI';

  @override
  String get bestBmi => '最佳BMI';

  @override
  String get bmiTrend => 'BMI趋势';

  @override
  String lastNMeasurements(int count) {
    return '最近$count次测量';
  }

  @override
  String get categoryDistribution => '类别分布';

  @override
  String basedOnAllRecords(int count) {
    return '基于全部$count条记录';
  }

  @override
  String get recentMeasurements => '最近测量';

  @override
  String get last5Entries => '最近5条';

  @override
  String get noDataYet => '暂无数据';

  @override
  String get noDataSubtitle => '开始追踪您的BMI，统计数据将显示在此处。';

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
