// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BMI计算器';

  @override
  String get appTagline => '跟踪 · 了解 · 改善';

  @override
  String get trackHealthJourney => '跟踪您的健康之旅';

  @override
  String get tabCalculate => '计算';

  @override
  String get tabHistory => '历史';

  @override
  String get tabInsights => '统计';

  @override
  String get subtitleCalculate => '在下方输入您的数据';

  @override
  String get subtitleHistory => '您的历次BMI计算';

  @override
  String get subtitleInsights => '趋势与分析';

  @override
  String get liveBmiPreview => 'BMI实时预览';

  @override
  String get metricUnits => '公制 (cm/kg)';

  @override
  String get imperialUnits => '英制 (ft/lbs)';

  @override
  String get biologicalSex => '生理性别';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get height => '身高';

  @override
  String get weight => '体重';

  @override
  String get age => '年龄';

  @override
  String get years => '岁';

  @override
  String get healthConditions => '健康状况（可选）';

  @override
  String get pregnancyStatus => '怀孕状态（可选）';

  @override
  String get prePregnancyWeight => '孕前体重（可选）';

  @override
  String get weightInKg => '体重（千克）';

  @override
  String get weightInLbs => '体重（磅）';

  @override
  String get calculateBmi => '计算BMI';

  @override
  String get selectGenderError => '请选择性别以继续';

  @override
  String get signInToSave => '请登录以保存计算结果';

  @override
  String get shortUnderweight => '· 体重不足';

  @override
  String get shortNormal => '· 正常';

  @override
  String get shortOverweight => '· 超重';

  @override
  String get shortObese => '· 肥胖';

  @override
  String get yourResults => '您的结果';

  @override
  String get bodyMassIndex => '身体质量指数';

  @override
  String get whatThisMeans => '这意味着什么';

  @override
  String get idealWeightRange => '理想体重范围';

  @override
  String get minLabel => '最小';

  @override
  String get maxLabel => '最大';

  @override
  String get dailyCalories => '每日卡路里';

  @override
  String get kcalPerDay => '千卡/天';

  @override
  String get waterIntake => '每日饮水量';

  @override
  String get litresPerDay => '升/天';

  @override
  String get healthConsideration => '健康注意事项';

  @override
  String get nutritionRecommendations => '营养建议';

  @override
  String get dailyMealPlan => '每日饮食计划';

  @override
  String get macronutrientBalance => '宏量营养素平衡';

  @override
  String get focusFoods => '重点食物';

  @override
  String get keyRecommendations => '关键建议';

  @override
  String get bmiScale => 'BMI量表';

  @override
  String get reCalculate => '重新计算';

  @override
  String get resultCopied => '结果已复制到剪贴板！';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String moreRecommendations(int count) {
    return '...还有$count条建议';
  }

  @override
  String shareText(String bmi, String category, String interpretation) {
    return '我的BMI是$bmi — $category\n$interpretation\n通过BMI Calculator App记录';
  }

  @override
  String get bmiSeverelyUnderweight => '严重体重不足';

  @override
  String get bmiUnderweight => '体重不足';

  @override
  String get bmiNormalWeight => '正常体重';

  @override
  String get bmiOverweight => '超重';

  @override
  String get bmiObeseI => '肥胖I级';

  @override
  String get bmiObeseII => '肥胖II级';

  @override
  String get bmiSeverelyObese => '极度肥胖';

  @override
  String get profile => '个人资料';

  @override
  String get edit => '编辑';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get guestUser => '访客用户';

  @override
  String get guestModeLocal => '访客模式 · 数据仅存储在本地';

  @override
  String get guestModeBanner => '访客模式 — 数据仅存储在本地。创建账号以在设备间同步。';

  @override
  String get personalInformation => '个人信息';

  @override
  String get fullName => '全名';

  @override
  String get email => '电子邮件';

  @override
  String get phone => '电话';

  @override
  String get notAvailable => 'N/A';

  @override
  String get account => '账户';

  @override
  String get totalChecks => '总检测次数';

  @override
  String get averageBmi => '平均BMI';

  @override
  String get createAccount => '创建账号';

  @override
  String get signIn => '登录';

  @override
  String get changePassword => '更改密码';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get leaveGuestMode => '退出访客模式';

  @override
  String get signOut => '退出登录';

  @override
  String get profileUpdated => '个人资料已更新';

  @override
  String get leaveGuestTitle => '退出访客模式？';

  @override
  String get signOutTitle => '退出登录？';

  @override
  String get leaveGuestContent => '您的本地数据将被清除。登录或创建账号以保留您的历史记录。';

  @override
  String get signOutContent => '您可以随时重新登录以访问同步数据。';

  @override
  String get leave => '离开';

  @override
  String get deleteAccountTitle => '删除账号？';

  @override
  String get deleteAccountContent => '这将永久删除您的账号和所有数据，此操作无法撤销。';

  @override
  String get delete => '删除';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get signInToContinue => '登录以继续';

  @override
  String get emailAddress => '电子邮件地址';

  @override
  String get password => '密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get continueAsGuest => '以访客身份继续';

  @override
  String get dontHaveAccount => '没有账号？';

  @override
  String get createOne => '创建一个';

  @override
  String get emailRequired => '电子邮件为必填项';

  @override
  String get emailInvalid => '请输入有效的电子邮件地址';

  @override
  String get passwordRequired => '密码为必填项';

  @override
  String get passwordTooShort => '密码至少需要6个字符';

  @override
  String get createAccountTitle => '创建账号';

  @override
  String get startTrackingToday => '今天开始追踪您的健康';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get alreadyHaveAccount => '已有账号？';

  @override
  String get signInLink => '登录';

  @override
  String get nameRequired => '姓名为必填项';

  @override
  String get nameShort => '请输入您的全名';

  @override
  String get phoneRequired => '电话号码为必填项';

  @override
  String get phoneInvalid => '请输入有效的电话号码';

  @override
  String get confirmPasswordRequired => '请确认您的密码';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不匹配';

  @override
  String passwordStrengthLabel(String level) {
    return '密码强度：$level';
  }

  @override
  String get passwordWeak => '弱';

  @override
  String get passwordMedium => '中';

  @override
  String get passwordStrong => '强';

  @override
  String get resetPasswordTitle => '重置密码';

  @override
  String get resetPasswordSubtitle => '输入您的电子邮件地址，我们将发送重置密码链接。';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get checkInbox => '查看您的收件箱';

  @override
  String resetLinkSentTo(String email) {
    return '我们已发送密码重置链接至\n$email';
  }

  @override
  String get backToSignIn => '返回登录';

  @override
  String get noHistoryYet => '暂无历史记录';

  @override
  String get noHistorySubtitle => '在首页计算您的BMI，历史记录将显示在此处。';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get yourProgress => '您的进度';

  @override
  String entriesCount(int count) {
    return '$count条记录';
  }

  @override
  String entryCount(int count) {
    return '$count条记录';
  }

  @override
  String get average => '平均';

  @override
  String get lowest => '最低';

  @override
  String get highest => '最高';

  @override
  String get trend => '趋势';

  @override
  String get deleteRecordTitle => '删除记录？';

  @override
  String get deleteRecordContent => '此BMI记录将被永久删除。';

  @override
  String get failedToLoadHistory => '加载历史记录失败';

  @override
  String get retry => '重试';

  @override
  String get avgBmi => '平均BMI';

  @override
  String get latestBmi => '最新BMI';

  @override
  String get bestBmi => '最佳BMI';

  @override
  String get bmiTrend => 'BMI趋势';

  @override
  String lastNMeasurements(int count) {
    return '最近$count次测量';
  }

  @override
  String get categoryDistribution => '类别分布';

  @override
  String basedOnAllRecords(int count) {
    return '基于全部$count条记录';
  }

  @override
  String get recentMeasurements => '最近测量';

  @override
  String get last5Entries => '最近5条';

  @override
  String get noDataYet => '暂无数据';

  @override
  String get noDataSubtitle => '开始追踪您的BMI，统计数据将显示在此处。';
}
