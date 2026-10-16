// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'स्मार्ट चार्जिंग और बैटरी रक्षक';

  @override
  String get batteryLevel => 'बैटरी स्तर';

  @override
  String get batteryCharging => 'चार्ज हो रहा है';

  @override
  String get batteryDischarging => 'डिस्चार्ज हो रहा है';

  @override
  String get batteryFull => 'फुल चार्ज';

  @override
  String get batteryNotCharging => 'चार्ज नहीं हो रहा';

  @override
  String get batteryUnknown => 'अज्ञात';

  @override
  String get hyperCharging => 'सुपर फास्ट चार्जिंग';

  @override
  String get batteryFullCaps => 'बैटरी फुल';

  @override
  String get dischargingCaps => 'डिस्चार्ज हो रहा है';

  @override
  String get targetAlertLimit => 'टारगेट चार्ज सीमा';

  @override
  String get targetAlertSubtitle => 'इस प्रतिशत पर पहुंचने पर अलार्म बजेगा';

  @override
  String get chargingAlarm => 'चार्जिंग अलार्म';

  @override
  String get chargingAlarmSubtitle => 'टारगेट पूरा होने पर अलार्म बजाएं';

  @override
  String get continuousAlarm => 'लगातार अलार्म';

  @override
  String get continuousAlarmSubtitle => 'बंद करने तक बजता रहेगा';

  @override
  String get lowBatteryAlert => 'कम बैटरी चेतावनी';

  @override
  String get lowBatteryAlertSubtitle => 'बैटरी कम होने पर अलार्म बजाएं';

  @override
  String get lowBatteryWarning => 'लो बैटरी चेतावनी';

  @override
  String get guardianTitle => 'एंटी-थेफ्ट गार्डियन';

  @override
  String get guardianSubtitle => 'चार्जर निकालने पर तेज सायरन बजाएं';

  @override
  String get guardianArmed => 'सुरक्षा सक्रिय';

  @override
  String get guardianDisarmed => 'सुरक्षा निष्क्रिय';

  @override
  String get guardianArmedStatus => 'सक्रिय और सुरक्षित';

  @override
  String get guardianDisarmedStatus => 'निष्क्रिय / स्टैंडबाय';

  @override
  String get armGuardian => 'गार्डियन चालू करें';

  @override
  String get disarmGuardian => 'गार्डियन बंद करें';

  @override
  String get guardianDescription =>
      'सक्रिय होने पर, चार्जर निकालने पर 4-अंकीय पिन दर्ज करने तक तेज सायरन बजेगा।';

  @override
  String get guardianDisarmPrompt =>
      'गार्डियन मोड बंद करने के लिए अपना 4-अंकीय पिन दर्ज करें।';

  @override
  String get setPinTitle => 'सुरक्षा पिन सेट करें';

  @override
  String get setPinPrompt => 'एंटी-थेफ्ट सुरक्षा के लिए 4 अंकों का पिन बनाएं।';

  @override
  String get confirmPin => 'पिन की पुष्टि करें';

  @override
  String get enterPin => '4 अंकों का पिन दर्ज करें';

  @override
  String get wrongPin => 'गलत पिन। पुनः प्रयास करें।';

  @override
  String get pinsDoNotMatch => 'पिन मेल नहीं खाते';

  @override
  String get savePin => 'पिन सहेजें';

  @override
  String get theftAlarmActive => 'चोरी चेतावनी अलार्म सक्रिय!';

  @override
  String get alarmRinging => 'अलार्म बज रहा है!';

  @override
  String get theftAlarmSubtitle => 'चार्जर निकाल दिया गया! पिन आवश्यक है।';

  @override
  String get targetReachedSubtitle => 'टारगेट पूरा हुआ या अलर्ट सक्रिय है';

  @override
  String get stop => 'रोकें';

  @override
  String get disarm => 'बंद करें';

  @override
  String get temperature => 'तापमान';

  @override
  String get voltage => 'वोल्टेज';

  @override
  String get health => 'हेल्थ';

  @override
  String get healthGood => 'अच्छी';

  @override
  String get plugged => 'प्लग इन';

  @override
  String get pluggedAc => 'एसी चार्जर';

  @override
  String get pluggedUsb => 'यूएसबी पोर्ट';

  @override
  String get pluggedWireless => 'वायरलेस';

  @override
  String get pluggedNone => 'अनप्लग';

  @override
  String get technology => 'तकनीक';

  @override
  String get theme => 'थीम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get language => 'भाषा';

  @override
  String get languageSelect => 'भाषा चुनें';

  @override
  String get chargeHistory => 'चार्जिंग इतिहास';

  @override
  String get noHistory => 'कोई इतिहास नहीं है';

  @override
  String get clearHistory => 'इतिहास साफ़ करें';

  @override
  String get about => 'ऐप के बारे में';

  @override
  String get contribute => 'समर्थन करें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get faq => 'सामान्य प्रश्न';

  @override
  String get shareApp => 'ऐप शेयर करें';

  @override
  String get close => 'बंद करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get voltEnergized => '✨ सभी प्रणालियाँ तैयार हैं!';

  @override
  String get voltCharging => '⚡ ऊर्जा भर रही है! तेज और सुरक्षित प्रवाह!';

  @override
  String get voltTargetReached =>
      '🎉 टारगेट पूरा हुआ! बैटरी बचाने के लिए चार्जर निकालें!';

  @override
  String get voltLowBattery => '🪫 बैटरी खत्म हो रही है... कृपया चार्ज करें!';

  @override
  String get voltOverheating => '🔥 बहुत गर्म हो रहा हूं! कृपया ठंडा होने दें!';

  @override
  String get voltGuardianArmed =>
      '🛡️ सुरक्षा सक्रिय। चार्जर निकालने पर सायरन बजेगा!';

  @override
  String get voltTheftAlarm => '🚨 चोरी की चेतावनी! अलार्म बंद करें!';

  @override
  String get quickFaqTitle => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get faqWhyNoAlarm => 'अलार्म क्यों नहीं बजा?';

  @override
  String get faqWhyNoAlarmDesc =>
      'सुनिश्चित करें कि बैकग्राउंड गतिविधि और ऑटोस्टार्ट सक्षम हैं।';

  @override
  String get faqBackgroundActivity => 'बैकग्राउंड गतिविधि';

  @override
  String get faqAutostart => 'ऑटोस्टार्ट';

  @override
  String get faqNotifications => 'सूचनाएं';

  @override
  String get faqOemSettings => 'ऑटोस्टार्ट कैसे सक्षम करें?';

  @override
  String get faqOemSettingsDesc =>
      'विभिन्न ब्रांड (Xiaomi/OPPO/Vivo) इसे OEM सेटिंग्स में रखते हैं।';

  @override
  String get replaySplashScreen => 'स्प्लैश स्क्रीन दोबारा चलाएं';

  @override
  String get introWalkthrough => 'परिचय और मार्गदर्शिका';

  @override
  String get armedCaps => 'सक्रिय';

  @override
  String get idleCaps => 'निष्क्रिय';

  @override
  String get guardianSirenWarning =>
      'अनप्लग होने पर सायरन बजेगा और स्क्रीन लॉक होगी';

  @override
  String get guardianUnplugWarning => 'फ़ोन अनप्लग होने पर अलार्म बजाएं';

  @override
  String get protectedWithPin => '🔒 4-अंकीय पिन द्वारा सुरक्षित';

  @override
  String get changePin => 'पिन बदलें';

  @override
  String get changeSecurityPin => 'सुरक्षा पिन बदलें';

  @override
  String get pinUpdatedSuccess => 'सुरक्षा पिन सफलतापूर्वक अपडेट किया गया!';

  @override
  String get runningWarm => 'गर्म हो रहा है';

  @override
  String get nominalTemp => 'सामान्य तापमान';

  @override
  String get operatingWell => 'अच्छी स्थिति';

  @override
  String get powerSource => 'पावर स्रोत';

  @override
  String get activeInput => 'सक्रिय इनपुट';

  @override
  String get disconnected => 'डिस्कनेक्टेड';

  @override
  String get alertMeWhenReaches => 'बैटरी इस स्तर पर पहुंचने पर अलर्ट करें:';

  @override
  String get enableAlarmSound => 'अलार्म ध्वनि सक्षम करें';

  @override
  String get continuousAlarmDesc => 'अनप्लग या बंद करने तक अलार्म बजता रहेगा';

  @override
  String get lowBatteryAlertDesc =>
      'डिस्चार्ज होते समय लक्ष्य से कम होने पर चेतावनी दें';

  @override
  String get lowTarget => 'कम स्तर लक्ष्य';

  @override
  String get allowBackgroundActivity => 'पृष्ठभूमि गतिविधि की अनुमति दें';

  @override
  String get allowBackgroundActivityDesc =>
      'ऐप बैटरी सेटिंग खोलें: अप्रतिबंधित / अनुमति दें पर सेट करें';

  @override
  String get autostartStartup => 'ऑटोस्टार्ट / स्टार्टअप';

  @override
  String get autostartStartupDesc =>
      'बूट पर स्टार्ट होने के लिए OEM ऑटोस्टार्ट पेज खोलें';

  @override
  String get notificationSettings => 'सूचना सेटिंग्स';

  @override
  String get notificationSettingsDesc =>
      'सुनिश्चित करें कि ध्वनि के साथ अलर्ट की अनुमति है';

  @override
  String get stopAlarmNow => 'अलार्म अभी बंद करें';

  @override
  String get testAlarmNow => 'अलार्म का परीक्षण करें';

  @override
  String get plugInChargerFirst =>
      '⚠️ गार्जियन मोड सक्रिय करने से पहले कृपया चार्जर लगाएं!';

  @override
  String get guardianArmedSnack =>
      '🛡️ गार्जियन मोड सक्रिय! अनप्लग होने पर अलार्म बजेगा।';

  @override
  String get guardianDisarmedSnack => 'गार्जियन मोड निष्क्रिय किया गया।';

  @override
  String targetReached(int pct) {
    return 'लक्ष्य $pct% प्राप्त हुआ!';
  }

  @override
  String targetLabel(int pct) {
    return 'लक्ष्य: $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '$pct% तक ~$mins मिनट';
  }

  @override
  String get aboutDesc =>
      'बैटरी चुने गए प्रतिशत तक पहुंचने और कम होने पर अलर्ट करता है।';

  @override
  String get keyFeatures => 'मुख्य विशेषताएं:';

  @override
  String get readPrivacyPolicy => 'गोपनीयता नीति पढ़ें';

  @override
  String get contributeOnGitHub => 'GitHub पर योगदान करें';

  @override
  String get couldNotOpenBrowser => 'ब्राउज़र में नहीं खोला जा सका';

  @override
  String get linkCopied => 'लिंक कॉपी किया गया';

  @override
  String get openInUpiApp => 'UPI ऐप में खोलें';

  @override
  String get couldNotOpenUpi =>
      'UPI ऐप नहीं खोला जा सका। क्यूआर स्कैन करें या नीचे विवरण कॉपी करें।';

  @override
  String get upiIdCopied => 'UPI आईडी कॉपी की गई';

  @override
  String get upiIntentCopied => 'UPI इंटेंट कॉपी किया गया';

  @override
  String get privacyAssurance =>
      'हम व्यक्तिगत डेटा एकत्र नहीं करते हैं। ऐप आपके डिवाइस पर स्थानीय रूप से चलता है।';

  @override
  String get openTooltip => 'खोलें';

  @override
  String get copyTooltip => 'कॉपी करें';

  @override
  String get scanToContribute => 'योगदान के लिए स्कैन करें';

  @override
  String get scanUsingUpi =>
      'किसी भी UPI ऐप या कैमरा स्कैनर का उपयोग करके स्कैन करें';

  @override
  String get voltAwake => '⚡ वोल्ट जाग गया! बैटरी रक्षक तैयार है!';

  @override
  String get voltCleanJuice =>
      '⚡ ऊर्जा प्रवाह बहुत अच्छा है! बैटरी स्वस्थ महसूस कर रही है!';

  @override
  String get voltFastFlow =>
      '🚀 फास्ट चार्जिंग चालू है। जल्द ही फुल चार्ज होंगे!';

  @override
  String get voltHealthTip =>
      '💡 85% से कम चार्ज रखने से बैटरी की उम्र बढ़ती है!';

  @override
  String get voltPhoneCovered =>
      '🛡️ गार्डियन सक्रिय है! मैं आपके फोन की सुरक्षा कर रहा हूं!';

  @override
  String get voltUnplugWarning =>
      '🚨 चेतावनी: चार्जर हटाने पर तेज सायरन बजेगा!';

  @override
  String get voltAllHealthy =>
      '✨ बैटरी सेल्स, वोल्टेज और तापमान पूरी तरह सामान्य हैं!';

  @override
  String get voltGreetingCompanion =>
      '🤖 नमस्ते! मैं वोल्ट हूं, आपका बैटरी सुरक्षा साथी!';

  @override
  String get voltStandingBy => '💚 आपके फोन की सुरक्षा के लिए हमेशा तैयार!';

  @override
  String get meetVolt => 'मिलिए वोल्ट से';

  @override
  String get meetVoltDesc =>
      'आपका स्मार्ट बैटरी साथी। वोल्ट आपके डिवाइस की निगरानी करता है।';

  @override
  String get tapVoltToSayHi => '👆 नमस्ते कहने के लिए वोल्ट पर टैप करें!';
}
