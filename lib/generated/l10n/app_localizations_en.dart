// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BMI Calculator';

  @override
  String get appTagline => 'Track · Understand · Improve';

  @override
  String get trackHealthJourney => 'Track your health journey';

  @override
  String get tabCalculate => 'Calculate';

  @override
  String get tabHistory => 'History';

  @override
  String get tabInsights => 'Insights';

  @override
  String get subtitleCalculate => 'Enter your measurements below';

  @override
  String get subtitleHistory => 'Your past BMI calculations';

  @override
  String get subtitleInsights => 'Trends and analytics';

  @override
  String get liveBmiPreview => 'Live BMI Preview';

  @override
  String get metricUnits => 'Metric (cm/kg)';

  @override
  String get imperialUnits => 'Imperial (ft/lbs)';

  @override
  String get biologicalSex => 'Biological sex';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get age => 'Age';

  @override
  String get years => 'yrs';

  @override
  String get healthConditions => 'Health Conditions (Optional)';

  @override
  String get pregnancyStatus => 'Pregnancy Status (Optional)';

  @override
  String get prePregnancyWeight => 'Pre-pregnancy weight (optional)';

  @override
  String get weightInKg => 'Weight in kg';

  @override
  String get weightInLbs => 'Weight in lbs';

  @override
  String get calculateBmi => 'Calculate BMI';

  @override
  String get selectGenderError => 'Please select your gender to continue';

  @override
  String get signInToSave => 'Please sign in to save your calculation';

  @override
  String get shortUnderweight => '· Underweight';

  @override
  String get shortNormal => '· Normal';

  @override
  String get shortOverweight => '· Overweight';

  @override
  String get shortObese => '· Obese';

  @override
  String get yourResults => 'Your Results';

  @override
  String get bodyMassIndex => 'Body Mass Index';

  @override
  String get whatThisMeans => 'What this means';

  @override
  String get idealWeightRange => 'Ideal Weight Range';

  @override
  String get minLabel => 'Min';

  @override
  String get maxLabel => 'Max';

  @override
  String get dailyCalories => 'Daily Calories';

  @override
  String get kcalPerDay => 'kcal/day';

  @override
  String get waterIntake => 'Water Intake';

  @override
  String get litresPerDay => 'litres/day';

  @override
  String get healthConsideration => 'Health Consideration';

  @override
  String get nutritionRecommendations => 'Nutrition Recommendations';

  @override
  String get dailyMealPlan => 'Daily Meal Plan';

  @override
  String get macronutrientBalance => 'Macronutrient Balance';

  @override
  String get focusFoods => 'Focus Foods';

  @override
  String get keyRecommendations => 'Key Recommendations';

  @override
  String get bmiScale => 'BMI Scale';

  @override
  String get reCalculate => 'Re-Calculate';

  @override
  String get resultCopied => 'Result copied to clipboard!';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String moreRecommendations(int count) {
    return '... and $count more recommendations';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'My BMI is $bmi — $category\n$interpretation\nTracked with BMI Calculator App';
  }

  @override
  String get bmiSeverelyUnderweight => 'Severely Underweight';

  @override
  String get bmiUnderweight => 'Underweight';

  @override
  String get bmiNormalWeight => 'Normal Weight';

  @override
  String get bmiOverweight => 'Overweight';

  @override
  String get bmiObeseI => 'Obese Class I';

  @override
  String get bmiObeseII => 'Obese Class II';

  @override
  String get bmiSeverelyObese => 'Severely Obese';

  @override
  String get profile => 'Profile';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get guestUser => 'Guest User';

  @override
  String get guestModeLocal => 'Guest mode · data stored locally';

  @override
  String get guestModeBanner =>
      'Guest mode — data is stored locally only. Create an account to sync across devices.';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get notAvailable => 'N/A';

  @override
  String get account => 'Account';

  @override
  String get totalChecks => 'Total Checks';

  @override
  String get averageBmi => 'Average BMI';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signIn => 'Sign In';

  @override
  String get changePassword => 'Change Password';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get leaveGuestMode => 'Leave Guest Mode';

  @override
  String get signOut => 'Sign Out';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get leaveGuestTitle => 'Leave guest mode?';

  @override
  String get signOutTitle => 'Sign out?';

  @override
  String get leaveGuestContent =>
      'Your local data will be cleared. Sign in or create an account to keep your history.';

  @override
  String get signOutContent =>
      'You can sign back in any time to access your synced data.';

  @override
  String get leave => 'Leave';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountContent =>
      'This permanently deletes your account and all data. This cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get emailAddress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createOne => 'Create one';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get startTrackingToday => 'Start tracking your health today';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signInLink => 'Sign in';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameShort => 'Enter your full name';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Enter a valid phone number';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String passwordStrengthLabel(String level) {
    return 'Password strength: $level';
  }

  @override
  String get passwordWeak => 'Weak';

  @override
  String get passwordMedium => 'Medium';

  @override
  String get passwordStrong => 'Strong';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get checkInbox => 'Check your inbox';

  @override
  String resetLinkSentTo(String email) {
    return 'We sent a password reset link to\n$email';
  }

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get noHistorySubtitle =>
      'Calculate your BMI on the Home tab and your history will appear here.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String entriesCount(int count) {
    return '$count entries';
  }

  @override
  String entryCount(int count) {
    return '$count entry';
  }

  @override
  String get average => 'Average';

  @override
  String get lowest => 'Lowest';

  @override
  String get highest => 'Highest';

  @override
  String get trend => 'Trend';

  @override
  String get deleteRecordTitle => 'Delete record?';

  @override
  String get deleteRecordContent =>
      'This will permanently remove this BMI record.';

  @override
  String get failedToLoadHistory => 'Failed to load history';

  @override
  String get retry => 'Retry';

  @override
  String get avgBmi => 'Avg BMI';

  @override
  String get latestBmi => 'Latest BMI';

  @override
  String get bestBmi => 'Best BMI';

  @override
  String get bmiTrend => 'BMI Trend';

  @override
  String lastNMeasurements(int count) {
    return 'Last $count measurements';
  }

  @override
  String get categoryDistribution => 'Category Distribution';

  @override
  String basedOnAllRecords(int count) {
    return 'Based on all $count records';
  }

  @override
  String get recentMeasurements => 'Recent Measurements';

  @override
  String get last5Entries => 'Last 5 entries';

  @override
  String get noDataYet => 'No data yet';

  @override
  String get noDataSubtitle =>
      'Start tracking your BMI and your insights will appear here.';
}
