// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'شحن ذكي وحارس للبطارية';

  @override
  String get batteryLevel => 'مستوى البطارية';

  @override
  String get batteryCharging => 'جارٍ الشحن';

  @override
  String get batteryDischarging => 'تفريغ الشحن';

  @override
  String get batteryFull => 'ممتلئة';

  @override
  String get batteryNotCharging => 'لا يشحن';

  @override
  String get batteryUnknown => 'غير معروف';

  @override
  String get hyperCharging => 'شحن فائق السرعة';

  @override
  String get batteryFullCaps => 'البطارية ممتلئة';

  @override
  String get dischargingCaps => 'تفريغ الشحن';

  @override
  String get targetAlertLimit => 'الحد المستهدف للتنبيه';

  @override
  String get targetAlertSubtitle =>
      'يصدر المنبه عند وصول البطارية إلى هذه النسبة';

  @override
  String get chargingAlarm => 'منبه الشحن';

  @override
  String get chargingAlarmSubtitle =>
      'تشغيل المنبه عند الوصول إلى النسبة المحددة';

  @override
  String get continuousAlarm => 'منبه مستمر';

  @override
  String get continuousAlarmSubtitle =>
      'الاستمرار في الرنين حتى الإيقاف يدويًا';

  @override
  String get lowBatteryAlert => 'تنبيه انخفاض البطارية';

  @override
  String get lowBatteryAlertSubtitle => 'تشغيل المنبه عندما تنفد البطارية';

  @override
  String get lowBatteryWarning => 'تحذير انخفاض البطارية';

  @override
  String get guardianTitle => 'حارس ضد السرقة';

  @override
  String get guardianSubtitle => 'إطلاق صفارة إنذار إذا تم فصل الشاحن';

  @override
  String get guardianArmed => 'الحارس مفعّل';

  @override
  String get guardianDisarmed => 'الحارس معطّل';

  @override
  String get guardianArmedStatus => 'مفعّل ويحمي جهازك';

  @override
  String get guardianDisarmedStatus => 'معطّل / في وضع الاستعداد';

  @override
  String get armGuardian => 'تفعيل وضع الحارس';

  @override
  String get disarmGuardian => 'تعطيل وضع الحارس';

  @override
  String get guardianDescription =>
      'عند التفعيل، إذا فصل أي شخص الشاحن، ستنطلق صفارة إنذار حتى إدخال رمز PIN المكون من 4 أرقام.';

  @override
  String get guardianDisarmPrompt => 'أدخل رمز PIN لإلغاء تنشيط وضع الحارس.';

  @override
  String get setPinTitle => 'تعيين رمز PIN للأمان';

  @override
  String get setPinPrompt => 'أنشئ رمز PIN مكون من 4 أرقام لتأمين الحارس.';

  @override
  String get confirmPin => 'تأكيد رمز PIN';

  @override
  String get enterPin => 'أدخل رمز PIN المكون من 4 أرقام';

  @override
  String get wrongPin => 'رمز PIN غير صحيح. حاول مجددًا.';

  @override
  String get pinsDoNotMatch => 'رمزا PIN غير متطابقين';

  @override
  String get savePin => 'حفظ PIN';

  @override
  String get theftAlarmActive => 'إنذار السرقة نشط!';

  @override
  String get alarmRinging => 'المنبه يرن!';

  @override
  String get theftAlarmSubtitle => 'تم فصل الشاحن! يلزم إدخال رمز PIN.';

  @override
  String get targetReachedSubtitle => 'تم الوصول إلى النسبة أو التنبيه نشط';

  @override
  String get stop => 'إيقاف';

  @override
  String get disarm => 'تعطيل';

  @override
  String get temperature => 'درجة الحرارة';

  @override
  String get voltage => 'الجهد الكهربائي';

  @override
  String get health => 'حالة البطارية';

  @override
  String get healthGood => 'جيدة';

  @override
  String get plugged => 'متصل';

  @override
  String get pluggedAc => 'شاحن تيار متردد';

  @override
  String get pluggedUsb => 'منفذ USB';

  @override
  String get pluggedWireless => 'لاسلكي';

  @override
  String get pluggedNone => 'غير متصل';

  @override
  String get technology => 'التقنية';

  @override
  String get theme => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'افتراضي النظام';

  @override
  String get language => 'اللغة';

  @override
  String get languageSelect => 'اختر اللغة';

  @override
  String get chargeHistory => 'سجل الشحن';

  @override
  String get noHistory => 'لا يوجد سجل بعد';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String get about => 'حول التطبيق';

  @override
  String get contribute => 'الدعم والمساهمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get shareApp => 'مشاركة التطبيق';

  @override
  String get close => 'إغلاق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'موافق';

  @override
  String get voltEnergized => '✨ جميع الأنظمة تعمل بكفاءة!';

  @override
  String get voltCharging => '⚡ امتصاص الطاقة! تدفق سريع ومستمر!';

  @override
  String get voltTargetReached =>
      '🎉 تم الوصول للهدف! افصل الشاحن للحفاظ على البطارية!';

  @override
  String get voltLowBattery => '🪫 طاقتي تنفد... الرجاء توصيل الشاحن!';

  @override
  String get voltOverheating => '🔥 حرارة الجهاز مرتفعة! يرجى تركه ليبرد!';

  @override
  String get voltGuardianArmed => '🛡️ الحارس نشط. فصل الشاحن سيطلق الإنذار!';

  @override
  String get voltTheftAlarm => '🚨 تنبيه سرقة! أوقف المنبه!';

  @override
  String get quickFaqTitle => 'الأسئلة الشائعة';

  @override
  String get faqWhyNoAlarm => 'لماذا لم يرن المنبه؟';

  @override
  String get faqWhyNoAlarmDesc =>
      'تأكد من السماح بالعمل في الخلفية وتفعيل بدء التشغيل التلقائي.';

  @override
  String get faqBackgroundActivity => 'النشاط في الخلفية';

  @override
  String get faqAutostart => 'التشغيل التلقائي';

  @override
  String get faqNotifications => 'الإشعارات';

  @override
  String get faqOemSettings => 'كيف أفعّل التشغيل التلقائي؟';

  @override
  String get faqOemSettingsDesc =>
      'تختلف حسب الشركة المصنعة (مثل Xiaomi/OPPO/Vivo).';

  @override
  String get replaySplashScreen => 'إعادة تشغيل شاشة البداية';

  @override
  String get introWalkthrough => 'المقدمة والدليل';

  @override
  String get armedCaps => 'مفعل';

  @override
  String get idleCaps => 'خامل';

  @override
  String get guardianSirenWarning =>
      'ستنطلق صفارة الإنذار ويتم قفل الشاشة عند فصل الشاحن';

  @override
  String get guardianUnplugWarning =>
      'تشغيل الإنذار إذا قام شخص ما بفصل الهاتف';

  @override
  String get protectedWithPin => '🔒 محمي برمز PIN المكون من 4 أرقام';

  @override
  String get changePin => 'تغيير رمز PIN';

  @override
  String get changeSecurityPin => 'تغيير رمز PIN للأمان';

  @override
  String get pinUpdatedSuccess => 'تم تحديث رمز PIN للأمان بنجاح!';

  @override
  String get runningWarm => 'ساخن';

  @override
  String get nominalTemp => 'درجة حرارة عادية';

  @override
  String get operatingWell => 'يعمل بشكل جيد';

  @override
  String get powerSource => 'مصدر الطاقة';

  @override
  String get activeInput => 'مدخل نشط';

  @override
  String get disconnected => 'مفصول';

  @override
  String get alertMeWhenReaches => 'تنبيهي عندما تصل البطارية إلى:';

  @override
  String get enableAlarmSound => 'تفعيل صوت المنبه';

  @override
  String get continuousAlarmDesc => 'سيستمر المنبه حتى تفصل الشاحن أو تعطه';

  @override
  String get lowBatteryAlertDesc =>
      'تنبيه عندما تنخفض البطارية عن الحد أثناء التفريغ';

  @override
  String get lowTarget => 'الحد الأدنى';

  @override
  String get allowBackgroundActivity => 'السماح بالنشاط في الخلفية';

  @override
  String get allowBackgroundActivityDesc =>
      'افتح إعدادات بطارية التطبيق: اختر بلا قيود / سماح';

  @override
  String get autostartStartup => 'التشغيل التلقائي';

  @override
  String get autostartStartupDesc =>
      'فتح إعدادات بدء التشغيل التلقائي الخاصة بالشركة المصنعة';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get notificationSettingsDesc => 'تأكد من السماح بالتنبيهات مع الصوت';

  @override
  String get stopAlarmNow => 'إيقاف المنبه الآن';

  @override
  String get testAlarmNow => 'اختبار المنبه الآن';

  @override
  String get plugInChargerFirst => '⚠️ يرجى توصيل الشاحن قبل تفعيل وضع الحارس!';

  @override
  String get guardianArmedSnack =>
      '🛡️ وضع الحارس مفعل! سينطلق الإنذار إذا تم فصل الشاحن.';

  @override
  String get guardianDisarmedSnack => 'تم إلغاء تفعيل وضع الحارس.';

  @override
  String targetReached(int pct) {
    return 'تم الوصول للهدف $pct%!';
  }

  @override
  String targetLabel(int pct) {
    return 'الهدف: $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '~$mins دقيقة حتى $pct%';
  }

  @override
  String get aboutDesc =>
      'ينبهك عندما تصل البطارية إلى النسبة المختارة وعند انخفاض الشحن.';

  @override
  String get keyFeatures => 'الميزات الرئيسية:';

  @override
  String get readPrivacyPolicy => 'قراءة سياسة الخصوصية';

  @override
  String get contributeOnGitHub => 'المساهمة على GitHub';

  @override
  String get couldNotOpenBrowser => 'تعذر الفتح في المتصفح';

  @override
  String get linkCopied => 'تم نسخ الرابط';

  @override
  String get openInUpiApp => 'الفتح في تطبيق UPI';

  @override
  String get couldNotOpenUpi =>
      'تعذر فتح تطبيق UPI. جرب مسح QR أو نسخ التفاصيل أدناه.';

  @override
  String get upiIdCopied => 'تم نسخ معرّف UPI';

  @override
  String get upiIntentCopied => 'تم نسخ رابط UPI';

  @override
  String get privacyAssurance =>
      'نحن لا نجمع أي بيانات شخصية. التطبيق يعمل محلياً على جهازك.';

  @override
  String get openTooltip => 'فتح';

  @override
  String get copyTooltip => 'نسخ';

  @override
  String get scanToContribute => 'امسح للمساهمة';

  @override
  String get scanUsingUpi => 'امسح باستخدام أي تطبيق UPI أو ماسح الكاميرا';

  @override
  String get voltAwake => '⚡ استيقظ فولت! حارس البطارية جاهز!';

  @override
  String get voltCleanJuice => '⚡ تدفق شحن ممتاز! خلايا البطارية بحالة رائعة!';

  @override
  String get voltFastFlow =>
      '🚀 شحن سريع قيد التشغيل. سنصل إلى الاكتمال قريباً!';

  @override
  String get voltHealthTip => '💡 إبقاء الشحن أقل من 85% يطيل عمر البطارية!';

  @override
  String get voltPhoneCovered => '🛡️ الحارس نشط! أنا أحمي هاتفك الآن!';

  @override
  String get voltUnplugWarning =>
      '🚨 تحذير: أي فصل غير مصرح به للشاحن يطلق صفارة الإنذار!';

  @override
  String get voltAllHealthy =>
      '✨ خلايا البطارية والجهد والحرارة كلها بحالة ممتازة!';

  @override
  String get voltGreetingCompanion =>
      '🤖 مرحباً! أنا فولت، حارس بطاريتك الشخصي!';

  @override
  String get voltStandingBy => '💚 مستعد دائماً وأراقب جهازك بعناية!';

  @override
  String get meetVolt => 'تعرّف على فولت';

  @override
  String get meetVoltDesc =>
      'رفيق البطارية الذكي. فولت يراقب جهازك ويبقيك على اطلاع دائم.';

  @override
  String get tapVoltToSayHi => '👆 اضغط على فولت لإلقاء التحية!';
}
