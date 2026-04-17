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
}
