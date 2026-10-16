// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'স্মার্ট চার্জিং এবং ব্যাটারি সেন্টিনেল';

  @override
  String get batteryLevel => 'ব্যাটারির মাত্রা';

  @override
  String get batteryCharging => 'চার্জ হচ্ছে';

  @override
  String get batteryDischarging => 'চার্জ কমছে';

  @override
  String get batteryFull => 'সম্পূর্ণ চার্জ';

  @override
  String get batteryNotCharging => 'চার্জ হচ্ছে না';

  @override
  String get batteryUnknown => 'অজানা';

  @override
  String get hyperCharging => 'সুপার ফাস্ট চার্জিং';

  @override
  String get batteryFullCaps => 'ব্যাটারি ফুল';

  @override
  String get dischargingCaps => 'চার্জ কমছে';

  @override
  String get targetAlertLimit => 'টার্গেট চার্জ সীমা';

  @override
  String get targetAlertSubtitle => 'এই শতাংশে পৌঁছালে অ্যালার্ম বাজবে';

  @override
  String get chargingAlarm => 'চার্জিং অ্যালার্ম';

  @override
  String get chargingAlarmSubtitle => 'টার্গেট পূরণ হলে অ্যালার্ম বাজান';

  @override
  String get continuousAlarm => 'একটানা অ্যালার্ম';

  @override
  String get continuousAlarmSubtitle => 'বন্ধ না করা পর্যন্ত একটানা বাজবে';

  @override
  String get lowBatteryAlert => 'লো ব্যাটারি সতর্কতা';

  @override
  String get lowBatteryAlertSubtitle =>
      'ব্যাটারি শেষ হয়ে আসলে অ্যালার্ম বাজবে';

  @override
  String get lowBatteryWarning => 'কম ব্যাটারি সতর্কতা';

  @override
  String get guardianTitle => 'অ্যান্টি-থেফট গার্ডিয়ান';

  @override
  String get guardianSubtitle => 'চার্জার খুলে নিলে বিকট সাইরেন বাজবে';

  @override
  String get guardianArmed => 'গার্ডিয়ান চালু';

  @override
  String get guardianDisarmed => 'গার্ডিয়ান বন্ধ';

  @override
  String get guardianArmedStatus => 'সক্রিয় এবং সুরক্ষিত';

  @override
  String get guardianDisarmedStatus => 'নিষ্ক্রিয় / প্রস্তুত';

  @override
  String get armGuardian => 'গার্ডিয়ান মোড চালু করুন';

  @override
  String get disarmGuardian => 'গার্ডিয়ান মোড বন্ধ করুন';

  @override
  String get guardianDescription =>
      'চালু থাকলে, চার্জার খুলে নিলে ৪-সংখ্যার পিন না দেওয়া পর্যন্ত বিকট সাইরেন বাজবে।';

  @override
  String get guardianDisarmPrompt =>
      'গার্ডিয়ান মোড বন্ধ করতে ৪-সংখ্যার পিন দিন।';

  @override
  String get setPinTitle => 'নিরাপত্তা পিন সেট করুন';

  @override
  String get setPinPrompt =>
      'অ্যান্টি-থেফট সুরক্ষার জন্য ৪-সংখ্যার পিন তৈরি করুন।';

  @override
  String get confirmPin => 'পিন নিশ্চিত করুন';

  @override
  String get enterPin => '৪-সংখ্যার পিন দিন';

  @override
  String get wrongPin => 'ভুল পিন। আবার চেষ্টা করুন।';

  @override
  String get pinsDoNotMatch => 'পিন মিলছে না';

  @override
  String get savePin => 'পিন সংরক্ষণ করুন';

  @override
  String get theftAlarmActive => 'চুরির অ্যালার্ম সক্রিয়!';

  @override
  String get alarmRinging => 'অ্যালার্ম বাজছে!';

  @override
  String get theftAlarmSubtitle => 'চার্জার খুলে নেওয়া হয়েছে! পিন প্রয়োজন।';

  @override
  String get targetReachedSubtitle => 'টার্গেট পূর্ণ বা অ্যালার্ট সক্রিয়';

  @override
  String get stop => 'থামুন';

  @override
  String get disarm => 'বন্ধ করুন';

  @override
  String get temperature => 'তাপমাত্রা';

  @override
  String get voltage => 'ভোল্টেজ';

  @override
  String get health => 'স্বাস্থ্য';

  @override
  String get healthGood => 'ভালো';

  @override
  String get plugged => 'সংযুক্ত';

  @override
  String get pluggedAc => 'এসি চার্জার';

  @override
  String get pluggedUsb => 'ইউএসবি পোর্ট';

  @override
  String get pluggedWireless => 'ওয়্যারলেস';

  @override
  String get pluggedNone => 'সংযোগ বিচ্ছিন্ন';

  @override
  String get technology => 'প্রযুক্তি';

  @override
  String get theme => 'থিম';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get themeSystem => 'সিস্টেম ডিফল্ট';

  @override
  String get language => 'ভাষা';

  @override
  String get languageSelect => 'ভাষা নির্বাচন করুন';

  @override
  String get chargeHistory => 'চার্জিং ইতিহাস';

  @override
  String get noHistory => 'কোনো ইতিহাস নেই';

  @override
  String get clearHistory => 'ইতিহাস মুছুন';

  @override
  String get about => 'অ্যাপ সম্পর্কে';

  @override
  String get contribute => 'সহায়তা করুন';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get faq => 'সাধারণ প্রশ্নোত্তর';

  @override
  String get shareApp => 'শেয়ার করুন';

  @override
  String get close => 'বন্ধ';

  @override
  String get cancel => 'বাতিল';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get voltEnergized => '✨ সমস্ত সিস্টেম সক্রিয়!';

  @override
  String get voltCharging => '⚡ শক্তি সঞ্চয় হচ্ছে! দ্রুত এবং মসৃণ চার্জ!';

  @override
  String get voltTargetReached =>
      '🎉 টার্গেট পূরণ হয়েছে! ব্যাটারি বাঁচাতে চার্জার খুলুন!';

  @override
  String get voltLowBattery => '🪫 ব্যাটারি ফুরিয়ে আসছে... চার্জে দিন!';

  @override
  String get voltOverheating =>
      '🔥 ব্যাটারি গরম হচ্ছে! কিছুক্ষণ ঠান্ডা হতে দিন!';

  @override
  String get voltGuardianArmed =>
      '🛡️ সুরক্ষা চালু। চার্জার খুললে সাইরেন বাজবে!';

  @override
  String get voltTheftAlarm => '🚨 চুরির অ্যালার্ট! অ্যালার্ম বন্ধ করুন!';

  @override
  String get quickFaqTitle => 'সাধারণ জিজ্ঞাসা';

  @override
  String get faqWhyNoAlarm => 'অ্যালার্ম কেন বাজল না?';

  @override
  String get faqWhyNoAlarmDesc =>
      'ব্যাকগ্রাউন্ড অ্যাক্টিভিটি এবং অটোস্টার্ট অনুমোদিত কিনা তা নিশ্চিত করুন।';

  @override
  String get faqBackgroundActivity => 'ব্যাকগ্রাউন্ড অ্যাক্টিভিটি';

  @override
  String get faqAutostart => 'অটোস্টার্ট';

  @override
  String get faqNotifications => 'নোটিফিকেশন';

  @override
  String get faqOemSettings => 'অটোস্টার্ট কীভাবে চালু করবেন?';

  @override
  String get faqOemSettingsDesc =>
      'বিভিন্ন ব্র্যান্ডে (Xiaomi/OPPO/Vivo) এটি ফোন সেটিংসে থাকে।';

  @override
  String get replaySplashScreen => 'স্প্ল্যাশ স্ক্রিন পুনরায় চালান';

  @override
  String get introWalkthrough => 'পরিচিতি এবং নির্দেশিকা';

  @override
  String get armedCaps => 'সক্রিয়';

  @override
  String get idleCaps => 'নিষ্ক্রিয়';

  @override
  String get guardianSirenWarning =>
      'আনপ্লাগ করলে সাইরেন বাজবে এবং স্ক্রিন লক হবে';

  @override
  String get guardianUnplugWarning => 'কেউ ফোন আনপ্লাগ করলে অ্যালার্ম বাজবে';

  @override
  String get protectedWithPin => '🔒 ৪-সংখ্যার পিন দ্বারা সুরক্ষিত';

  @override
  String get changePin => 'পিন পরিবর্তন করুন';

  @override
  String get changeSecurityPin => 'নিরাপত্তা পিন পরিবর্তন করুন';

  @override
  String get pinUpdatedSuccess => 'নিরাপত্তা পিন সফলভাবে আপডেট করা হয়েছে!';

  @override
  String get runningWarm => 'গরম হচ্ছে';

  @override
  String get nominalTemp => 'স্বাভাবিক তাপমাত্রা';

  @override
  String get operatingWell => 'ভালো অবস্থা';

  @override
  String get powerSource => 'পাওয়ার উৎস';

  @override
  String get activeInput => 'সক্রিয় ইনপুট';

  @override
  String get disconnected => 'বিচ্ছিন্ন';

  @override
  String get alertMeWhenReaches => 'ব্যাটারি এই স্তরে পৌঁছালে সতর্ক করুন:';

  @override
  String get enableAlarmSound => 'অ্যালার্ম সাউন্ড চালু করুন';

  @override
  String get continuousAlarmDesc =>
      'আনপ্লাগ বা বন্ধ না করা পর্যন্ত অ্যালার্ম বাজবে';

  @override
  String get lowBatteryAlertDesc =>
      'ডিসচার্জের সময় লক্ষ্যমাত্রার নিচে নামলে সতর্ক করুন';

  @override
  String get lowTarget => 'নিম্ন লক্ষ্যমাত্রা';

  @override
  String get allowBackgroundActivity => 'ব্যাকগ্রাউন্ড কার্যকলাপের অনুমতি দিন';

  @override
  String get allowBackgroundActivityDesc =>
      'অ্যাপ ব্যাটারি সেটিংস খুলুন: অনিয়ন্ত্রিত / অনুমতি দিন সেট করুন';

  @override
  String get autostartStartup => 'অটোস্টার্ট / স্টার্টআপ';

  @override
  String get autostartStartupDesc =>
      'বুট করার সময় চালু হতে OEM অটোস্টার্ট পেজ খুলুন';

  @override
  String get notificationSettings => 'বিজ্ঞপ্তি সেটিংস';

  @override
  String get notificationSettingsDesc =>
      'নিশ্চিত করুন যে শব্দ সহ সতর্কতা অনুমোদিত';

  @override
  String get stopAlarmNow => 'এখনই অ্যালার্ম বন্ধ করুন';

  @override
  String get testAlarmNow => 'এখনই অ্যালার্ম পরীক্ষা করুন';

  @override
  String get plugInChargerFirst =>
      '⚠️ গার্ডিয়ান মোড চালু করার আগে অনুগ্রহ করে চার্জার প্লাগ ইন করুন!';

  @override
  String get guardianArmedSnack =>
      '🛡️ গার্ডিয়ান মোড সক্রিয়! আনপ্লাগ করলে অ্যালার্ম বাজবে।';

  @override
  String get guardianDisarmedSnack => 'গার্ডিয়ান মোড নিষ্ক্রিয় করা হয়েছে।';

  @override
  String targetReached(int pct) {
    return 'লক্ষ্যমাত্রা $pct% অর্জিত!';
  }

  @override
  String targetLabel(int pct) {
    return 'লক্ষ্যমাত্রা: $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '$pct% পর্যন্ত ~$mins মিনিট';
  }

  @override
  String get aboutDesc =>
      'ব্যাটারি নির্বাচিত শতাংশে পৌঁছালে এবং চার্জ কম হলে সতর্ক করে।';

  @override
  String get keyFeatures => 'মূল বৈশিষ্ট্যসমূহ:';

  @override
  String get readPrivacyPolicy => 'গোপনীয়তা নীতি পড়ুন';

  @override
  String get contributeOnGitHub => 'GitHub-এ অবদান রাখুন';

  @override
  String get couldNotOpenBrowser => 'ব্রাউজারে খোলা যায়নি';

  @override
  String get linkCopied => 'লিঙ্ক কপি হয়েছে';

  @override
  String get openInUpiApp => 'UPI অ্যাপে খুলুন';

  @override
  String get couldNotOpenUpi =>
      'UPI অ্যাপ খোলা যায়নি। কিউআর স্ক্যান করুন বা নিচে কপি করুন।';

  @override
  String get upiIdCopied => 'UPI আইডি কপি হয়েছে';

  @override
  String get upiIntentCopied => 'UPI ইনটেন্ট কপি হয়েছে';

  @override
  String get privacyAssurance =>
      'আমরা কোনো ব্যক্তিগত তথ্য সংগ্রহ করি না। অ্যাপটি আপনার ডিভাইসে স্থানীয়ভাবে চলে।';

  @override
  String get openTooltip => 'খুলুন';

  @override
  String get copyTooltip => 'কপি করুন';

  @override
  String get scanToContribute => 'অবদান রাখতে স্ক্যান করুন';

  @override
  String get scanUsingUpi => 'যেকোনো UPI অ্যাপ বা ক্যামেরা দিয়ে স্ক্যান করুন';

  @override
  String get voltAwake => '⚡ ভোল্ট জেগে উঠেছে! ব্যাটারি অভিভাবক প্রস্তুত!';

  @override
  String get voltCleanJuice =>
      '⚡ দ্রুত চার্জ হচ্ছে! ব্যাটারি ভালো অবস্থায় আছে!';

  @override
  String get voltFastFlow =>
      '🚀 দ্রুত চার্জিং হচ্ছে। শীঘ্রই সম্পূর্ণ চার্জ হবে!';

  @override
  String get voltHealthTip =>
      '💡 ৮৫% এর নিচে চার্জ রাখলে ব্যাটারির আয়ু বাড়ে!';

  @override
  String get voltPhoneCovered =>
      '🛡️ গার্ডিয়ান সক্রিয়! আমি আপনার ফোন পাহারা দিচ্ছি!';

  @override
  String get voltUnplugWarning =>
      '🚨 সতর্কতা: অনুমতি ছাড়া চার্জার খুললে সাইরেন বাজবে!';

  @override
  String get voltAllHealthy =>
      '✨ ব্যাটারি সেল, ভোল্টেজ এবং তাপমাত্রা সম্পূর্ণ নিরাপদ!';

  @override
  String get voltGreetingCompanion =>
      '🤖 হ্যালো! আমি ভোল্ট, আপনার ব্যাটারি অভিভাবক!';

  @override
  String get voltStandingBy => '💚 আপনার ডিভাইসের যত্নে সর্বদা প্রস্তুত!';

  @override
  String get meetVolt => 'ভোল্টের সাথে পরিচিত হন';

  @override
  String get meetVoltDesc =>
      'আপনার স্মার্ট ব্যাটারি সহযোগী। ভোল্ট আপনার ফোনের খেয়াল রাখে।';

  @override
  String get tapVoltToSayHi => '👆 হাই বলতে ভোল্টের ওপর ট্যাপ করুন!';
}
