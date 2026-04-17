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
}
