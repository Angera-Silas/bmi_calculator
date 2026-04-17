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
}
