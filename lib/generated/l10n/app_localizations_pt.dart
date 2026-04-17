// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Calculadora IMC';

  @override
  String get appTagline => 'Rastrear · Entender · Melhorar';

  @override
  String get trackHealthJourney => 'Acompanhe sua jornada de saúde';

  @override
  String get tabCalculate => 'Calcular';

  @override
  String get tabHistory => 'Histórico';

  @override
  String get tabInsights => 'Estatísticas';

  @override
  String get subtitleCalculate => 'Insira suas medidas abaixo';

  @override
  String get subtitleHistory => 'Seus cálculos de IMC anteriores';

  @override
  String get subtitleInsights => 'Tendências e análises';

  @override
  String get liveBmiPreview => 'Prévia do IMC';

  @override
  String get metricUnits => 'Métrico (cm/kg)';

  @override
  String get imperialUnits => 'Imperial (ft/lbs)';

  @override
  String get biologicalSex => 'Sexo biológico';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Feminino';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get age => 'Idade';

  @override
  String get years => 'anos';

  @override
  String get healthConditions => 'Condições de saúde (opcional)';

  @override
  String get pregnancyStatus => 'Estado de gravidez (opcional)';

  @override
  String get prePregnancyWeight => 'Peso pré-gravidez (opcional)';

  @override
  String get weightInKg => 'Peso em kg';

  @override
  String get weightInLbs => 'Peso em lbs';

  @override
  String get calculateBmi => 'Calcular IMC';

  @override
  String get selectGenderError =>
      'Por favor, selecione seu sexo para continuar';

  @override
  String get signInToSave => 'Por favor, faça login para salvar seu cálculo';

  @override
  String get shortUnderweight => '· Abaixo do peso';

  @override
  String get shortNormal => '· Normal';

  @override
  String get shortOverweight => '· Sobrepeso';

  @override
  String get shortObese => '· Obeso';

  @override
  String get yourResults => 'Seus Resultados';

  @override
  String get bodyMassIndex => 'Índice de Massa Corporal';

  @override
  String get whatThisMeans => 'O que isso significa';

  @override
  String get idealWeightRange => 'Faixa de Peso Ideal';

  @override
  String get minLabel => 'Mín';

  @override
  String get maxLabel => 'Máx';

  @override
  String get dailyCalories => 'Calorias Diárias';

  @override
  String get kcalPerDay => 'kcal/dia';

  @override
  String get waterIntake => 'Ingestão de Água';

  @override
  String get litresPerDay => 'litros/dia';

  @override
  String get healthConsideration => 'Consideração de Saúde';

  @override
  String get nutritionRecommendations => 'Recomendações Nutricionais';

  @override
  String get dailyMealPlan => 'Plano Alimentar Diário';

  @override
  String get macronutrientBalance => 'Equilíbrio de Macronutrientes';

  @override
  String get focusFoods => 'Alimentos Principais';

  @override
  String get keyRecommendations => 'Recomendações Principais';

  @override
  String get bmiScale => 'Escala IMC';

  @override
  String get reCalculate => 'Recalcular';

  @override
  String get resultCopied => 'Resultado copiado para a área de transferência!';

  @override
  String get copyToClipboard => 'Copiar para a área de transferência';

  @override
  String moreRecommendations(int count) {
    return '... e mais $count recomendações';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return 'Meu IMC é $bmi — $category\n$interpretation\nRegistrado com BMI Calculator App';
  }

  @override
  String get bmiSeverelyUnderweight => 'Magreza Severa';

  @override
  String get bmiUnderweight => 'Abaixo do Peso';

  @override
  String get bmiNormalWeight => 'Peso Normal';

  @override
  String get bmiOverweight => 'Sobrepeso';

  @override
  String get bmiObeseI => 'Obesidade Grau I';

  @override
  String get bmiObeseII => 'Obesidade Grau II';

  @override
  String get bmiSeverelyObese => 'Obesidade Grave';

  @override
  String get profile => 'Perfil';

  @override
  String get edit => 'Editar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get guestUser => 'Usuário convidado';

  @override
  String get guestModeLocal => 'Modo convidado · dados armazenados localmente';

  @override
  String get guestModeBanner =>
      'Modo convidado — dados armazenados apenas localmente. Crie uma conta para sincronizar entre dispositivos.';

  @override
  String get personalInformation => 'Informações Pessoais';

  @override
  String get fullName => 'Nome completo';

  @override
  String get email => 'E-mail';

  @override
  String get phone => 'Telefone';

  @override
  String get notAvailable => 'N/D';

  @override
  String get account => 'Conta';

  @override
  String get totalChecks => 'Total de verificações';

  @override
  String get averageBmi => 'IMC médio';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get signIn => 'Entrar';

  @override
  String get changePassword => 'Alterar senha';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get leaveGuestMode => 'Sair do modo convidado';

  @override
  String get signOut => 'Sair';

  @override
  String get profileUpdated => 'Perfil atualizado';

  @override
  String get leaveGuestTitle => 'Sair do modo convidado?';

  @override
  String get signOutTitle => 'Sair?';

  @override
  String get leaveGuestContent =>
      'Seus dados locais serão excluídos. Entre ou crie uma conta para manter seu histórico.';

  @override
  String get signOutContent => 'Você pode entrar novamente a qualquer momento.';

  @override
  String get leave => 'Sair';

  @override
  String get deleteAccountTitle => 'Excluir conta?';

  @override
  String get deleteAccountContent =>
      'Isso excluirá permanentemente sua conta e todos os dados. Não é possível desfazer.';

  @override
  String get delete => 'Excluir';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get welcomeBack => 'Bem-vindo de volta';

  @override
  String get signInToContinue => 'Entre para continuar';

  @override
  String get emailAddress => 'Endereço de e-mail';

  @override
  String get password => 'Senha';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get continueAsGuest => 'Continuar como convidado';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get createOne => 'Criar uma';

  @override
  String get emailRequired => 'E-mail é obrigatório';

  @override
  String get emailInvalid => 'Insira um endereço de e-mail válido';

  @override
  String get passwordRequired => 'Senha é obrigatória';

  @override
  String get passwordTooShort => 'A senha deve ter pelo menos 6 caracteres';

  @override
  String get createAccountTitle => 'Criar conta';

  @override
  String get startTrackingToday => 'Comece a monitorar sua saúde hoje';

  @override
  String get phoneNumber => 'Número de telefone';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get signInLink => 'Entrar';

  @override
  String get nameRequired => 'Nome é obrigatório';

  @override
  String get nameShort => 'Insira seu nome completo';

  @override
  String get phoneRequired => 'Número de telefone é obrigatório';

  @override
  String get phoneInvalid => 'Insira um número de telefone válido';

  @override
  String get confirmPasswordRequired => 'Por favor, confirme sua senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String passwordStrengthLabel(String level) {
    return 'Força da senha: $level';
  }

  @override
  String get passwordWeak => 'Fraca';

  @override
  String get passwordMedium => 'Média';

  @override
  String get passwordStrong => 'Forte';

  @override
  String get resetPasswordTitle => 'Redefinir senha';

  @override
  String get resetPasswordSubtitle =>
      'Insira seu e-mail e enviaremos um link para redefinir sua senha.';

  @override
  String get sendResetLink => 'Enviar link';

  @override
  String get checkInbox => 'Verifique sua caixa de entrada';

  @override
  String resetLinkSentTo(String email) {
    return 'Enviamos um link de redefinição para\n$email';
  }

  @override
  String get backToSignIn => 'Voltar ao login';

  @override
  String get noHistoryYet => 'Sem histórico ainda';

  @override
  String get noHistorySubtitle =>
      'Calcule seu IMC na aba principal e seu histórico aparecerá aqui.';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get yourProgress => 'Seu Progresso';

  @override
  String entriesCount(int count) {
    return '$count registros';
  }

  @override
  String entryCount(int count) {
    return '$count registro';
  }

  @override
  String get average => 'Média';

  @override
  String get lowest => 'Mínimo';

  @override
  String get highest => 'Máximo';

  @override
  String get trend => 'Tendência';

  @override
  String get deleteRecordTitle => 'Excluir registro?';

  @override
  String get deleteRecordContent =>
      'Este registro de IMC será excluído permanentemente.';

  @override
  String get failedToLoadHistory => 'Falha ao carregar histórico';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get avgBmi => 'IMC Médio';

  @override
  String get latestBmi => 'Último IMC';

  @override
  String get bestBmi => 'Melhor IMC';

  @override
  String get bmiTrend => 'Tendência IMC';

  @override
  String lastNMeasurements(int count) {
    return 'Últimas $count medições';
  }

  @override
  String get categoryDistribution => 'Distribuição por categoria';

  @override
  String basedOnAllRecords(int count) {
    return 'Com base em $count registros';
  }

  @override
  String get recentMeasurements => 'Medições Recentes';

  @override
  String get last5Entries => 'Últimos 5 registros';

  @override
  String get noDataYet => 'Sem dados ainda';

  @override
  String get noDataSubtitle =>
      'Comece a monitorar seu IMC e suas estatísticas aparecerão aqui.';
}
