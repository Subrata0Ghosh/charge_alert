// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => '智能充电与电池卫士';

  @override
  String get batteryLevel => '电池电量';

  @override
  String get batteryCharging => '充电中';

  @override
  String get batteryDischarging => '放电中';

  @override
  String get batteryFull => '已充满';

  @override
  String get batteryNotCharging => '未充电';

  @override
  String get batteryUnknown => '未知';

  @override
  String get hyperCharging => '极速快充';

  @override
  String get batteryFullCaps => '电量已满';

  @override
  String get dischargingCaps => '放电中';

  @override
  String get targetAlertLimit => '目标警报电量';

  @override
  String get targetAlertSubtitle => '当电池达到该百分比时发出警报';

  @override
  String get chargingAlarm => '充电警报';

  @override
  String get chargingAlarmSubtitle => '达到目标电量时响铃提醒';

  @override
  String get continuousAlarm => '持续警报';

  @override
  String get continuousAlarmSubtitle => '持续响铃直至手动关闭';

  @override
  String get lowBatteryAlert => '低电量提醒';

  @override
  String get lowBatteryAlertSubtitle => '电量不足时响铃提醒';

  @override
  String get lowBatteryWarning => '低电量警告';

  @override
  String get guardianTitle => '防盗卫士';

  @override
  String get guardianSubtitle => '拔掉充电器时发出警报巨响';

  @override
  String get guardianArmed => '防盗已布防';

  @override
  String get guardianDisarmed => '防盗已撤防';

  @override
  String get guardianArmedStatus => '布防中·严密保护';

  @override
  String get guardianDisarmedStatus => '已撤防 / 待命中';

  @override
  String get armGuardian => '开启防盗布防';

  @override
  String get disarmGuardian => '解除防盗布防';

  @override
  String get guardianDescription => '布防状态下，一旦有人拔掉充电线，将持续发出高分贝警报，直至输入4位数字PIN码。';

  @override
  String get guardianDisarmPrompt => '请输入4位数字PIN码以解除防盗模式。';

  @override
  String get setPinTitle => '设置安全PIN码';

  @override
  String get setPinPrompt => '创建4位数PIN码以保护防盗卫士。';

  @override
  String get confirmPin => '确认安全PIN码';

  @override
  String get enterPin => '输入4位数PIN码';

  @override
  String get wrongPin => 'PIN码错误，请重试。';

  @override
  String get pinsDoNotMatch => '两次输入的PIN码不一致';

  @override
  String get savePin => '保存PIN码';

  @override
  String get theftAlarmActive => '防盗警报触发！';

  @override
  String get alarmRinging => '警报正在响铃！';

  @override
  String get theftAlarmSubtitle => '充电器已被拔出！需要PIN码。';

  @override
  String get targetReachedSubtitle => '已达到目标电量或警报生效';

  @override
  String get stop => '停止';

  @override
  String get disarm => '撤防';

  @override
  String get temperature => '温度';

  @override
  String get voltage => '电压';

  @override
  String get health => '健康度';

  @override
  String get healthGood => '良好';

  @override
  String get plugged => '连接状态';

  @override
  String get pluggedAc => '交流充电器';

  @override
  String get pluggedUsb => 'USB端口';

  @override
  String get pluggedWireless => '无线充电';

  @override
  String get pluggedNone => '未连接';

  @override
  String get technology => '电池技术';

  @override
  String get theme => '主题';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get language => '语言';

  @override
  String get languageSelect => '选择语言';

  @override
  String get chargeHistory => '充电历史';

  @override
  String get noHistory => '暂无记录';

  @override
  String get clearHistory => '清空记录';

  @override
  String get about => '关于应用';

  @override
  String get contribute => '赞助支持';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get faq => '常见问题';

  @override
  String get shareApp => '分享应用';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get ok => '确定';

  @override
  String get voltEnergized => '✨ 系统运转一切正常！';

  @override
  String get voltCharging => '⚡ 正在汲取能量！快速而平稳！';

  @override
  String get voltTargetReached => '🎉 达到目标电量！拔掉插头以延长电池寿命！';

  @override
  String get voltLowBattery => '🪫 电量快用完了……快给我充充电！';

  @override
  String get voltOverheating => '🔥 温度有些高！让我冷却一会儿！';

  @override
  String get voltGuardianArmed => '🛡️ 卫士已就绪。拔出充电线将触发警报！';

  @override
  String get voltTheftAlarm => '🚨 警报！请立即停止警报！';

  @override
  String get quickFaqTitle => '快捷答疑';

  @override
  String get faqWhyNoAlarm => '为什么警报没有响？';

  @override
  String get faqWhyNoAlarmDesc => '请确保已允许后台运行权限、自启动权限以及开启通知声音。';

  @override
  String get faqBackgroundActivity => '后台活动';

  @override
  String get faqAutostart => '自动启动';

  @override
  String get faqNotifications => '通知权限';

  @override
  String get faqOemSettings => '如何开启自启动？';

  @override
  String get faqOemSettingsDesc =>
      '各手机厂商（如小米/OPPO/vivo）在系统设置中位置不同，可点击上方快捷入口设置。';

  @override
  String get replaySplashScreen => '重播启动画面';

  @override
  String get introWalkthrough => '介绍与引导';

  @override
  String get armedCaps => '已设防';

  @override
  String get idleCaps => '空闲';

  @override
  String get guardianSirenWarning => '拔掉充电器时警报响起并锁定屏幕';

  @override
  String get guardianUnplugWarning => '如果有人拔掉手机，则发出警报';

  @override
  String get protectedWithPin => '🔒 受4位数PIN码保护';

  @override
  String get changePin => '更改PIN码';

  @override
  String get changeSecurityPin => '更改安全PIN码';

  @override
  String get pinUpdatedSuccess => '安全PIN码更新成功！';

  @override
  String get runningWarm => '温度较高';

  @override
  String get nominalTemp => '正常温度';

  @override
  String get operatingWell => '运行良好';

  @override
  String get powerSource => '电源';

  @override
  String get activeInput => '充电中';

  @override
  String get disconnected => '已断开';

  @override
  String get alertMeWhenReaches => '电量达到以下值时提醒我：';

  @override
  String get enableAlarmSound => '启用报警声音';

  @override
  String get continuousAlarmDesc => '警报将持续响铃，直到拔掉插头或停用';

  @override
  String get lowBatteryAlertDesc => '放电时当电量低于目标值时报警';

  @override
  String get lowTarget => '低电量目标';

  @override
  String get allowBackgroundActivity => '允许后台活动';

  @override
  String get allowBackgroundActivityDesc => '打开电池设置：设为无限制 / 允许';

  @override
  String get autostartStartup => '自启动设置';

  @override
  String get autostartStartupDesc => '打开厂商自启页面以允许开机启动';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get notificationSettingsDesc => '确保允许发出声音的警报';

  @override
  String get stopAlarmNow => '立即停止警报';

  @override
  String get testAlarmNow => '立即测试警报';

  @override
  String get plugInChargerFirst => '⚠️ 开启卫士模式前请先插上充电器！';

  @override
  String get guardianArmedSnack => '🛡️ 卫士模式已设防！拔掉充电器将响起警报。';

  @override
  String get guardianDisarmedSnack => '卫士模式已撤防。';

  @override
  String targetReached(int pct) {
    return '已达到目标 $pct%！';
  }

  @override
  String targetLabel(int pct) {
    return '目标：$pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '约 $mins 分钟至 $pct%';
  }

  @override
  String get aboutDesc => '当电池达到所选百分比以及电量不足时提醒您。';

  @override
  String get keyFeatures => '主要功能：';

  @override
  String get readPrivacyPolicy => '阅读隐私政策';

  @override
  String get contributeOnGitHub => '在GitHub上贡献';

  @override
  String get couldNotOpenBrowser => '无法在浏览器中打开';

  @override
  String get linkCopied => '链接已复制';

  @override
  String get openInUpiApp => '在UPI应用中打开';

  @override
  String get couldNotOpenUpi => '无法打开UPI应用。请尝试扫描二维码或复制下方信息。';

  @override
  String get upiIdCopied => 'UPI ID已复制';

  @override
  String get upiIntentCopied => 'UPI Intent已复制';

  @override
  String get privacyAssurance => '我们不收集任何个人数据。该应用在您的设备上本地运行。';

  @override
  String get openTooltip => '打开';

  @override
  String get copyTooltip => '复制';

  @override
  String get scanToContribute => '扫码支持';

  @override
  String get scanUsingUpi => '使用任何UPI应用或相机扫描';

  @override
  String get voltAwake => '⚡ 伏特已唤醒！电池卫士已就绪！';

  @override
  String get voltCleanJuice => '⚡ 正在汲取纯净电量！电池状态极佳！';

  @override
  String get voltFastFlow => '🚀 检测到快速充电，很快就充满啦！';

  @override
  String get voltHealthTip => '💡 充电保持在85%以下能有效延长电池寿命！';

  @override
  String get voltPhoneCovered => '🛡️ 防盗卫士已布防！请放心，我守着你的手机！';

  @override
  String get voltUnplugWarning => '🚨 警告：任何未经授权的拔出都会触发警报巨响！';

  @override
  String get voltAllHealthy => '✨ 电池电芯、电压与温度均100%健康！';

  @override
  String get voltGreetingCompanion => '🤖 嗨！我是伏特，你的专属电池卫士伴侣！';

  @override
  String get voltStandingBy => '💚 时刻待命，守护你的设备硬件！';

  @override
  String get meetVolt => '认识伏特';

  @override
  String get meetVoltDesc => '你的智能电池伴侣。伏特时刻守护设备并让你随时掌握状态。';

  @override
  String get tapVoltToSayHi => '👆 点击伏特打个招呼吧！';
}
