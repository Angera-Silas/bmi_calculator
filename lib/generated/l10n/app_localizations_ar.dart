// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حاسبة مؤشر كتلة الجسم';

  @override
  String get appTagline => 'تتبع · افهم · تحسّن';

  @override
  String get trackHealthJourney => 'تتبع رحلتك الصحية';

  @override
  String get tabCalculate => 'احسب';

  @override
  String get tabHistory => 'السجل';

  @override
  String get tabInsights => 'الإحصاءات';

  @override
  String get subtitleCalculate => 'أدخل قياساتك أدناه';

  @override
  String get subtitleHistory => 'حسابات مؤشر كتلة الجسم السابقة';

  @override
  String get subtitleInsights => 'الاتجاهات والتحليلات';

  @override
  String get liveBmiPreview => 'معاينة مؤشر كتلة الجسم';

  @override
  String get metricUnits => 'متري (سم/كغ)';

  @override
  String get imperialUnits => 'إمبراطوري (قدم/رطل)';

  @override
  String get biologicalSex => 'الجنس البيولوجي';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get height => 'الطول';

  @override
  String get weight => 'الوزن';

  @override
  String get age => 'العمر';

  @override
  String get years => 'سنة';

  @override
  String get healthConditions => 'الحالات الصحية (اختياري)';

  @override
  String get pregnancyStatus => 'حالة الحمل (اختياري)';

  @override
  String get prePregnancyWeight => 'الوزن قبل الحمل (اختياري)';

  @override
  String get weightInKg => 'الوزن بالكيلوغرام';

  @override
  String get weightInLbs => 'الوزن بالرطل';

  @override
  String get calculateBmi => 'احسب مؤشر كتلة الجسم';

  @override
  String get selectGenderError => 'الرجاء اختيار جنسك للمتابعة';

  @override
  String get signInToSave => 'الرجاء تسجيل الدخول لحفظ الحساب';

  @override
  String get shortUnderweight => '· نقص الوزن';

  @override
  String get shortNormal => '· طبيعي';

  @override
  String get shortOverweight => '· زيادة الوزن';

  @override
  String get shortObese => '· سمنة';

  @override
  String get yourResults => 'نتائجك';

  @override
  String get bodyMassIndex => 'مؤشر كتلة الجسم';

  @override
  String get whatThisMeans => 'ماذا يعني هذا';

  @override
  String get idealWeightRange => 'نطاق الوزن المثالي';

  @override
  String get minLabel => 'أدنى';

  @override
  String get maxLabel => 'أعلى';

  @override
  String get dailyCalories => 'السعرات اليومية';

  @override
  String get kcalPerDay => 'سعرة/يوم';

  @override
  String get waterIntake => 'كمية الماء';

  @override
  String get litresPerDay => 'لتر/يوم';

  @override
  String get healthConsideration => 'اعتبار صحي';

  @override
  String get nutritionRecommendations => 'التوصيات الغذائية';

  @override
  String get dailyMealPlan => 'خطة الوجبات اليومية';

  @override
  String get macronutrientBalance => 'توازن المغذيات الكبرى';

  @override
  String get focusFoods => 'الأطعمة الأساسية';

  @override
  String get keyRecommendations => 'التوصيات الرئيسية';

  @override
  String get bmiScale => 'مقياس مؤشر كتلة الجسم';

  @override
  String get reCalculate => 'إعادة الحساب';

  @override
  String get resultCopied => 'تم نسخ النتيجة إلى الحافظة!';

  @override
  String get copyToClipboard => 'نسخ إلى الحافظة';

  @override
  String moreRecommendations(int count) {
    return '... و$count توصيات إضافية';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'مؤشر كتلة جسمي $bmi — $category\n$interpretation\nتم التتبع بتطبيق BMI Calculator';
  }

  @override
  String get bmiSeverelyUnderweight => 'نقص وزن حاد';

  @override
  String get bmiUnderweight => 'نقص الوزن';

  @override
  String get bmiNormalWeight => 'وزن طبيعي';

  @override
  String get bmiOverweight => 'زيادة الوزن';

  @override
  String get bmiObeseI => 'سمنة الدرجة الأولى';

  @override
  String get bmiObeseII => 'سمنة الدرجة الثانية';

  @override
  String get bmiSeverelyObese => 'سمنة مفرطة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get edit => 'تعديل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get guestUser => 'مستخدم ضيف';

  @override
  String get guestModeLocal => 'وضع الضيف · البيانات محلية فقط';

  @override
  String get guestModeBanner =>
      'وضع الضيف — البيانات محلية فقط. أنشئ حسابًا للمزامنة عبر الأجهزة.';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'الهاتف';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get account => 'الحساب';

  @override
  String get totalChecks => 'إجمالي الفحوصات';

  @override
  String get averageBmi => 'متوسط مؤشر كتلة الجسم';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get leaveGuestMode => 'الخروج من وضع الضيف';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get leaveGuestTitle => 'الخروج من وضع الضيف؟';

  @override
  String get signOutTitle => 'تسجيل الخروج؟';

  @override
  String get leaveGuestContent =>
      'سيتم مسح بياناتك المحلية. سجّل دخولك أو أنشئ حسابًا للاحتفاظ بسجلك.';

  @override
  String get signOutContent =>
      'يمكنك تسجيل الدخول في أي وقت للوصول إلى بياناتك المتزامنة.';

  @override
  String get leave => 'خروج';

  @override
  String get deleteAccountTitle => 'حذف الحساب؟';

  @override
  String get deleteAccountContent =>
      'سيؤدي هذا إلى حذف حسابك وجميع بياناتك نهائيًا. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get delete => 'حذف';

  @override
  String get language => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get signInToContinue => 'سجّل دخولك للمتابعة';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get continueAsGuest => 'المتابعة كضيف';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get createOne => 'أنشئ حسابًا';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get createAccountTitle => 'إنشاء حساب';

  @override
  String get startTrackingToday => 'ابدأ بتتبع صحتك اليوم';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signInLink => 'تسجيل الدخول';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get nameShort => 'أدخل اسمك الكامل';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get phoneInvalid => 'أدخل رقم هاتف صحيح';

  @override
  String get confirmPasswordRequired => 'الرجاء تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String passwordStrengthLabel(String level) {
    return 'قوة كلمة المرور: $level';
  }

  @override
  String get passwordWeak => 'ضعيفة';

  @override
  String get passwordMedium => 'متوسطة';

  @override
  String get passwordStrong => 'قوية';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get sendResetLink => 'إرسال الرابط';

  @override
  String get checkInbox => 'تحقق من بريدك الوارد';

  @override
  String resetLinkSentTo(String email) {
    return 'أرسلنا رابط إعادة تعيين كلمة المرور إلى\n$email';
  }

  @override
  String get backToSignIn => 'العودة لتسجيل الدخول';

  @override
  String get noHistoryYet => 'لا يوجد سجل بعد';

  @override
  String get noHistorySubtitle =>
      'احسب مؤشر كتلة جسمك في التبويب الرئيسي وسيظهر سجلك هنا.';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get yourProgress => 'تقدمك';

  @override
  String entriesCount(int count) {
    return '$count إدخالات';
  }

  @override
  String entryCount(int count) {
    return '$count إدخال';
  }

  @override
  String get average => 'متوسط';

  @override
  String get lowest => 'أدنى';

  @override
  String get highest => 'أعلى';

  @override
  String get trend => 'الاتجاه';

  @override
  String get deleteRecordTitle => 'حذف السجل؟';

  @override
  String get deleteRecordContent =>
      'سيؤدي هذا إلى حذف سجل مؤشر كتلة الجسم نهائيًا.';

  @override
  String get failedToLoadHistory => 'فشل تحميل السجل';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get avgBmi => 'متوسط المؤشر';

  @override
  String get latestBmi => 'آخر قراءة';

  @override
  String get bestBmi => 'أفضل قراءة';

  @override
  String get bmiTrend => 'اتجاه المؤشر';

  @override
  String lastNMeasurements(int count) {
    return 'آخر $count قياسات';
  }

  @override
  String get categoryDistribution => 'توزيع الفئات';

  @override
  String basedOnAllRecords(int count) {
    return 'بناءً على $count سجل';
  }

  @override
  String get recentMeasurements => 'القياسات الأخيرة';

  @override
  String get last5Entries => 'آخر 5 إدخالات';

  @override
  String get noDataYet => 'لا توجد بيانات بعد';

  @override
  String get noDataSubtitle => 'ابدأ بتتبع مؤشر كتلة جسمك وستظهر إحصاءاتك هنا.';
}
