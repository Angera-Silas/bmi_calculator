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
}
