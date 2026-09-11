// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calculadora IMC';

  @override
  String get appTagline => 'Rastrea · Entiende · Mejora';

  @override
  String get trackHealthJourney => 'Sigue tu camino de salud';

  @override
  String get tabCalculate => 'Calcular';

  @override
  String get tabHistory => 'Historial';

  @override
  String get tabInsights => 'Estadísticas';

  @override
  String get subtitleCalculate => 'Ingresa tus medidas abajo';

  @override
  String get subtitleHistory => 'Tus cálculos de IMC anteriores';

  @override
  String get subtitleInsights => 'Tendencias y análisis';

  @override
  String get liveBmiPreview => 'Vista previa IMC';

  @override
  String get metricUnits => 'Métrico (cm/kg)';

  @override
  String get imperialUnits => 'Imperial (ft/lbs)';

  @override
  String get biologicalSex => 'Sexo biológico';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Femenino';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get age => 'Edad';

  @override
  String get years => 'años';

  @override
  String get healthConditions => 'Condiciones de salud (opcional)';

  @override
  String get pregnancyStatus => 'Estado de embarazo (opcional)';

  @override
  String get prePregnancyWeight => 'Peso antes del embarazo (opcional)';

  @override
  String get weightInKg => 'Peso en kg';

  @override
  String get weightInLbs => 'Peso en lbs';

  @override
  String get calculateBmi => 'Calcular IMC';

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
  String get selectGenderError => 'Por favor selecciona tu sexo para continuar';

  @override
  String get signInToSave => 'Por favor inicia sesión para guardar tu cálculo';

  @override
  String get shortUnderweight => '· Bajo peso';

  @override
  String get shortNormal => '· Normal';

  @override
  String get shortOverweight => '· Sobrepeso';

  @override
  String get shortObese => '· Obeso';

  @override
  String get yourResults => 'Tus Resultados';

  @override
  String get bodyMassIndex => 'Índice de Masa Corporal';

  @override
  String get whatThisMeans => 'Qué significa esto';

  @override
  String get idealWeightRange => 'Rango de Peso Ideal';

  @override
  String get minLabel => 'Mín';

  @override
  String get maxLabel => 'Máx';

  @override
  String get dailyCalories => 'Calorías Diarias';

  @override
  String get kcalPerDay => 'kcal/día';

  @override
  String get waterIntake => 'Ingesta de Agua';

  @override
  String get litresPerDay => 'litros/día';

  @override
  String get healthConsideration => 'Consideración de Salud';

  @override
  String get nutritionRecommendations => 'Recomendaciones Nutricionales';

  @override
  String get dailyMealPlan => 'Plan de Comidas Diario';

  @override
  String get macronutrientBalance => 'Balance de Macronutrientes';

  @override
  String get focusFoods => 'Alimentos Principales';

  @override
  String get keyRecommendations => 'Recomendaciones Clave';

  @override
  String get bmiScale => 'Escala IMC';

  @override
  String get reCalculate => 'Recalcular';

  @override
  String get resultCopied => '¡Resultado copiado al portapapeles!';

  @override
  String get copyToClipboard => 'Copiar al portapapeles';

  @override
  String moreRecommendations(int count) {
    return '... y $count recomendaciones más';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'Mi IMC es $bmi — $category\n$interpretation\nRegistrado con BMI Calculator App';
  }

  @override
  String get bmiSeverelyUnderweight => 'Bajo Peso Severo';

  @override
  String get bmiUnderweight => 'Bajo Peso';

  @override
  String get bmiNormalWeight => 'Peso Normal';

  @override
  String get bmiOverweight => 'Sobrepeso';

  @override
  String get bmiObeseI => 'Obesidad Clase I';

  @override
  String get bmiObeseII => 'Obesidad Clase II';

  @override
  String get bmiSeverelyObese => 'Obesidad Severa';

  @override
  String get profile => 'Perfil';

  @override
  String get edit => 'Editar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get guestUser => 'Usuario Invitado';

  @override
  String get guestModeLocal => 'Modo invitado · datos almacenados localmente';

  @override
  String get guestModeBanner =>
      'Modo invitado — los datos se almacenan solo localmente. Crea una cuenta para sincronizar entre dispositivos.';

  @override
  String get personalInformation => 'Información Personal';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get email => 'Correo electrónico';

  @override
  String get phone => 'Teléfono';

  @override
  String get notAvailable => 'N/D';

  @override
  String get account => 'Cuenta';

  @override
  String get totalChecks => 'Total de Controles';

  @override
  String get averageBmi => 'IMC Promedio';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get deleteAccount => 'Eliminar Cuenta';

  @override
  String get leaveGuestMode => 'Salir del Modo Invitado';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get leaveGuestTitle => '¿Salir del modo invitado?';

  @override
  String get signOutTitle => '¿Cerrar sesión?';

  @override
  String get leaveGuestContent =>
      'Tus datos locales serán eliminados. Inicia sesión o crea una cuenta para conservar tu historial.';

  @override
  String get signOutContent =>
      'Puedes iniciar sesión nuevamente en cualquier momento para acceder a tus datos sincronizados.';

  @override
  String get leave => 'Salir';

  @override
  String get deleteAccountTitle => '¿Eliminar cuenta?';

  @override
  String get deleteAccountContent =>
      'Esto eliminará permanentemente tu cuenta y todos tus datos. Esta acción no se puede deshacer.';

  @override
  String get delete => 'Eliminar';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get signInToContinue => 'Inicia sesión para continuar';

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get continueAsGuest => 'Continuar como invitado';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get createOne => 'Crear una';

  @override
  String get emailRequired => 'El correo electrónico es obligatorio';

  @override
  String get emailInvalid => 'Ingresa una dirección de correo válida';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get createAccountTitle => 'Crear Cuenta';

  @override
  String get startTrackingToday => 'Empieza a seguir tu salud hoy';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get signInLink => 'Iniciar sesión';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get nameShort => 'Ingresa tu nombre completo';

  @override
  String get phoneRequired => 'El número de teléfono es obligatorio';

  @override
  String get phoneInvalid => 'Ingresa un número de teléfono válido';

  @override
  String get confirmPasswordRequired => 'Por favor confirma tu contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String passwordStrengthLabel(String level) {
    return 'Fortaleza de contraseña: $level';
  }

  @override
  String get passwordWeak => 'Débil';

  @override
  String get passwordMedium => 'Media';

  @override
  String get passwordStrong => 'Fuerte';

  @override
  String get resetPasswordTitle => 'Restablecer Contraseña';

  @override
  String get resetPasswordSubtitle =>
      'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get sendResetLink => 'Enviar Enlace';

  @override
  String get checkInbox => 'Revisa tu bandeja de entrada';

  @override
  String resetLinkSentTo(String email) {
    return 'Enviamos un enlace para restablecer la contraseña a\n$email';
  }

  @override
  String get backToSignIn => 'Volver al inicio de sesión';

  @override
  String get noHistoryYet => 'Sin historial aún';

  @override
  String get noHistorySubtitle =>
      'Calcula tu IMC en la pestaña de inicio y tu historial aparecerá aquí.';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get yourProgress => 'Tu Progreso';

  @override
  String entriesCount(int count) {
    return '$count entradas';
  }

  @override
  String entryCount(int count) {
    return '$count entrada';
  }

  @override
  String get average => 'Promedio';

  @override
  String get lowest => 'Mínimo';

  @override
  String get highest => 'Máximo';

  @override
  String get trend => 'Tendencia';

  @override
  String get deleteRecordTitle => '¿Eliminar registro?';

  @override
  String get deleteRecordContent =>
      'Esto eliminará permanentemente este registro de IMC.';

  @override
  String get failedToLoadHistory => 'Error al cargar historial';

  @override
  String get retry => 'Reintentar';

  @override
  String get avgBmi => 'IMC Prom.';

  @override
  String get latestBmi => 'IMC Más Reciente';

  @override
  String get bestBmi => 'Mejor IMC';

  @override
  String get bmiTrend => 'Tendencia IMC';

  @override
  String lastNMeasurements(int count) {
    return 'Últimas $count mediciones';
  }

  @override
  String get categoryDistribution => 'Distribución por Categoría';

  @override
  String basedOnAllRecords(int count) {
    return 'Basado en $count registros';
  }

  @override
  String get recentMeasurements => 'Mediciones Recientes';

  @override
  String get last5Entries => 'Últimas 5 entradas';

  @override
  String get noDataYet => 'Sin datos aún';

  @override
  String get noDataSubtitle =>
      'Empieza a registrar tu IMC y tus estadísticas aparecerán aquí.';

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
