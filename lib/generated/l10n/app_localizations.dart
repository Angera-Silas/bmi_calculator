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
