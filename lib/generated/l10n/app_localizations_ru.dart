// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Калькулятор ИМТ';

  @override
  String get appTagline => 'Отслеживай · Понимай · Улучшай';

  @override
  String get trackHealthJourney => 'Следите за своим здоровьем';

  @override
  String get tabCalculate => 'Расчёт';

  @override
  String get tabHistory => 'История';

  @override
  String get tabInsights => 'Статистика';

  @override
  String get subtitleCalculate => 'Введите ваши данные ниже';

  @override
  String get subtitleHistory => 'Ваши предыдущие расчёты ИМТ';

  @override
  String get subtitleInsights => 'Тенденции и аналитика';

  @override
  String get liveBmiPreview => 'Предварительный просмотр ИМТ';

  @override
  String get metricUnits => 'Метрическая (см/кг)';

  @override
  String get imperialUnits => 'Имперская (фут/фунт)';

  @override
  String get biologicalSex => 'Биологический пол';

  @override
  String get male => 'Мужской';

  @override
  String get female => 'Женский';

  @override
  String get height => 'Рост';

  @override
  String get weight => 'Вес';

  @override
  String get age => 'Возраст';

  @override
  String get years => 'лет';

  @override
  String get healthConditions => 'Состояние здоровья (необязательно)';

  @override
  String get pregnancyStatus => 'Статус беременности (необязательно)';

  @override
  String get prePregnancyWeight => 'Вес до беременности (необязательно)';

  @override
  String get weightInKg => 'Вес в кг';

  @override
  String get weightInLbs => 'Вес в фунтах';

  @override
  String get calculateBmi => 'Рассчитать ИМТ';

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
  String get selectGenderError => 'Пожалуйста, выберите пол для продолжения';

  @override
  String get signInToSave => 'Войдите, чтобы сохранить расчёт';

  @override
  String get shortUnderweight => '· Недовес';

  @override
  String get shortNormal => '· Норма';

  @override
  String get shortOverweight => '· Избыточный вес';

  @override
  String get shortObese => '· Ожирение';

  @override
  String get yourResults => 'Ваши результаты';

  @override
  String get bodyMassIndex => 'Индекс массы тела';

  @override
  String get whatThisMeans => 'Что это означает';

  @override
  String get idealWeightRange => 'Идеальный диапазон веса';

  @override
  String get minLabel => 'Мин';

  @override
  String get maxLabel => 'Макс';

  @override
  String get dailyCalories => 'Суточные калории';

  @override
  String get kcalPerDay => 'ккал/день';

  @override
  String get waterIntake => 'Потребление воды';

  @override
  String get litresPerDay => 'л/день';

  @override
  String get healthConsideration => 'Важно для здоровья';

  @override
  String get nutritionRecommendations => 'Рекомендации по питанию';

  @override
  String get dailyMealPlan => 'Дневной план питания';

  @override
  String get macronutrientBalance => 'Баланс макронутриентов';

  @override
  String get focusFoods => 'Ключевые продукты';

  @override
  String get keyRecommendations => 'Ключевые рекомендации';

  @override
  String get bmiScale => 'Шкала ИМТ';

  @override
  String get reCalculate => 'Пересчитать';

  @override
  String get resultCopied => 'Результат скопирован в буфер обмена!';

  @override
  String get copyToClipboard => 'Копировать в буфер';

  @override
  String moreRecommendations(int count) {
    return '... и ещё $count рекомендаций';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'Мой ИМТ: $bmi — $category\n$interpretation\nОтслежено с BMI Calculator App';
  }

  @override
  String get bmiSeverelyUnderweight => 'Выраженный дефицит веса';

  @override
  String get bmiUnderweight => 'Недостаточный вес';

  @override
  String get bmiNormalWeight => 'Нормальный вес';

  @override
  String get bmiOverweight => 'Избыточный вес';

  @override
  String get bmiObeseI => 'Ожирение I степени';

  @override
  String get bmiObeseII => 'Ожирение II степени';

  @override
  String get bmiSeverelyObese => 'Ожирение III степени';

  @override
  String get profile => 'Профиль';

  @override
  String get edit => 'Редактировать';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get guestUser => 'Гость';

  @override
  String get guestModeLocal => 'Гостевой режим · данные только локально';

  @override
  String get guestModeBanner =>
      'Гостевой режим — данные хранятся только на устройстве. Создайте аккаунт для синхронизации.';

  @override
  String get personalInformation => 'Личная информация';

  @override
  String get fullName => 'Полное имя';

  @override
  String get email => 'Эл. почта';

  @override
  String get phone => 'Телефон';

  @override
  String get notAvailable => 'Н/Д';

  @override
  String get account => 'Аккаунт';

  @override
  String get totalChecks => 'Всего замеров';

  @override
  String get averageBmi => 'Средний ИМТ';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get signIn => 'Войти';

  @override
  String get changePassword => 'Изменить пароль';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get leaveGuestMode => 'Выйти из гостевого режима';

  @override
  String get signOut => 'Выйти';

  @override
  String get profileUpdated => 'Профиль обновлён';

  @override
  String get leaveGuestTitle => 'Выйти из гостевого режима?';

  @override
  String get signOutTitle => 'Выйти?';

  @override
  String get leaveGuestContent =>
      'Локальные данные будут удалены. Войдите или создайте аккаунт, чтобы сохранить историю.';

  @override
  String get signOutContent => 'Вы можете войти снова в любое время.';

  @override
  String get leave => 'Выйти';

  @override
  String get deleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountContent =>
      'Аккаунт и все данные будут удалены безвозвратно.';

  @override
  String get delete => 'Удалить';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get signInToContinue => 'Войдите для продолжения';

  @override
  String get emailAddress => 'Адрес эл. почты';

  @override
  String get password => 'Пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get continueAsGuest => 'Продолжить как гость';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get createOne => 'Создать';

  @override
  String get emailRequired => 'Введите адрес эл. почты';

  @override
  String get emailInvalid => 'Введите корректный адрес эл. почты';

  @override
  String get passwordRequired => 'Введите пароль';

  @override
  String get passwordTooShort => 'Пароль должен содержать не менее 6 символов';

  @override
  String get createAccountTitle => 'Создать аккаунт';

  @override
  String get startTrackingToday => 'Начните следить за здоровьем сегодня';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get signInLink => 'Войти';

  @override
  String get nameRequired => 'Введите имя';

  @override
  String get nameShort => 'Введите полное имя';

  @override
  String get phoneRequired => 'Введите номер телефона';

  @override
  String get phoneInvalid => 'Введите корректный номер телефона';

  @override
  String get confirmPasswordRequired => 'Подтвердите пароль';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String passwordStrengthLabel(String level) {
    return 'Надёжность пароля: $level';
  }

  @override
  String get passwordWeak => 'Слабый';

  @override
  String get passwordMedium => 'Средний';

  @override
  String get passwordStrong => 'Надёжный';

  @override
  String get resetPasswordTitle => 'Сброс пароля';

  @override
  String get resetPasswordSubtitle =>
      'Введите адрес эл. почты и мы отправим ссылку для сброса пароля.';

  @override
  String get sendResetLink => 'Отправить ссылку';

  @override
  String get checkInbox => 'Проверьте входящие';

  @override
  String resetLinkSentTo(String email) {
    return 'Ссылка для сброса пароля отправлена на\n$email';
  }

  @override
  String get backToSignIn => 'Вернуться ко входу';

  @override
  String get noHistoryYet => 'История пуста';

  @override
  String get noHistorySubtitle =>
      'Рассчитайте ИМТ на вкладке «Расчёт», и история появится здесь.';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get yourProgress => 'Ваш прогресс';

  @override
  String entriesCount(int count) {
    return '$count записей';
  }

  @override
  String entryCount(int count) {
    return '$count запись';
  }

  @override
  String get average => 'Среднее';

  @override
  String get lowest => 'Минимум';

  @override
  String get highest => 'Максимум';

  @override
  String get trend => 'Тренд';

  @override
  String get deleteRecordTitle => 'Удалить запись?';

  @override
  String get deleteRecordContent =>
      'Эта запись ИМТ будет удалена безвозвратно.';

  @override
  String get failedToLoadHistory => 'Не удалось загрузить историю';

  @override
  String get retry => 'Повторить';

  @override
  String get avgBmi => 'Ср. ИМТ';

  @override
  String get latestBmi => 'Последний ИМТ';

  @override
  String get bestBmi => 'Лучший ИМТ';

  @override
  String get bmiTrend => 'Тренд ИМТ';

  @override
  String lastNMeasurements(int count) {
    return 'Последние $count измерений';
  }

  @override
  String get categoryDistribution => 'Распределение по категориям';

  @override
  String basedOnAllRecords(int count) {
    return 'На основе $count записей';
  }

  @override
  String get recentMeasurements => 'Последние измерения';

  @override
  String get last5Entries => 'Последние 5 записей';

  @override
  String get noDataYet => 'Нет данных';

  @override
  String get noDataSubtitle =>
      'Начните отслеживать ИМТ, и статистика появится здесь.';

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
