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
}
