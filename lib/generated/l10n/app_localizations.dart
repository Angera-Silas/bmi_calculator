import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ha'),
    Locale('hi'),
    Locale('id'),
    Locale('pt'),
    Locale('ru'),
    Locale('sw'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Track · Understand · Improve'**
  String get appTagline;

  /// No description provided for @trackHealthJourney.
  ///
  /// In en, this message translates to:
  /// **'Track your health journey'**
  String get trackHealthJourney;

  /// No description provided for @tabCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get tabCalculate;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @tabInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get tabInsights;

  /// No description provided for @subtitleCalculate.
  ///
  /// In en, this message translates to:
  /// **'Enter your measurements below'**
  String get subtitleCalculate;

  /// No description provided for @subtitleHistory.
  ///
  /// In en, this message translates to:
  /// **'Your past BMI calculations'**
  String get subtitleHistory;

  /// No description provided for @subtitleInsights.
  ///
  /// In en, this message translates to:
  /// **'Trends and analytics'**
  String get subtitleInsights;

  /// No description provided for @liveBmiPreview.
  ///
  /// In en, this message translates to:
  /// **'Live BMI Preview'**
  String get liveBmiPreview;

  /// No description provided for @metricUnits.
  ///
  /// In en, this message translates to:
  /// **'Metric (cm/kg)'**
  String get metricUnits;

  /// No description provided for @imperialUnits.
  ///
  /// In en, this message translates to:
  /// **'Imperial (ft/lbs)'**
  String get imperialUnits;

  /// No description provided for @biologicalSex.
  ///
  /// In en, this message translates to:
  /// **'Biological sex'**
  String get biologicalSex;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'yrs'**
  String get years;

  /// No description provided for @healthConditions.
  ///
  /// In en, this message translates to:
  /// **'Health Conditions (Optional)'**
  String get healthConditions;

  /// No description provided for @pregnancyStatus.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Status (Optional)'**
  String get pregnancyStatus;

  /// No description provided for @prePregnancyWeight.
  ///
  /// In en, this message translates to:
  /// **'Pre-pregnancy weight (optional)'**
  String get prePregnancyWeight;

  /// No description provided for @weightInKg.
  ///
  /// In en, this message translates to:
  /// **'Weight in kg'**
  String get weightInKg;

  /// No description provided for @weightInLbs.
  ///
  /// In en, this message translates to:
  /// **'Weight in lbs'**
  String get weightInLbs;

  /// No description provided for @calculateBmi.
  ///
  /// In en, this message translates to:
  /// **'Calculate BMI'**
  String get calculateBmi;

  /// No description provided for @invalidMetricInput.
  ///
  /// In en, this message translates to:
  /// **'Please check your measurements — some values are invalid.'**
  String get invalidMetricInput;

  /// No description provided for @advancedMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Metrics (Optional)'**
  String get advancedMetricsTitle;

  /// No description provided for @advancedMetricsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add body measurements for extra health insights (cm / bpm)'**
  String get advancedMetricsSubtitle;

  /// No description provided for @waistCircumference.
  ///
  /// In en, this message translates to:
  /// **'Waist circumference'**
  String get waistCircumference;

  /// No description provided for @waistHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 84'**
  String get waistHint;

  /// No description provided for @neckCircumference.
  ///
  /// In en, this message translates to:
  /// **'Neck circumference'**
  String get neckCircumference;

  /// No description provided for @neckHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 38'**
  String get neckHint;

  /// No description provided for @hipCircumference.
  ///
  /// In en, this message translates to:
  /// **'Hip circumference'**
  String get hipCircumference;

  /// No description provided for @hipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 96'**
  String get hipHint;

  /// No description provided for @restingHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Resting heart rate'**
  String get restingHeartRate;

  /// No description provided for @restingHeartRateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 68'**
  String get restingHeartRateHint;

  /// No description provided for @healthMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Metrics'**
  String get healthMetricsTitle;

  /// No description provided for @waistToHeightRatioLabel.
  ///
  /// In en, this message translates to:
  /// **'Waist-to-Height Ratio'**
  String get waistToHeightRatioLabel;

  /// No description provided for @bodyFatLabel.
  ///
  /// In en, this message translates to:
  /// **'Body Fat'**
  String get bodyFatLabel;

  /// No description provided for @metabolicAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Metabolic Age'**
  String get metabolicAgeLabel;

  /// No description provided for @vo2maxLabel.
  ///
  /// In en, this message translates to:
  /// **'VO2max (estimate)'**
  String get vo2maxLabel;

  /// No description provided for @selectGenderError.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender to continue'**
  String get selectGenderError;

  /// No description provided for @signInToSave.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to save your calculation'**
  String get signInToSave;

  /// No description provided for @shortUnderweight.
  ///
  /// In en, this message translates to:
  /// **'· Underweight'**
  String get shortUnderweight;

  /// No description provided for @shortNormal.
  ///
  /// In en, this message translates to:
  /// **'· Normal'**
  String get shortNormal;

  /// No description provided for @shortOverweight.
  ///
  /// In en, this message translates to:
  /// **'· Overweight'**
  String get shortOverweight;

  /// No description provided for @shortObese.
  ///
  /// In en, this message translates to:
  /// **'· Obese'**
  String get shortObese;

  /// No description provided for @yourResults.
  ///
  /// In en, this message translates to:
  /// **'Your Results'**
  String get yourResults;

  /// No description provided for @bodyMassIndex.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index'**
  String get bodyMassIndex;

  /// No description provided for @whatThisMeans.
  ///
  /// In en, this message translates to:
  /// **'What this means'**
  String get whatThisMeans;

  /// No description provided for @idealWeightRange.
  ///
  /// In en, this message translates to:
  /// **'Ideal Weight Range'**
  String get idealWeightRange;

  /// No description provided for @minLabel.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minLabel;

  /// No description provided for @maxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxLabel;

  /// No description provided for @dailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Daily Calories'**
  String get dailyCalories;

  /// No description provided for @kcalPerDay.
  ///
  /// In en, this message translates to:
  /// **'kcal/day'**
  String get kcalPerDay;

  /// No description provided for @waterIntake.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get waterIntake;

  /// No description provided for @litresPerDay.
  ///
  /// In en, this message translates to:
  /// **'litres/day'**
  String get litresPerDay;

  /// No description provided for @healthConsideration.
  ///
  /// In en, this message translates to:
  /// **'Health Consideration'**
  String get healthConsideration;

  /// No description provided for @nutritionRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Recommendations'**
  String get nutritionRecommendations;

  /// No description provided for @dailyMealPlan.
  ///
  /// In en, this message translates to:
  /// **'Daily Meal Plan'**
  String get dailyMealPlan;

  /// No description provided for @macronutrientBalance.
  ///
  /// In en, this message translates to:
  /// **'Macronutrient Balance'**
  String get macronutrientBalance;

  /// No description provided for @focusFoods.
  ///
  /// In en, this message translates to:
  /// **'Focus Foods'**
  String get focusFoods;

  /// No description provided for @keyRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Key Recommendations'**
  String get keyRecommendations;

  /// No description provided for @bmiScale.
  ///
  /// In en, this message translates to:
  /// **'BMI Scale'**
  String get bmiScale;

  /// No description provided for @reCalculate.
  ///
  /// In en, this message translates to:
  /// **'Re-Calculate'**
  String get reCalculate;

  /// No description provided for @resultCopied.
  ///
  /// In en, this message translates to:
  /// **'Result copied to clipboard!'**
  String get resultCopied;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @moreRecommendations.
  ///
  /// In en, this message translates to:
  /// **'... and {count} more recommendations'**
  String moreRecommendations(int count);

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'My BMI is {bmi} — {category}\n{interpretation}\nTracked with BMI Calculator App'**
  String shareText(String bmi, String category, String interpretation);

  /// No description provided for @bmiSeverelyUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Severely Underweight'**
  String get bmiSeverelyUnderweight;

  /// No description provided for @bmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweight;

  /// No description provided for @bmiNormalWeight.
  ///
  /// In en, this message translates to:
  /// **'Normal Weight'**
  String get bmiNormalWeight;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweight;

  /// No description provided for @bmiObeseI.
  ///
  /// In en, this message translates to:
  /// **'Obese Class I'**
  String get bmiObeseI;

  /// No description provided for @bmiObeseII.
  ///
  /// In en, this message translates to:
  /// **'Obese Class II'**
  String get bmiObeseII;

  /// No description provided for @bmiSeverelyObese.
  ///
  /// In en, this message translates to:
  /// **'Severely Obese'**
  String get bmiSeverelyObese;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @guestModeLocal.
  ///
  /// In en, this message translates to:
  /// **'Guest mode · data stored locally'**
  String get guestModeLocal;

  /// No description provided for @guestModeBanner.
  ///
  /// In en, this message translates to:
  /// **'Guest mode — data is stored locally only. Create an account to sync across devices.'**
  String get guestModeBanner;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @totalChecks.
  ///
  /// In en, this message translates to:
  /// **'Total Checks'**
  String get totalChecks;

  /// No description provided for @averageBmi.
  ///
  /// In en, this message translates to:
  /// **'Average BMI'**
  String get averageBmi;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @leaveGuestMode.
  ///
  /// In en, this message translates to:
  /// **'Leave Guest Mode'**
  String get leaveGuestMode;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @leaveGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave guest mode?'**
  String get leaveGuestTitle;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutTitle;

  /// No description provided for @leaveGuestContent.
  ///
  /// In en, this message translates to:
  /// **'Your local data will be cleared. Sign in or create an account to keep your history.'**
  String get leaveGuestContent;

  /// No description provided for @signOutContent.
  ///
  /// In en, this message translates to:
  /// **'You can sign back in any time to access your synced data.'**
  String get signOutContent;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountContent.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and all data. This cannot be undone.'**
  String get deleteAccountContent;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createOne.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get createOne;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @startTrackingToday.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your health today'**
  String get startTrackingToday;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLink;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nameShort.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get nameShort;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Password strength: {level}'**
  String passwordStrengthLabel(String level);

  /// No description provided for @passwordWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordWeak;

  /// No description provided for @passwordMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get passwordMedium;

  /// No description provided for @passwordStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrong;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @checkInbox.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox'**
  String get checkInbox;

  /// No description provided for @resetLinkSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset link to\n{email}'**
  String resetLinkSentTo(String email);

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @noHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calculate your BMI on the Home tab and your history will appear here.'**
  String get noHistorySubtitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String entriesCount(int count);

  /// No description provided for @entryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entry'**
  String entryCount(int count);

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @lowest.
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
  String get lowest;

  /// No description provided for @highest.
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get highest;

  /// No description provided for @trend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get trend;

  /// No description provided for @deleteRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete record?'**
  String get deleteRecordTitle;

  /// No description provided for @deleteRecordContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove this BMI record.'**
  String get deleteRecordContent;

  /// No description provided for @failedToLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get failedToLoadHistory;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @avgBmi.
  ///
  /// In en, this message translates to:
  /// **'Avg BMI'**
  String get avgBmi;

  /// No description provided for @latestBmi.
  ///
  /// In en, this message translates to:
  /// **'Latest BMI'**
  String get latestBmi;

  /// No description provided for @bestBmi.
  ///
  /// In en, this message translates to:
  /// **'Best BMI'**
  String get bestBmi;

  /// No description provided for @bmiTrend.
  ///
  /// In en, this message translates to:
  /// **'BMI Trend'**
  String get bmiTrend;

  /// No description provided for @lastNMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Last {count} measurements'**
  String lastNMeasurements(int count);

  /// No description provided for @categoryDistribution.
  ///
  /// In en, this message translates to:
  /// **'Category Distribution'**
  String get categoryDistribution;

  /// No description provided for @basedOnAllRecords.
  ///
  /// In en, this message translates to:
  /// **'Based on all {count} records'**
  String basedOnAllRecords(int count);

  /// No description provided for @recentMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Recent Measurements'**
  String get recentMeasurements;

  /// No description provided for @last5Entries.
  ///
  /// In en, this message translates to:
  /// **'Last 5 entries'**
  String get last5Entries;

  /// No description provided for @noDataYet.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get noDataYet;

  /// No description provided for @noDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your BMI and your insights will appear here.'**
  String get noDataSubtitle;

  /// No description provided for @trackingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Tracking'**
  String get trackingSectionTitle;

  /// No description provided for @trackingSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log and monitor additional vital metrics'**
  String get trackingSectionSubtitle;

  /// No description provided for @bpCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get bpCardTitle;

  /// No description provided for @bpCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Systolic / diastolic tracking with WHO categories'**
  String get bpCardSubtitle;

  /// No description provided for @bpOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get bpOpen;

  /// No description provided for @bpTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get bpTitle;

  /// No description provided for @bpSaved.
  ///
  /// In en, this message translates to:
  /// **'Reading saved'**
  String get bpSaved;

  /// No description provided for @bpHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'BP History'**
  String get bpHistoryTitle;

  /// No description provided for @bpHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No blood pressure readings yet.\nAdd one to start the trend.'**
  String get bpHistoryEmpty;

  /// No description provided for @bpTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get bpTrendTitle;

  /// No description provided for @bpReadingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get bpReadingsTitle;

  /// No description provided for @bpCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'WHO Category:'**
  String get bpCategoryLabel;

  /// No description provided for @bpSystolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic (top number)'**
  String get bpSystolic;

  /// No description provided for @bpDiastolic.
  ///
  /// In en, this message translates to:
  /// **'Diastolic (bottom number)'**
  String get bpDiastolic;

  /// No description provided for @bpPulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse (optional)'**
  String get bpPulse;

  /// No description provided for @bpPulseHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 72'**
  String get bpPulseHint;

  /// No description provided for @bpPulseUnit.
  ///
  /// In en, this message translates to:
  /// **'bpm'**
  String get bpPulseUnit;

  /// No description provided for @bpNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get bpNotes;

  /// No description provided for @bpNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. after morning walk'**
  String get bpNotesHint;

  /// No description provided for @bpSave.
  ///
  /// In en, this message translates to:
  /// **'Save Reading'**
  String get bpSave;

  /// No description provided for @bpCategoryNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get bpCategoryNormal;

  /// No description provided for @bpCategoryElevated.
  ///
  /// In en, this message translates to:
  /// **'Elevated'**
  String get bpCategoryElevated;

  /// No description provided for @bpCategoryStage1.
  ///
  /// In en, this message translates to:
  /// **'High — Stage 1'**
  String get bpCategoryStage1;

  /// No description provided for @bpCategoryStage2.
  ///
  /// In en, this message translates to:
  /// **'High — Stage 2'**
  String get bpCategoryStage2;

  /// No description provided for @bpCategoryCrisis.
  ///
  /// In en, this message translates to:
  /// **'Crisis'**
  String get bpCategoryCrisis;

  /// No description provided for @bsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar'**
  String get bsCardTitle;

  /// No description provided for @bsCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Glucose tracking with ADA categories'**
  String get bsCardSubtitle;

  /// No description provided for @bsTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar'**
  String get bsTitle;

  /// No description provided for @bsSaved.
  ///
  /// In en, this message translates to:
  /// **'Reading saved'**
  String get bsSaved;

  /// No description provided for @bsHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Glucose History'**
  String get bsHistoryTitle;

  /// No description provided for @bsHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No blood sugar readings yet.\nAdd one to start the trend.'**
  String get bsHistoryEmpty;

  /// No description provided for @bsTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get bsTrendTitle;

  /// No description provided for @bsReadingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get bsReadingsTitle;

  /// No description provided for @bsStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'ADA Status:'**
  String get bsStatusLabel;

  /// No description provided for @bsStatusNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get bsStatusNormal;

  /// No description provided for @bsStatusPrediabetes.
  ///
  /// In en, this message translates to:
  /// **'Prediabetes'**
  String get bsStatusPrediabetes;

  /// No description provided for @bsStatusDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get bsStatusDiabetes;

  /// No description provided for @bsLevel.
  ///
  /// In en, this message translates to:
  /// **'Glucose Level'**
  String get bsLevel;

  /// No description provided for @bsTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurement Type'**
  String get bsTypeLabel;

  /// No description provided for @bsTypeFasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get bsTypeFasting;

  /// No description provided for @bsTypePostMeal.
  ///
  /// In en, this message translates to:
  /// **'Post-meal'**
  String get bsTypePostMeal;

  /// No description provided for @bsTypeRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get bsTypeRandom;

  /// No description provided for @bsMealContext.
  ///
  /// In en, this message translates to:
  /// **'Meal context (optional)'**
  String get bsMealContext;

  /// No description provided for @bsMealBeforeBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Before breakfast'**
  String get bsMealBeforeBreakfast;

  /// No description provided for @bsMealAfterBreakfast.
  ///
  /// In en, this message translates to:
  /// **'After breakfast'**
  String get bsMealAfterBreakfast;

  /// No description provided for @bsMealBeforeLunch.
  ///
  /// In en, this message translates to:
  /// **'Before lunch'**
  String get bsMealBeforeLunch;

  /// No description provided for @bsMealAfterLunch.
  ///
  /// In en, this message translates to:
  /// **'After lunch'**
  String get bsMealAfterLunch;

  /// No description provided for @bsMealBeforeDinner.
  ///
  /// In en, this message translates to:
  /// **'Before dinner'**
  String get bsMealBeforeDinner;

  /// No description provided for @bsMealAfterDinner.
  ///
  /// In en, this message translates to:
  /// **'After dinner'**
  String get bsMealAfterDinner;

  /// No description provided for @bsMealBedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get bsMealBedtime;

  /// No description provided for @bsNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get bsNotes;

  /// No description provided for @bsNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. took medication before reading'**
  String get bsNotesHint;

  /// No description provided for @bsSave.
  ///
  /// In en, this message translates to:
  /// **'Save Reading'**
  String get bsSave;

  /// No description provided for @bsEstimatedA1c.
  ///
  /// In en, this message translates to:
  /// **'Est. A1C'**
  String get bsEstimatedA1c;

  /// No description provided for @bsA1cDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Estimated from average glucose — not a substitute for a lab test.'**
  String get bsA1cDisclosure;

  /// No description provided for @tabDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get tabDashboard;

  /// No description provided for @subtitleDashboard.
  ///
  /// In en, this message translates to:
  /// **'Your health at a glance'**
  String get subtitleDashboard;

  /// No description provided for @healthScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get healthScoreTitle;

  /// No description provided for @healthScoreNoData.
  ///
  /// In en, this message translates to:
  /// **'Add measurements to see your health score'**
  String get healthScoreNoData;

  /// No description provided for @healthScorePillars.
  ///
  /// In en, this message translates to:
  /// **'Score Breakdown'**
  String get healthScorePillars;

  /// No description provided for @scoreExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get scoreExcellent;

  /// No description provided for @scoreVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get scoreVeryGood;

  /// No description provided for @scoreGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get scoreGood;

  /// No description provided for @scoreFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get scoreFair;

  /// No description provided for @scoreNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get scoreNeedsImprovement;

  /// No description provided for @dashboardBmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get dashboardBmi;

  /// No description provided for @dashboardBp.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get dashboardBp;

  /// No description provided for @dashboardGlucose.
  ///
  /// In en, this message translates to:
  /// **'Glucose'**
  String get dashboardGlucose;

  /// No description provided for @dashboardAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get dashboardAdvanced;

  /// No description provided for @dashboardWhtr.
  ///
  /// In en, this message translates to:
  /// **'Waist-to-height ratio'**
  String get dashboardWhtr;

  /// No description provided for @dashboardCorrelationTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI vs Glucose Correlation'**
  String get dashboardCorrelationTitle;

  /// No description provided for @healthScoreRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get healthScoreRecommendations;

  /// No description provided for @dashboardRecentBp.
  ///
  /// In en, this message translates to:
  /// **'Latest Blood Pressure'**
  String get dashboardRecentBp;

  /// No description provided for @dashboardRecentGlucose.
  ///
  /// In en, this message translates to:
  /// **'Glucose Trend'**
  String get dashboardRecentGlucose;

  /// No description provided for @recHealthyWeight.
  ///
  /// In en, this message translates to:
  /// **'Reach a healthy weight'**
  String get recHealthyWeight;

  /// No description provided for @recHealthyWeightDetail.
  ///
  /// In en, this message translates to:
  /// **'Aim for a BMI between 18.5 and 25 to reduce cardiovascular risk.'**
  String get recHealthyWeightDetail;

  /// No description provided for @recHypertension.
  ///
  /// In en, this message translates to:
  /// **'Manage blood pressure'**
  String get recHypertension;

  /// No description provided for @recHypertensionDetail.
  ///
  /// In en, this message translates to:
  /// **'Reduce sodium, exercise regularly, and track readings in the app.'**
  String get recHypertensionDetail;

  /// No description provided for @recGlucose.
  ///
  /// In en, this message translates to:
  /// **'Monitor blood sugar'**
  String get recGlucose;

  /// No description provided for @recGlucoseDetail.
  ///
  /// In en, this message translates to:
  /// **'Limit refined carbs and follow up with your clinician if levels stay elevated.'**
  String get recGlucoseDetail;

  /// No description provided for @recCardio.
  ///
  /// In en, this message translates to:
  /// **'Boost cardiovascular fitness'**
  String get recCardio;

  /// No description provided for @recCardioDetail.
  ///
  /// In en, this message translates to:
  /// **'Regular aerobic activity can lower your resting heart rate over time.'**
  String get recCardioDetail;

  /// No description provided for @recWaist.
  ///
  /// In en, this message translates to:
  /// **'Reduce waist circumference'**
  String get recWaist;

  /// No description provided for @recWaistDetail.
  ///
  /// In en, this message translates to:
  /// **'Target a waist-to-height ratio under 0.5 for better metabolic health.'**
  String get recWaistDetail;

  /// No description provided for @recOnTrack.
  ///
  /// In en, this message translates to:
  /// **'Great progress!'**
  String get recOnTrack;

  /// No description provided for @recOnTrackDetail.
  ///
  /// In en, this message translates to:
  /// **'Your key metrics look healthy. Keep logging to maintain your score.'**
  String get recOnTrackDetail;

  /// No description provided for @achievementCelebrationLabel.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked'**
  String get achievementCelebrationLabel;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'ACHIEVEMENT UNLOCKED · +'**
  String get achievementUnlocked;

  /// No description provided for @achievementNice.
  ///
  /// In en, this message translates to:
  /// **'Nice!'**
  String get achievementNice;

  /// No description provided for @achFirstCalculationTitle.
  ///
  /// In en, this message translates to:
  /// **'First Calculation'**
  String get achFirstCalculationTitle;

  /// No description provided for @achFirstCalculationDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate your BMI for the first time.'**
  String get achFirstCalculationDesc;

  /// No description provided for @achTenCalculationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get achTenCalculationsTitle;

  /// No description provided for @achTenCalculationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Log 10 BMI calculations.'**
  String get achTenCalculationsDesc;

  /// No description provided for @achFiftyCalculationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Power User'**
  String get achFiftyCalculationsTitle;

  /// No description provided for @achFiftyCalculationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Log 50 BMI calculations.'**
  String get achFiftyCalculationsDesc;

  /// No description provided for @achHundredCalculationsTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Legend'**
  String get achHundredCalculationsTitle;

  /// No description provided for @achHundredCalculationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Log 100 BMI calculations.'**
  String get achHundredCalculationsDesc;

  /// No description provided for @achHealthyBmiTitle.
  ///
  /// In en, this message translates to:
  /// **'Healthy Range'**
  String get achHealthyBmiTitle;

  /// No description provided for @achHealthyBmiDesc.
  ///
  /// In en, this message translates to:
  /// **'Record a BMI between 18.5 and 24.9.'**
  String get achHealthyBmiDesc;

  /// No description provided for @achHealthyBpTitle.
  ///
  /// In en, this message translates to:
  /// **'Calm & Normal'**
  String get achHealthyBpTitle;

  /// No description provided for @achHealthyBpDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a normal blood pressure reading.'**
  String get achHealthyBpDesc;

  /// No description provided for @achHealthyGlucoseTitle.
  ///
  /// In en, this message translates to:
  /// **'Steady Glucose'**
  String get achHealthyGlucoseTitle;

  /// No description provided for @achHealthyGlucoseDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a normal blood sugar reading.'**
  String get achHealthyGlucoseDesc;

  /// No description provided for @achAllMetricsHealthyTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Bill of Health'**
  String get achAllMetricsHealthyTitle;

  /// No description provided for @achAllMetricsHealthyDesc.
  ///
  /// In en, this message translates to:
  /// **'Have healthy BMI, blood pressure, and glucose readings.'**
  String get achAllMetricsHealthyDesc;

  /// No description provided for @achFirstBpTitle.
  ///
  /// In en, this message translates to:
  /// **'First BP Reading'**
  String get achFirstBpTitle;

  /// No description provided for @achFirstBpDesc.
  ///
  /// In en, this message translates to:
  /// **'Log your first blood pressure reading.'**
  String get achFirstBpDesc;

  /// No description provided for @achTenBpTitle.
  ///
  /// In en, this message translates to:
  /// **'BP Watcher'**
  String get achTenBpTitle;

  /// No description provided for @achTenBpDesc.
  ///
  /// In en, this message translates to:
  /// **'Log 10 blood pressure readings.'**
  String get achTenBpDesc;

  /// No description provided for @achFirstGlucoseTitle.
  ///
  /// In en, this message translates to:
  /// **'First Glucose Reading'**
  String get achFirstGlucoseTitle;

  /// No description provided for @achFirstGlucoseDesc.
  ///
  /// In en, this message translates to:
  /// **'Log your first blood sugar reading.'**
  String get achFirstGlucoseDesc;

  /// No description provided for @achTenGlucoseTitle.
  ///
  /// In en, this message translates to:
  /// **'Glucose Observer'**
  String get achTenGlucoseTitle;

  /// No description provided for @achTenGlucoseDesc.
  ///
  /// In en, this message translates to:
  /// **'Log 10 blood sugar readings.'**
  String get achTenGlucoseDesc;

  /// No description provided for @achThreeDayStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Three in a Row'**
  String get achThreeDayStreakTitle;

  /// No description provided for @achThreeDayStreakDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a measurement 3 days in a row.'**
  String get achThreeDayStreakDesc;

  /// No description provided for @achSevenDayStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Habit'**
  String get achSevenDayStreakTitle;

  /// No description provided for @achSevenDayStreakDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a measurement 7 days in a row.'**
  String get achSevenDayStreakDesc;

  /// No description provided for @achFourteenDayStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Two Fortnights'**
  String get achFourteenDayStreakTitle;

  /// No description provided for @achFourteenDayStreakDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a measurement 14 days in a row.'**
  String get achFourteenDayStreakDesc;

  /// No description provided for @achThirtyDayStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Unstoppable'**
  String get achThirtyDayStreakTitle;

  /// No description provided for @achThirtyDayStreakDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a measurement 30 days in a row.'**
  String get achThirtyDayStreakDesc;

  /// No description provided for @achPerfectWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect Week'**
  String get achPerfectWeekTitle;

  /// No description provided for @achPerfectWeekDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep a 7-day best streak.'**
  String get achPerfectWeekDesc;

  /// No description provided for @achOnARollTitle.
  ///
  /// In en, this message translates to:
  /// **'On a Roll'**
  String get achOnARollTitle;

  /// No description provided for @achOnARollDesc.
  ///
  /// In en, this message translates to:
  /// **'Log 5 measurements in a single day.'**
  String get achOnARollDesc;

  /// No description provided for @achEarlyBirdTitle.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get achEarlyBirdTitle;

  /// No description provided for @achEarlyBirdDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a measurement before 9 AM.'**
  String get achEarlyBirdDesc;

  /// No description provided for @achNightOwlTitle.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get achNightOwlTitle;

  /// No description provided for @achNightOwlDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a measurement after 9 PM.'**
  String get achNightOwlDesc;

  /// No description provided for @achAllTrackerTypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Tracker'**
  String get achAllTrackerTypesTitle;

  /// No description provided for @achAllTrackerTypesDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a BMI, blood pressure, and glucose measurement.'**
  String get achAllTrackerTypesDesc;

  /// No description provided for @achDashboardExcellentTitle.
  ///
  /// In en, this message translates to:
  /// **'Peak Health'**
  String get achDashboardExcellentTitle;

  /// No description provided for @achDashboardExcellentDesc.
  ///
  /// In en, this message translates to:
  /// **'Reach an excellent health score of 90+.'**
  String get achDashboardExcellentDesc;

  /// No description provided for @challengeLogBmiTitle.
  ///
  /// In en, this message translates to:
  /// **'Log a BMI'**
  String get challengeLogBmiTitle;

  /// No description provided for @challengeLogBmiDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate your BMI once today.'**
  String get challengeLogBmiDesc;

  /// No description provided for @challengeLogBpTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Blood Pressure'**
  String get challengeLogBpTitle;

  /// No description provided for @challengeLogBpDesc.
  ///
  /// In en, this message translates to:
  /// **'Take a blood pressure reading today.'**
  String get challengeLogBpDesc;

  /// No description provided for @challengeLogGlucoseTitle.
  ///
  /// In en, this message translates to:
  /// **'Check Glucose'**
  String get challengeLogGlucoseTitle;

  /// No description provided for @challengeLogGlucoseDesc.
  ///
  /// In en, this message translates to:
  /// **'Log a blood sugar reading today.'**
  String get challengeLogGlucoseDesc;

  /// No description provided for @challengeLogAnyThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Three Logs'**
  String get challengeLogAnyThreeTitle;

  /// No description provided for @challengeLogAnyThreeDesc.
  ///
  /// In en, this message translates to:
  /// **'Log any 3 measurements today.'**
  String get challengeLogAnyThreeDesc;

  /// No description provided for @challengeLogHealthyTitle.
  ///
  /// In en, this message translates to:
  /// **'Healthy Reading'**
  String get challengeLogHealthyTitle;

  /// No description provided for @challengeLogHealthyDesc.
  ///
  /// In en, this message translates to:
  /// **'Log any reading in the normal range today.'**
  String get challengeLogHealthyDesc;

  /// No description provided for @dailyChallengeToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Challenge'**
  String get dailyChallengeToday;

  /// No description provided for @challengePointsFormat.
  ///
  /// In en, this message translates to:
  /// **'+{points} pts'**
  String challengePointsFormat(Object points);

  /// No description provided for @challengeTierEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get challengeTierEasy;

  /// No description provided for @challengeTierMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get challengeTierMedium;

  /// No description provided for @challengeTierHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get challengeTierHard;

  /// No description provided for @challengeCompleted.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGE COMPLETED · +'**
  String get challengeCompleted;

  /// No description provided for @challengeHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge History'**
  String get challengeHistoryTitle;

  /// No description provided for @challengeHistoryError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load challenge history.'**
  String get challengeHistoryError;

  /// No description provided for @challengeHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No challenges yet. Check back tomorrow for your first one!'**
  String get challengeHistoryEmpty;

  /// No description provided for @reminderSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Reminders'**
  String get reminderSettingsTitle;

  /// No description provided for @reminderBmiTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight Check Reminder'**
  String get reminderBmiTitle;

  /// No description provided for @reminderBmiBody.
  ///
  /// In en, this message translates to:
  /// **'Time for a quick BMI calculation to keep your progress updated!'**
  String get reminderBmiBody;

  /// No description provided for @reminderHydrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Hydration Check-In'**
  String get reminderHydrationTitle;

  /// No description provided for @reminderHydrationBody.
  ///
  /// In en, this message translates to:
  /// **'Drink some water! Staying hydrated supports metabolic health.'**
  String get reminderHydrationBody;

  /// No description provided for @reminderActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Moving Prompt'**
  String get reminderActivityTitle;

  /// No description provided for @reminderActivityBody.
  ///
  /// In en, this message translates to:
  /// **'Time for a stretch or a short walk. Keep active!'**
  String get reminderActivityBody;

  /// No description provided for @reminderHealthTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Health Tip'**
  String get reminderHealthTipTitle;

  /// No description provided for @reminderHealthTipBody.
  ///
  /// In en, this message translates to:
  /// **'Open the app for a quick daily health insight to guide your journey.'**
  String get reminderHealthTipBody;

  /// No description provided for @reminderMedicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Medication Reminder'**
  String get reminderMedicationTitle;

  /// No description provided for @reminderMedicationBody.
  ///
  /// In en, this message translates to:
  /// **'Friendly reminder: take your scheduled medicine or vitamins.'**
  String get reminderMedicationBody;

  /// No description provided for @reminderChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get reminderChallengeTitle;

  /// No description provided for @reminderChallengeBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t miss out on today\'s challenge! Complete it to earn points.'**
  String get reminderChallengeBody;

  /// No description provided for @remindersLabel.
  ///
  /// In en, this message translates to:
  /// **'Medication label'**
  String get remindersLabel;

  /// No description provided for @remindersTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get remindersTime;

  /// No description provided for @remindersDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get remindersDays;

  /// No description provided for @remindersEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get remindersEnabled;

  /// No description provided for @everyday.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyday;

  /// No description provided for @weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// No description provided for @weekends.
  ///
  /// In en, this message translates to:
  /// **'Weekends'**
  String get weekends;

  /// No description provided for @customDays.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customDays;

  /// No description provided for @deleteReminder.
  ///
  /// In en, this message translates to:
  /// **'Delete Reminder'**
  String get deleteReminder;

  /// No description provided for @addCustomMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Medication Reminder'**
  String get addCustomMedication;

  /// No description provided for @reminderSmartHint.
  ///
  /// In en, this message translates to:
  /// **'Auto-skipped today once you log the matching metric'**
  String get reminderSmartHint;

  /// No description provided for @medicationNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Vitamin D'**
  String get medicationNameHint;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementsError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your achievements.'**
  String get achievementsError;

  /// No description provided for @achievementsTotalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get achievementsTotalPoints;

  /// No description provided for @achievementsCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get achievementsCurrentStreak;

  /// No description provided for @achievementsBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get achievementsBestStreak;

  /// No description provided for @achievementsUnlockedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 of {total} unlocked} other{{count} of {total} unlocked}}'**
  String achievementsUnlockedCount(int count, int total);

  /// No description provided for @achievementsStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String achievementsStreakDays(int count);

  /// No description provided for @wearableTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Data'**
  String get wearableTitle;

  /// No description provided for @wearableConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect health data'**
  String get wearableConnectTitle;

  /// No description provided for @wearableConnectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Link Google Health Connect or Apple Health to pull your fitness vitals into your Insights.'**
  String get wearableConnectSubtitle;

  /// No description provided for @wearableGrantBtn.
  ///
  /// In en, this message translates to:
  /// **'Grant Access'**
  String get wearableGrantBtn;

  /// No description provided for @wearableGrantingBtn.
  ///
  /// In en, this message translates to:
  /// **'Requesting access…'**
  String get wearableGrantingBtn;

  /// No description provided for @wearableGrantedTitle.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get wearableGrantedTitle;

  /// No description provided for @wearableGrantedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Health data is flowing into your Insights.'**
  String get wearableGrantedSubtitle;

  /// No description provided for @wearableRevokeBtn.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get wearableRevokeBtn;

  /// No description provided for @wearableRefreshBtn.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get wearableRefreshBtn;

  /// No description provided for @wearableDryRun.
  ///
  /// In en, this message translates to:
  /// **'No measurements found in the last 24 hours.'**
  String get wearableDryRun;

  /// No description provided for @wearableRevokedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You are no longer connected to health data.'**
  String get wearableRevokedSubtitle;

  /// No description provided for @wearableStepInPerm.
  ///
  /// In en, this message translates to:
  /// **'Steps are read as an activity summary; the app needs Activity Recognition.'**
  String get wearableStepInPerm;

  /// No description provided for @wearableErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to health data. Please make sure Health Connect is installed (Android) or Health is allowed in Settings (iOS).'**
  String get wearableErrorGeneric;

  /// No description provided for @wearableErrorPermission.
  ///
  /// In en, this message translates to:
  /// **'Access was denied. You can re-enable access from Health Connect on your device.'**
  String get wearableErrorPermission;

  /// No description provided for @wearableImportBtn.
  ///
  /// In en, this message translates to:
  /// **'Import to history'**
  String get wearableImportBtn;

  /// No description provided for @wearableImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} readings added'**
  String wearableImportSuccess(int count);

  /// No description provided for @wearableImportNothing.
  ///
  /// In en, this message translates to:
  /// **'No new readings to add'**
  String get wearableImportNothing;

  /// No description provided for @wearableAutoFillUse.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get wearableAutoFillUse;

  /// No description provided for @metricSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get metricSteps;

  /// No description provided for @metricWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get metricWeight;

  /// No description provided for @metricBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get metricBloodPressure;

  /// No description provided for @metricGlucose.
  ///
  /// In en, this message translates to:
  /// **'Glucose'**
  String get metricGlucose;

  /// No description provided for @metricHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart rate'**
  String get metricHeartRate;

  /// No description provided for @metricRestingHr.
  ///
  /// In en, this message translates to:
  /// **'Resting HR'**
  String get metricRestingHr;

  /// No description provided for @metricWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get metricWater;

  /// No description provided for @metricPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get metricPermissions;

  /// No description provided for @wearableValidationRejected.
  ///
  /// In en, this message translates to:
  /// **'{count} reading(s) rejected (out of range)'**
  String wearableValidationRejected(int count);

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Health Report'**
  String get exportTitle;

  /// No description provided for @exportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download your health, weight, and vitals history'**
  String get exportSubtitle;

  /// No description provided for @exportBtn.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportBtn;

  /// No description provided for @exportFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get exportFormatLabel;

  /// No description provided for @exportAnonymizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Anonymize data'**
  String get exportAnonymizeLabel;

  /// No description provided for @exportAnonymizeSub.
  ///
  /// In en, this message translates to:
  /// **'Hide personal details like emails and ID'**
  String get exportAnonymizeSub;

  /// No description provided for @exportShareBtn.
  ///
  /// In en, this message translates to:
  /// **'Generate and Share'**
  String get exportShareBtn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'de',
        'en',
        'es',
        'fr',
        'ha',
        'hi',
        'id',
        'pt',
        'ru',
        'sw',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ha':
      return AppLocalizationsHa();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sw':
      return AppLocalizationsSw();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
