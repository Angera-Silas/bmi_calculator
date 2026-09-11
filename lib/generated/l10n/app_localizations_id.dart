// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Kalkulator BMI';

  @override
  String get appTagline => 'Lacak · Pahami · Tingkatkan';

  @override
  String get trackHealthJourney => 'Lacak perjalanan kesehatan Anda';

  @override
  String get tabCalculate => 'Hitung';

  @override
  String get tabHistory => 'Riwayat';

  @override
  String get tabInsights => 'Statistik';

  @override
  String get subtitleCalculate => 'Masukkan pengukuran Anda di bawah';

  @override
  String get subtitleHistory => 'Perhitungan BMI Anda sebelumnya';

  @override
  String get subtitleInsights => 'Tren dan analisis';

  @override
  String get liveBmiPreview => 'Pratinjau BMI Langsung';

  @override
  String get metricUnits => 'Metrik (cm/kg)';

  @override
  String get imperialUnits => 'Imperial (ft/lbs)';

  @override
  String get biologicalSex => 'Jenis kelamin biologis';

  @override
  String get male => 'Laki-laki';

  @override
  String get female => 'Perempuan';

  @override
  String get height => 'Tinggi badan';

  @override
  String get weight => 'Berat badan';

  @override
  String get age => 'Usia';

  @override
  String get years => 'thn';

  @override
  String get healthConditions => 'Kondisi kesehatan (opsional)';

  @override
  String get pregnancyStatus => 'Status kehamilan (opsional)';

  @override
  String get prePregnancyWeight => 'Berat sebelum hamil (opsional)';

  @override
  String get weightInKg => 'Berat dalam kg';

  @override
  String get weightInLbs => 'Berat dalam lbs';

  @override
  String get calculateBmi => 'Hitung BMI';

  @override
  String get invalidMetricInput =>
      'Please check your measurements — some values are invalid.';

  @override
  String get advancedMetricsTitle => 'Advanced Metrics (Optional)';

  @override
  String get advancedMetricsSubtitle =>
      'Add body measurements for extra health insights (cm / bpm)';

  @override
  String get waistCircumference => 'Waist circumference';

  @override
  String get waistHint => 'e.g. 84';

  @override
  String get neckCircumference => 'Neck circumference';

  @override
  String get neckHint => 'e.g. 38';

  @override
  String get hipCircumference => 'Hip circumference';

  @override
  String get hipHint => 'e.g. 96';

  @override
  String get restingHeartRate => 'Resting heart rate';

  @override
  String get restingHeartRateHint => 'e.g. 68';

  @override
  String get healthMetricsTitle => 'Health Metrics';

  @override
  String get waistToHeightRatioLabel => 'Waist-to-Height Ratio';

  @override
  String get bodyFatLabel => 'Body Fat';

  @override
  String get metabolicAgeLabel => 'Metabolic Age';

  @override
  String get vo2maxLabel => 'VO2max (estimate)';

  @override
  String get selectGenderError =>
      'Silakan pilih jenis kelamin untuk melanjutkan';

  @override
  String get signInToSave => 'Masuk untuk menyimpan perhitungan Anda';

  @override
  String get shortUnderweight => '· Kurang berat';

  @override
  String get shortNormal => '· Normal';

  @override
  String get shortOverweight => '· Kelebihan berat';

  @override
  String get shortObese => '· Obesitas';

  @override
  String get yourResults => 'Hasil Anda';

  @override
  String get bodyMassIndex => 'Indeks Massa Tubuh';

  @override
  String get whatThisMeans => 'Apa artinya ini';

  @override
  String get idealWeightRange => 'Rentang Berat Ideal';

  @override
  String get minLabel => 'Min';

  @override
  String get maxLabel => 'Maks';

  @override
  String get dailyCalories => 'Kalori Harian';

  @override
  String get kcalPerDay => 'kkal/hari';

  @override
  String get waterIntake => 'Asupan Air';

  @override
  String get litresPerDay => 'liter/hari';

  @override
  String get healthConsideration => 'Pertimbangan Kesehatan';

  @override
  String get nutritionRecommendations => 'Rekomendasi Gizi';

  @override
  String get dailyMealPlan => 'Rencana Makan Harian';

  @override
  String get macronutrientBalance => 'Keseimbangan Makronutrien';

  @override
  String get focusFoods => 'Makanan Utama';

  @override
  String get keyRecommendations => 'Rekomendasi Utama';

  @override
  String get bmiScale => 'Skala BMI';

  @override
  String get reCalculate => 'Hitung Ulang';

  @override
  String get resultCopied => 'Hasil disalin ke clipboard!';

  @override
  String get copyToClipboard => 'Salin ke clipboard';

  @override
  String moreRecommendations(int count) {
    return '... dan $count rekomendasi lagi';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'BMI saya $bmi — $category\n$interpretation\nDilacak dengan BMI Calculator App';
  }

  @override
  String get bmiSeverelyUnderweight => 'Sangat Kekurangan Berat';

  @override
  String get bmiUnderweight => 'Kekurangan Berat';

  @override
  String get bmiNormalWeight => 'Berat Normal';

  @override
  String get bmiOverweight => 'Kelebihan Berat';

  @override
  String get bmiObeseI => 'Obesitas Kelas I';

  @override
  String get bmiObeseII => 'Obesitas Kelas II';

  @override
  String get bmiSeverelyObese => 'Obesitas Berat';

  @override
  String get profile => 'Profil';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get guestUser => 'Pengguna Tamu';

  @override
  String get guestModeLocal => 'Mode tamu · data tersimpan lokal';

  @override
  String get guestModeBanner =>
      'Mode tamu — data hanya tersimpan di perangkat. Buat akun untuk sinkronisasi antar perangkat.';

  @override
  String get personalInformation => 'Informasi Pribadi';

  @override
  String get fullName => 'Nama lengkap';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Telepon';

  @override
  String get notAvailable => 'N/A';

  @override
  String get account => 'Akun';

  @override
  String get totalChecks => 'Total Pemeriksaan';

  @override
  String get averageBmi => 'Rata-rata BMI';

  @override
  String get createAccount => 'Buat Akun';

  @override
  String get signIn => 'Masuk';

  @override
  String get changePassword => 'Ganti Password';

  @override
  String get deleteAccount => 'Hapus Akun';

  @override
  String get leaveGuestMode => 'Keluar Mode Tamu';

  @override
  String get signOut => 'Keluar';

  @override
  String get profileUpdated => 'Profil diperbarui';

  @override
  String get leaveGuestTitle => 'Keluar dari mode tamu?';

  @override
  String get signOutTitle => 'Keluar?';

  @override
  String get leaveGuestContent =>
      'Data lokal Anda akan dihapus. Masuk atau buat akun untuk menyimpan riwayat Anda.';

  @override
  String get signOutContent => 'Anda bisa masuk kembali kapan saja.';

  @override
  String get leave => 'Keluar';

  @override
  String get deleteAccountTitle => 'Hapus akun?';

  @override
  String get deleteAccountContent =>
      'Ini akan menghapus akun dan semua data Anda secara permanen. Tidak dapat dibatalkan.';

  @override
  String get delete => 'Hapus';

  @override
  String get language => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih bahasa';

  @override
  String get welcomeBack => 'Selamat datang kembali';

  @override
  String get signInToContinue => 'Masuk untuk melanjutkan';

  @override
  String get emailAddress => 'Alamat email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Lupa password?';

  @override
  String get continueAsGuest => 'Lanjutkan sebagai tamu';

  @override
  String get dontHaveAccount => 'Belum punya akun?';

  @override
  String get createOne => 'Buat akun';

  @override
  String get emailRequired => 'Email wajib diisi';

  @override
  String get emailInvalid => 'Masukkan alamat email yang valid';

  @override
  String get passwordRequired => 'Password wajib diisi';

  @override
  String get passwordTooShort => 'Password minimal 6 karakter';

  @override
  String get createAccountTitle => 'Buat Akun';

  @override
  String get startTrackingToday => 'Mulai lacak kesehatan Anda hari ini';

  @override
  String get phoneNumber => 'Nomor telepon';

  @override
  String get confirmPassword => 'Konfirmasi password';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun?';

  @override
  String get signInLink => 'Masuk';

  @override
  String get nameRequired => 'Nama wajib diisi';

  @override
  String get nameShort => 'Masukkan nama lengkap Anda';

  @override
  String get phoneRequired => 'Nomor telepon wajib diisi';

  @override
  String get phoneInvalid => 'Masukkan nomor telepon yang valid';

  @override
  String get confirmPasswordRequired => 'Konfirmasi password Anda';

  @override
  String get passwordsDoNotMatch => 'Password tidak cocok';

  @override
  String passwordStrengthLabel(String level) {
    return 'Kekuatan password: $level';
  }

  @override
  String get passwordWeak => 'Lemah';

  @override
  String get passwordMedium => 'Sedang';

  @override
  String get passwordStrong => 'Kuat';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle =>
      'Masukkan email Anda dan kami akan kirim link untuk mereset password.';

  @override
  String get sendResetLink => 'Kirim Link Reset';

  @override
  String get checkInbox => 'Periksa kotak masuk Anda';

  @override
  String resetLinkSentTo(String email) {
    return 'Kami mengirim link reset password ke\n$email';
  }

  @override
  String get backToSignIn => 'Kembali ke halaman masuk';

  @override
  String get noHistoryYet => 'Belum ada riwayat';

  @override
  String get noHistorySubtitle =>
      'Hitung BMI Anda di tab Hitung dan riwayat Anda akan muncul di sini.';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get yourProgress => 'Kemajuan Anda';

  @override
  String entriesCount(int count) {
    return '$count entri';
  }

  @override
  String entryCount(int count) {
    return '$count entri';
  }

  @override
  String get average => 'Rata-rata';

  @override
  String get lowest => 'Terendah';

  @override
  String get highest => 'Tertinggi';

  @override
  String get trend => 'Tren';

  @override
  String get deleteRecordTitle => 'Hapus catatan?';

  @override
  String get deleteRecordContent =>
      'Catatan BMI ini akan dihapus secara permanen.';

  @override
  String get failedToLoadHistory => 'Gagal memuat riwayat';

  @override
  String get retry => 'Coba lagi';

  @override
  String get avgBmi => 'Rata-rata BMI';

  @override
  String get latestBmi => 'BMI Terbaru';

  @override
  String get bestBmi => 'BMI Terbaik';

  @override
  String get bmiTrend => 'Tren BMI';

  @override
  String lastNMeasurements(int count) {
    return '$count pengukuran terakhir';
  }

  @override
  String get categoryDistribution => 'Distribusi Kategori';

  @override
  String basedOnAllRecords(int count) {
    return 'Berdasarkan $count catatan';
  }

  @override
  String get recentMeasurements => 'Pengukuran Terbaru';

  @override
  String get last5Entries => '5 entri terakhir';

  @override
  String get noDataYet => 'Belum ada data';

  @override
  String get noDataSubtitle =>
      'Mulai lacak BMI Anda dan statistik akan muncul di sini.';

  @override
  String get trackingSectionTitle => 'Health Tracking';

  @override
  String get trackingSectionSubtitle =>
      'Log and monitor additional vital metrics';

  @override
  String get bpCardTitle => 'Blood Pressure';

  @override
  String get bpCardSubtitle =>
      'Systolic / diastolic tracking with WHO categories';

  @override
  String get bpOpen => 'Open';

  @override
  String get bpTitle => 'Blood Pressure';

  @override
  String get bpSaved => 'Reading saved';

  @override
  String get bpHistoryTitle => 'BP History';

  @override
  String get bpHistoryEmpty =>
      'No blood pressure readings yet.\nAdd one to start the trend.';

  @override
  String get bpTrendTitle => 'Trend';

  @override
  String get bpReadingsTitle => 'Readings';

  @override
  String get bpCategoryLabel => 'WHO Category:';

  @override
  String get bpSystolic => 'Systolic (top number)';

  @override
  String get bpDiastolic => 'Diastolic (bottom number)';

  @override
  String get bpPulse => 'Pulse (optional)';

  @override
  String get bpPulseHint => 'e.g. 72';

  @override
  String get bpPulseUnit => 'bpm';

  @override
  String get bpNotes => 'Notes';

  @override
  String get bpNotesHint => 'e.g. after morning walk';

  @override
  String get bpSave => 'Save Reading';

  @override
  String get bpCategoryNormal => 'Normal';

  @override
  String get bpCategoryElevated => 'Elevated';

  @override
  String get bpCategoryStage1 => 'High — Stage 1';

  @override
  String get bpCategoryStage2 => 'High — Stage 2';

  @override
  String get bpCategoryCrisis => 'Crisis';

  @override
  String get bsCardTitle => 'Blood Sugar';

  @override
  String get bsCardSubtitle => 'Glucose tracking with ADA categories';

  @override
  String get bsTitle => 'Blood Sugar';

  @override
  String get bsSaved => 'Reading saved';

  @override
  String get bsHistoryTitle => 'Glucose History';

  @override
  String get bsHistoryEmpty =>
      'No blood sugar readings yet.\nAdd one to start the trend.';

  @override
  String get bsTrendTitle => 'Trend';

  @override
  String get bsReadingsTitle => 'Readings';

  @override
  String get bsStatusLabel => 'ADA Status:';

  @override
  String get bsStatusNormal => 'Normal';

  @override
  String get bsStatusPrediabetes => 'Prediabetes';

  @override
  String get bsStatusDiabetes => 'Diabetes';

  @override
  String get bsLevel => 'Glucose Level';

  @override
  String get bsTypeLabel => 'Measurement Type';

  @override
  String get bsTypeFasting => 'Fasting';

  @override
  String get bsTypePostMeal => 'Post-meal';

  @override
  String get bsTypeRandom => 'Random';

  @override
  String get bsMealContext => 'Meal context (optional)';

  @override
  String get bsMealBeforeBreakfast => 'Before breakfast';

  @override
  String get bsMealAfterBreakfast => 'After breakfast';

  @override
  String get bsMealBeforeLunch => 'Before lunch';

  @override
  String get bsMealAfterLunch => 'After lunch';

  @override
  String get bsMealBeforeDinner => 'Before dinner';

  @override
  String get bsMealAfterDinner => 'After dinner';

  @override
  String get bsMealBedtime => 'Bedtime';

  @override
  String get bsNotes => 'Notes';

  @override
  String get bsNotesHint => 'e.g. took medication before reading';

  @override
  String get bsSave => 'Save Reading';

  @override
  String get bsEstimatedA1c => 'Est. A1C';

  @override
  String get bsA1cDisclosure =>
      'Estimated from average glucose — not a substitute for a lab test.';

  @override
  String get tabDashboard => 'Dashboard';

  @override
  String get subtitleDashboard => 'Your health at a glance';

  @override
  String get healthScoreTitle => 'Health Score';

  @override
  String get healthScoreNoData => 'Add measurements to see your health score';

  @override
  String get healthScorePillars => 'Score Breakdown';

  @override
  String get scoreExcellent => 'Excellent';

  @override
  String get scoreVeryGood => 'Very Good';

  @override
  String get scoreGood => 'Good';

  @override
  String get scoreFair => 'Fair';

  @override
  String get scoreNeedsImprovement => 'Needs Improvement';

  @override
  String get dashboardBmi => 'BMI';

  @override
  String get dashboardBp => 'Blood Pressure';

  @override
  String get dashboardGlucose => 'Glucose';

  @override
  String get dashboardAdvanced => 'Advanced';

  @override
  String get dashboardWhtr => 'Waist-to-height ratio';

  @override
  String get dashboardCorrelationTitle => 'BMI vs Glucose Correlation';

  @override
  String get healthScoreRecommendations => 'Recommendations';

  @override
  String get dashboardRecentBp => 'Latest Blood Pressure';

  @override
  String get dashboardRecentGlucose => 'Glucose Trend';

  @override
  String get recHealthyWeight => 'Reach a healthy weight';

  @override
  String get recHealthyWeightDetail =>
      'Aim for a BMI between 18.5 and 25 to reduce cardiovascular risk.';

  @override
  String get recHypertension => 'Manage blood pressure';

  @override
  String get recHypertensionDetail =>
      'Reduce sodium, exercise regularly, and track readings in the app.';

  @override
  String get recGlucose => 'Monitor blood sugar';

  @override
  String get recGlucoseDetail =>
      'Limit refined carbs and follow up with your clinician if levels stay elevated.';

  @override
  String get recCardio => 'Boost cardiovascular fitness';

  @override
  String get recCardioDetail =>
      'Regular aerobic activity can lower your resting heart rate over time.';

  @override
  String get recWaist => 'Reduce waist circumference';

  @override
  String get recWaistDetail =>
      'Target a waist-to-height ratio under 0.5 for better metabolic health.';

  @override
  String get recOnTrack => 'Great progress!';

  @override
  String get recOnTrackDetail =>
      'Your key metrics look healthy. Keep logging to maintain your score.';

  @override
  String get achievementCelebrationLabel => 'Achievement unlocked';

  @override
  String get achievementUnlocked => 'ACHIEVEMENT UNLOCKED · +';

  @override
  String get achievementNice => 'Nice!';

  @override
  String get achFirstCalculationTitle => 'First Calculation';

  @override
  String get achFirstCalculationDesc =>
      'Calculate your BMI for the first time.';

  @override
  String get achTenCalculationsTitle => 'Getting Started';

  @override
  String get achTenCalculationsDesc => 'Log 10 BMI calculations.';

  @override
  String get achFiftyCalculationsTitle => 'Power User';

  @override
  String get achFiftyCalculationsDesc => 'Log 50 BMI calculations.';

  @override
  String get achHundredCalculationsTitle => 'BMI Legend';

  @override
  String get achHundredCalculationsDesc => 'Log 100 BMI calculations.';

  @override
  String get achHealthyBmiTitle => 'Healthy Range';

  @override
  String get achHealthyBmiDesc => 'Record a BMI between 18.5 and 24.9.';

  @override
  String get achHealthyBpTitle => 'Calm & Normal';

  @override
  String get achHealthyBpDesc => 'Log a normal blood pressure reading.';

  @override
  String get achHealthyGlucoseTitle => 'Steady Glucose';

  @override
  String get achHealthyGlucoseDesc => 'Log a normal blood sugar reading.';

  @override
  String get achAllMetricsHealthyTitle => 'Full Bill of Health';

  @override
  String get achAllMetricsHealthyDesc =>
      'Have healthy BMI, blood pressure, and glucose readings.';

  @override
  String get achFirstBpTitle => 'First BP Reading';

  @override
  String get achFirstBpDesc => 'Log your first blood pressure reading.';

  @override
  String get achTenBpTitle => 'BP Watcher';

  @override
  String get achTenBpDesc => 'Log 10 blood pressure readings.';

  @override
  String get achFirstGlucoseTitle => 'First Glucose Reading';

  @override
  String get achFirstGlucoseDesc => 'Log your first blood sugar reading.';

  @override
  String get achTenGlucoseTitle => 'Glucose Observer';

  @override
  String get achTenGlucoseDesc => 'Log 10 blood sugar readings.';

  @override
  String get achThreeDayStreakTitle => 'Three in a Row';

  @override
  String get achThreeDayStreakDesc => 'Log a measurement 3 days in a row.';

  @override
  String get achSevenDayStreakTitle => 'Weekly Habit';

  @override
  String get achSevenDayStreakDesc => 'Log a measurement 7 days in a row.';

  @override
  String get achFourteenDayStreakTitle => 'Two Fortnights';

  @override
  String get achFourteenDayStreakDesc => 'Log a measurement 14 days in a row.';

  @override
  String get achThirtyDayStreakTitle => 'Unstoppable';

  @override
  String get achThirtyDayStreakDesc => 'Log a measurement 30 days in a row.';

  @override
  String get achPerfectWeekTitle => 'Perfect Week';

  @override
  String get achPerfectWeekDesc => 'Keep a 7-day best streak.';

  @override
  String get achOnARollTitle => 'On a Roll';

  @override
  String get achOnARollDesc => 'Log 5 measurements in a single day.';

  @override
  String get achEarlyBirdTitle => 'Early Bird';

  @override
  String get achEarlyBirdDesc => 'Log a measurement before 9 AM.';

  @override
  String get achNightOwlTitle => 'Night Owl';

  @override
  String get achNightOwlDesc => 'Log a measurement after 9 PM.';

  @override
  String get achAllTrackerTypesTitle => 'Total Tracker';

  @override
  String get achAllTrackerTypesDesc =>
      'Log a BMI, blood pressure, and glucose measurement.';

  @override
  String get achDashboardExcellentTitle => 'Peak Health';

  @override
  String get achDashboardExcellentDesc =>
      'Reach an excellent health score of 90+.';

  @override
  String get challengeLogBmiTitle => 'Log a BMI';

  @override
  String get challengeLogBmiDesc => 'Calculate your BMI once today.';

  @override
  String get challengeLogBpTitle => 'Check Blood Pressure';

  @override
  String get challengeLogBpDesc => 'Take a blood pressure reading today.';

  @override
  String get challengeLogGlucoseTitle => 'Check Glucose';

  @override
  String get challengeLogGlucoseDesc => 'Log a blood sugar reading today.';

  @override
  String get challengeLogAnyThreeTitle => 'Three Logs';

  @override
  String get challengeLogAnyThreeDesc => 'Log any 3 measurements today.';

  @override
  String get challengeLogHealthyTitle => 'Healthy Reading';

  @override
  String get challengeLogHealthyDesc =>
      'Log any reading in the normal range today.';

  @override
  String get dailyChallengeToday => 'Today\'s Challenge';

  @override
  String challengePointsFormat(Object points) {
    return '+$points pts';
  }

  @override
  String get challengeTierEasy => 'Easy';

  @override
  String get challengeTierMedium => 'Medium';

  @override
  String get challengeTierHard => 'Hard';

  @override
  String get challengeCompleted => 'CHALLENGE COMPLETED · +';

  @override
  String get challengeHistoryTitle => 'Challenge History';

  @override
  String get challengeHistoryError => 'Couldn\'t load challenge history.';

  @override
  String get challengeHistoryEmpty =>
      'No challenges yet. Check back tomorrow for your first one!';

  @override
  String get reminderSettingsTitle => 'Smart Reminders';

  @override
  String get reminderBmiTitle => 'Weight Check Reminder';

  @override
  String get reminderBmiBody =>
      'Time for a quick BMI calculation to keep your progress updated!';

  @override
  String get reminderHydrationTitle => 'Hydration Check-In';

  @override
  String get reminderHydrationBody =>
      'Drink some water! Staying hydrated supports metabolic health.';

  @override
  String get reminderActivityTitle => 'Get Moving Prompt';

  @override
  String get reminderActivityBody =>
      'Time for a stretch or a short walk. Keep active!';

  @override
  String get reminderHealthTipTitle => 'Daily Health Tip';

  @override
  String get reminderHealthTipBody =>
      'Open the app for a quick daily health insight to guide your journey.';

  @override
  String get reminderMedicationTitle => 'Medication Reminder';

  @override
  String get reminderMedicationBody =>
      'Friendly reminder: take your scheduled medicine or vitamins.';

  @override
  String get reminderChallengeTitle => 'Daily Challenge';

  @override
  String get reminderChallengeBody =>
      'Don\'t miss out on today\'s challenge! Complete it to earn points.';

  @override
  String get remindersLabel => 'Medication label';

  @override
  String get remindersTime => 'Time';

  @override
  String get remindersDays => 'Days';

  @override
  String get remindersEnabled => 'Enabled';

  @override
  String get everyday => 'Every day';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get weekends => 'Weekends';

  @override
  String get customDays => 'Custom';

  @override
  String get deleteReminder => 'Delete Reminder';

  @override
  String get addCustomMedication => 'Add Custom Medication Reminder';

  @override
  String get reminderSmartHint =>
      'Auto-skipped today once you log the matching metric';

  @override
  String get medicationNameHint => 'e.g. Vitamin D';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get achievementsError => 'Couldn\'t load your achievements.';

  @override
  String get achievementsTotalPoints => 'Total Points';

  @override
  String get achievementsCurrentStreak => 'Current Streak';

  @override
  String get achievementsBestStreak => 'Best Streak';

  @override
  String achievementsUnlockedCount(int count, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count of $total unlocked',
      one: '1 of $total unlocked',
    );
    return '$_temp0';
  }

  @override
  String achievementsStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get wearableTitle => 'Health Data';

  @override
  String get wearableConnectTitle => 'Connect health data';

  @override
  String get wearableConnectSubtitle =>
      'Link Google Health Connect or Apple Health to pull your fitness vitals into your Insights.';

  @override
  String get wearableGrantBtn => 'Grant Access';

  @override
  String get wearableGrantingBtn => 'Requesting access…';

  @override
  String get wearableGrantedTitle => 'Connected';

  @override
  String get wearableGrantedSubtitle =>
      'Health data is flowing into your Insights.';

  @override
  String get wearableRevokeBtn => 'Disconnect';

  @override
  String get wearableRefreshBtn => 'Refresh';

  @override
  String get wearableDryRun => 'No measurements found in the last 24 hours.';

  @override
  String get wearableRevokedSubtitle =>
      'You are no longer connected to health data.';

  @override
  String get wearableStepInPerm =>
      'Steps are read as an activity summary; the app needs Activity Recognition.';

  @override
  String get wearableErrorGeneric =>
      'Could not connect to health data. Please make sure Health Connect is installed (Android) or Health is allowed in Settings (iOS).';

  @override
  String get wearableErrorPermission =>
      'Access was denied. You can re-enable access from Health Connect on your device.';

  @override
  String get wearableImportBtn => 'Import to history';

  @override
  String wearableImportSuccess(int count) {
    return '$count readings added';
  }

  @override
  String get wearableImportNothing => 'No new readings to add';

  @override
  String get wearableAutoFillUse => 'Use';

  @override
  String get metricSteps => 'Steps';

  @override
  String get metricWeight => 'Weight';

  @override
  String get metricBloodPressure => 'Blood pressure';

  @override
  String get metricGlucose => 'Glucose';

  @override
  String get metricHeartRate => 'Heart rate';

  @override
  String get metricRestingHr => 'Resting HR';

  @override
  String get metricWater => 'Water';

  @override
  String get metricPermissions => 'Permissions';

  @override
  String wearableValidationRejected(int count) {
    return '$count reading(s) rejected (out of range)';
  }

  @override
  String get exportTitle => 'Export Health Report';

  @override
  String get exportSubtitle =>
      'Download your health, weight, and vitals history';

  @override
  String get exportBtn => 'Export';

  @override
  String get exportFormatLabel => 'Format';

  @override
  String get exportAnonymizeLabel => 'Anonymize data';

  @override
  String get exportAnonymizeSub => 'Hide personal details like emails and ID';

  @override
  String get exportShareBtn => 'Generate and Share';
}
