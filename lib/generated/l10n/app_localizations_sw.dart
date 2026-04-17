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
}
