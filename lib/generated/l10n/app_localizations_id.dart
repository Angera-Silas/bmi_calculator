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
}
