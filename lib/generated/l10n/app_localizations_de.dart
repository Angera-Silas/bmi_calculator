// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'BMI-Rechner';

  @override
  String get appTagline => 'Verfolgen · Verstehen · Verbessern';

  @override
  String get trackHealthJourney => 'Verfolge deine Gesundheitsreise';

  @override
  String get tabCalculate => 'Berechnen';

  @override
  String get tabHistory => 'Verlauf';

  @override
  String get tabInsights => 'Statistiken';

  @override
  String get subtitleCalculate => 'Gib deine Maße unten ein';

  @override
  String get subtitleHistory => 'Deine früheren BMI-Berechnungen';

  @override
  String get subtitleInsights => 'Trends und Analysen';

  @override
  String get liveBmiPreview => 'Live-BMI-Vorschau';

  @override
  String get metricUnits => 'Metrisch (cm/kg)';

  @override
  String get imperialUnits => 'Imperial (ft/lbs)';

  @override
  String get biologicalSex => 'Biologisches Geschlecht';

  @override
  String get male => 'Männlich';

  @override
  String get female => 'Weiblich';

  @override
  String get height => 'Größe';

  @override
  String get weight => 'Gewicht';

  @override
  String get age => 'Alter';

  @override
  String get years => 'J.';

  @override
  String get healthConditions => 'Gesundheitszustand (optional)';

  @override
  String get pregnancyStatus => 'Schwangerschaftsstatus (optional)';

  @override
  String get prePregnancyWeight => 'Gewicht vor Schwangerschaft (optional)';

  @override
  String get weightInKg => 'Gewicht in kg';

  @override
  String get weightInLbs => 'Gewicht in lbs';

  @override
  String get calculateBmi => 'BMI berechnen';

  @override
  String get selectGenderError =>
      'Bitte wähle dein Geschlecht aus, um fortzufahren';

  @override
  String get signInToSave =>
      'Bitte melde dich an, um die Berechnung zu speichern';

  @override
  String get shortUnderweight => '· Untergewicht';

  @override
  String get shortNormal => '· Normal';

  @override
  String get shortOverweight => '· Übergewicht';

  @override
  String get shortObese => '· Adipositas';

  @override
  String get yourResults => 'Deine Ergebnisse';

  @override
  String get bodyMassIndex => 'Body-Mass-Index';

  @override
  String get whatThisMeans => 'Was das bedeutet';

  @override
  String get idealWeightRange => 'Idealer Gewichtsbereich';

  @override
  String get minLabel => 'Min';

  @override
  String get maxLabel => 'Max';

  @override
  String get dailyCalories => 'Tägliche Kalorien';

  @override
  String get kcalPerDay => 'kcal/Tag';

  @override
  String get waterIntake => 'Wasseraufnahme';

  @override
  String get litresPerDay => 'Liter/Tag';

  @override
  String get healthConsideration => 'Gesundheitshinweis';

  @override
  String get nutritionRecommendations => 'Ernährungsempfehlungen';

  @override
  String get dailyMealPlan => 'Täglicher Ernährungsplan';

  @override
  String get macronutrientBalance => 'Makronährstoffbilanz';

  @override
  String get focusFoods => 'Wichtige Lebensmittel';

  @override
  String get keyRecommendations => 'Wichtigste Empfehlungen';

  @override
  String get bmiScale => 'BMI-Skala';

  @override
  String get reCalculate => 'Neu berechnen';

  @override
  String get resultCopied => 'Ergebnis in die Zwischenablage kopiert!';

  @override
  String get copyToClipboard => 'In die Zwischenablage kopieren';

  @override
  String moreRecommendations(int count) {
    return '... und $count weitere Empfehlungen';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'Mein BMI ist $bmi — $category\n$interpretation\nMit BMI Calculator App verfolgt';
  }

  @override
  String get bmiSeverelyUnderweight => 'Starkes Untergewicht';

  @override
  String get bmiUnderweight => 'Untergewicht';

  @override
  String get bmiNormalWeight => 'Normalgewicht';

  @override
  String get bmiOverweight => 'Übergewicht';

  @override
  String get bmiObeseI => 'Adipositas Grad I';

  @override
  String get bmiObeseII => 'Adipositas Grad II';

  @override
  String get bmiSeverelyObese => 'Starke Adipositas';

  @override
  String get profile => 'Profil';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get guestUser => 'Gastnutzer';

  @override
  String get guestModeLocal => 'Gastmodus · Daten lokal gespeichert';

  @override
  String get guestModeBanner =>
      'Gastmodus — Daten werden nur lokal gespeichert. Erstelle ein Konto für geräteübergreifende Synchronisierung.';

  @override
  String get personalInformation => 'Persönliche Informationen';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get email => 'E-Mail';

  @override
  String get phone => 'Telefon';

  @override
  String get notAvailable => 'N/V';

  @override
  String get account => 'Konto';

  @override
  String get totalChecks => 'Gesamte Messungen';

  @override
  String get averageBmi => 'Durchschnittlicher BMI';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get signIn => 'Anmelden';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get leaveGuestMode => 'Gastmodus verlassen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get profileUpdated => 'Profil aktualisiert';

  @override
  String get leaveGuestTitle => 'Gastmodus verlassen?';

  @override
  String get signOutTitle => 'Abmelden?';

  @override
  String get leaveGuestContent =>
      'Deine lokalen Daten werden gelöscht. Melde dich an oder erstelle ein Konto, um den Verlauf zu behalten.';

  @override
  String get signOutContent => 'Du kannst dich jederzeit wieder anmelden.';

  @override
  String get leave => 'Verlassen';

  @override
  String get deleteAccountTitle => 'Konto löschen?';

  @override
  String get deleteAccountContent =>
      'Dein Konto und alle Daten werden dauerhaft gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get delete => 'Löschen';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get signInToContinue => 'Melde dich an, um fortzufahren';

  @override
  String get emailAddress => 'E-Mail-Adresse';

  @override
  String get password => 'Passwort';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get continueAsGuest => 'Als Gast fortfahren';

  @override
  String get dontHaveAccount => 'Noch kein Konto?';

  @override
  String get createOne => 'Erstellen';

  @override
  String get emailRequired => 'E-Mail ist erforderlich';

  @override
  String get emailInvalid => 'Gib eine gültige E-Mail-Adresse ein';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get passwordTooShort => 'Das Passwort muss mindestens 6 Zeichen haben';

  @override
  String get createAccountTitle => 'Konto erstellen';

  @override
  String get startTrackingToday =>
      'Beginne noch heute mit der Gesundheitsverfolgung';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto?';

  @override
  String get signInLink => 'Anmelden';

  @override
  String get nameRequired => 'Name ist erforderlich';

  @override
  String get nameShort => 'Gib deinen vollständigen Namen ein';

  @override
  String get phoneRequired => 'Telefonnummer ist erforderlich';

  @override
  String get phoneInvalid => 'Gib eine gültige Telefonnummer ein';

  @override
  String get confirmPasswordRequired => 'Bitte bestätige dein Passwort';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String passwordStrengthLabel(String level) {
    return 'Passwortstärke: $level';
  }

  @override
  String get passwordWeak => 'Schwach';

  @override
  String get passwordMedium => 'Mittel';

  @override
  String get passwordStrong => 'Stark';

  @override
  String get resetPasswordTitle => 'Passwort zurücksetzen';

  @override
  String get resetPasswordSubtitle =>
      'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen des Passworts.';

  @override
  String get sendResetLink => 'Link senden';

  @override
  String get checkInbox => 'Überprüfe deinen Posteingang';

  @override
  String resetLinkSentTo(String email) {
    return 'Wir haben den Passwort-Reset-Link an\n$email gesendet';
  }

  @override
  String get backToSignIn => 'Zurück zur Anmeldung';

  @override
  String get noHistoryYet => 'Noch kein Verlauf';

  @override
  String get noHistorySubtitle =>
      'Berechne deinen BMI im Tab Berechnen und dein Verlauf erscheint hier.';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get yourProgress => 'Dein Fortschritt';

  @override
  String entriesCount(int count) {
    return '$count Einträge';
  }

  @override
  String entryCount(int count) {
    return '$count Eintrag';
  }

  @override
  String get average => 'Durchschnitt';

  @override
  String get lowest => 'Minimum';

  @override
  String get highest => 'Maximum';

  @override
  String get trend => 'Trend';

  @override
  String get deleteRecordTitle => 'Eintrag löschen?';

  @override
  String get deleteRecordContent =>
      'Dieser BMI-Eintrag wird dauerhaft gelöscht.';

  @override
  String get failedToLoadHistory => 'Verlauf konnte nicht geladen werden';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get avgBmi => 'Ø BMI';

  @override
  String get latestBmi => 'Letzter BMI';

  @override
  String get bestBmi => 'Bester BMI';

  @override
  String get bmiTrend => 'BMI-Trend';

  @override
  String lastNMeasurements(int count) {
    return 'Letzte $count Messungen';
  }

  @override
  String get categoryDistribution => 'Kategorieverteilung';

  @override
  String basedOnAllRecords(int count) {
    return 'Basierend auf $count Einträgen';
  }

  @override
  String get recentMeasurements => 'Neueste Messungen';

  @override
  String get last5Entries => 'Letzte 5 Einträge';

  @override
  String get noDataYet => 'Noch keine Daten';

  @override
  String get noDataSubtitle =>
      'Beginne mit der BMI-Erfassung und deine Statistiken erscheinen hier.';
}
