// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'Smart Charging & Battery Sentinel';

  @override
  String get batteryLevel => 'Battery Level';

  @override
  String get batteryCharging => 'Charging';

  @override
  String get batteryDischarging => 'Discharging';

  @override
  String get batteryFull => 'Full';

  @override
  String get batteryNotCharging => 'Not Charging';

  @override
  String get batteryUnknown => 'Unknown';

  @override
  String get hyperCharging => 'HYPER CHARGING';

  @override
  String get batteryFullCaps => 'BATTERY FULL';

  @override
  String get dischargingCaps => 'DISCHARGING';

  @override
  String get targetAlertLimit => 'Target Alert Limit';

  @override
  String get targetAlertSubtitle =>
      'Sounds alarm when battery reaches this percentage';

  @override
  String get chargingAlarm => 'Charging Alarm';

  @override
  String get chargingAlarmSubtitle =>
      'Sound alarm when target percentage is reached';

  @override
  String get continuousAlarm => 'Continuous Alarm';

  @override
  String get continuousAlarmSubtitle => 'Keep ringing until dismissed manually';

  @override
  String get lowBatteryAlert => 'Low Battery Alert';

  @override
  String get lowBatteryAlertSubtitle =>
      'Sound alarm when battery is running out';

  @override
  String get lowBatteryWarning => 'Low Battery Warning';

  @override
  String get guardianTitle => 'Guardian Anti-Theft';

  @override
  String get guardianSubtitle =>
      'Sounds continuous siren if charger is unplugged';

  @override
  String get guardianArmed => 'Guardian Armed';

  @override
  String get guardianDisarmed => 'Guardian Disarmed';

  @override
  String get guardianArmedStatus => 'ARMED & PROTECTING';

  @override
  String get guardianDisarmedStatus => 'DISARMED / STANDBY';

  @override
  String get armGuardian => 'Arm Guardian Mode';

  @override
  String get disarmGuardian => 'Disarm Guardian Mode';

  @override
  String get guardianDescription =>
      'While armed, if anyone unplugs your charger, a loud siren will blast until your 4-digit PIN is entered.';

  @override
  String get guardianDisarmPrompt =>
      'Enter your 4-digit PIN to disarm Anti-Theft Guardian Mode.';

  @override
  String get setPinTitle => 'Set Security PIN';

  @override
  String get setPinPrompt =>
      'Create a 4-digit PIN to secure Anti-Theft Guardian Mode.';

  @override
  String get confirmPin => 'Confirm Security PIN';

  @override
  String get enterPin => 'Enter 4-Digit Security PIN';

  @override
  String get wrongPin => 'Incorrect PIN. Try again.';

  @override
  String get pinsDoNotMatch => 'PINs do not match';

  @override
  String get savePin => 'Save PIN';

  @override
  String get theftAlarmActive => 'THEFT ALARM ACTIVE!';

  @override
  String get alarmRinging => 'Alarm Ringing!';

  @override
  String get theftAlarmSubtitle => 'Charger disconnected! PIN required.';

  @override
  String get targetReachedSubtitle => 'Target reached or alert active';

  @override
  String get stop => 'STOP';

  @override
  String get disarm => 'DISARM';

  @override
  String get temperature => 'Temperature';

  @override
  String get voltage => 'Voltage';

  @override
  String get health => 'Battery Health';

  @override
  String get healthGood => 'Good';

  @override
  String get plugged => 'Plugged';

  @override
  String get pluggedAc => 'AC Charger';

  @override
  String get pluggedUsb => 'USB Port';

  @override
  String get pluggedWireless => 'Wireless';

  @override
  String get pluggedNone => 'Unplugged';

  @override
  String get technology => 'Technology';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System Default';

  @override
  String get language => 'Language';

  @override
  String get languageSelect => 'Select Language';

  @override
  String get chargeHistory => 'Charge History';

  @override
  String get noHistory => 'No history yet';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get about => 'About';

  @override
  String get contribute => 'Contribute';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get faq => 'Quick FAQ';

  @override
  String get shareApp => 'Share App';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get voltEnergized => '✨ All systems operational!';

  @override
  String get voltCharging => '⚡ Absorbing energy! Flowing fast & smooth!';

  @override
  String get voltTargetReached =>
      '🎉 Target reached! Unplug now to save battery life!';

  @override
  String get voltLowBattery => '🪫 My energy is running out... feed me power!';

  @override
  String get voltOverheating => '🔥 I\'m running hot! Please give me some air!';

  @override
  String get voltGuardianArmed =>
      '🛡️ Guardian Armed. Unplugging triggers loud siren!';

  @override
  String get voltTheftAlarm => '🚨 INTRUSION OR ALERT! Stop the alarm!';

  @override
  String get quickFaqTitle => 'Quick FAQ';

  @override
  String get faqWhyNoAlarm => 'Why didn\'t the alarm ring?';

  @override
  String get faqWhyNoAlarmDesc =>
      'Ensure background activity is allowed, autostart is enabled, and notifications have sound. Use the shortcuts below to open settings.';

  @override
  String get faqBackgroundActivity => 'Background activity';

  @override
  String get faqAutostart => 'Autostart';

  @override
  String get faqNotifications => 'Notifications';

  @override
  String get faqOemSettings => 'How to allow autostart/startup?';

  @override
  String get faqOemSettingsDesc =>
      'Different brands place this in OEM settings (e.g., Xiaomi/OPPO/Vivo). Use the Autostart shortcut and enable startup for ChargeAlert.';

  @override
  String get replaySplashScreen => 'Replay Splash Screen';

  @override
  String get introWalkthrough => 'Intro & Walkthrough';

  @override
  String get armedCaps => 'ARMED';

  @override
  String get idleCaps => 'IDLE';

  @override
  String get guardianSirenWarning =>
      'Siren will blast & lock screen if unplugged';

  @override
  String get guardianUnplugWarning => 'Sound alarm if someone unplugs phone';

  @override
  String get protectedWithPin => '🔒 Protected with 4-digit PIN';

  @override
  String get changePin => 'Change PIN';

  @override
  String get changeSecurityPin => 'Change Security PIN';

  @override
  String get pinUpdatedSuccess => 'Security PIN updated successfully!';

  @override
  String get runningWarm => 'Running Warm';

  @override
  String get nominalTemp => 'Nominal Temp';

  @override
  String get operatingWell => 'Operating Well';

  @override
  String get powerSource => 'Power Source';

  @override
  String get activeInput => 'Active Input';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get alertMeWhenReaches => 'Alert me when battery reaches:';

  @override
  String get enableAlarmSound => 'Enable Alarm Sound';

  @override
  String get continuousAlarmDesc =>
      'Alarm will continue until you unplug or disable it';

  @override
  String get lowBatteryAlertDesc =>
      'Alert when battery goes below target while discharging';

  @override
  String get lowTarget => 'Low target';

  @override
  String get allowBackgroundActivity => 'Allow background activity';

  @override
  String get allowBackgroundActivityDesc =>
      'Open app battery settings: set to Unrestricted / Allow';

  @override
  String get autostartStartup => 'Autostart / Startup';

  @override
  String get autostartStartupDesc =>
      'Open OEM autostart page to allow startup on boot';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get notificationSettingsDesc => 'Ensure alerts are allowed with sound';

  @override
  String get stopAlarmNow => 'Stop alarm now';

  @override
  String get testAlarmNow => 'Test alarm now';

  @override
  String get plugInChargerFirst =>
      '⚠️ Please plug in your charger before arming Guardian Mode!';

  @override
  String get guardianArmedSnack =>
      '🛡️ Guardian Mode Armed! Alarm will sound if unplugged.';

  @override
  String get guardianDisarmedSnack => 'Guardian Mode Disarmed.';

  @override
  String targetReached(int pct) {
    return 'Target $pct% Reached!';
  }

  @override
  String targetLabel(int pct) {
    return 'Target: $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '~${mins}m to $pct%';
  }

  @override
  String get aboutDesc =>
      'Alerts you when battery reaches your chosen percentage and when battery is low.';

  @override
  String get keyFeatures => 'Key features:';

  @override
  String get readPrivacyPolicy => 'Read Privacy Policy';

  @override
  String get contributeOnGitHub => 'Contribute on GitHub';

  @override
  String get couldNotOpenBrowser => 'Could not open in browser';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get openInUpiApp => 'Open in UPI app';

  @override
  String get couldNotOpenUpi =>
      'Could not open a UPI app. Try scanning the QR or copy details below.';

  @override
  String get upiIdCopied => 'UPI ID copied';

  @override
  String get upiIntentCopied => 'UPI intent copied';

  @override
  String get privacyAssurance =>
      'We do not collect personal data. The app runs locally on your device.';

  @override
  String get openTooltip => 'Open';

  @override
  String get copyTooltip => 'Copy';

  @override
  String get scanToContribute => 'Scan to contribute';

  @override
  String get scanUsingUpi => 'Scan using any UPI app or camera scanner';

  @override
  String get voltAwake => '⚡ Volt is awake! Battery guardian ready!';

  @override
  String get voltCleanJuice =>
      '⚡ Absorbing clean juice! Battery core feels great!';

  @override
  String get voltFastFlow =>
      '🚀 Fast flow detected. We\'ll be fully powered soon!';

  @override
  String get voltHealthTip =>
      '💡 Keeping charge under 85% extends battery cell health!';

  @override
  String get voltPhoneCovered =>
      '🛡️ Guardian Active! Step away, I\'ve got your phone covered!';

  @override
  String get voltUnplugWarning =>
      '🚨 Warning: Any unauthorized unplug sounds the loud siren!';

  @override
  String get voltAllHealthy =>
      '✨ Battery cells, voltage, and thermals all 100% healthy!';

  @override
  String get voltGreetingCompanion =>
      '🤖 Hey! I\'m Volt, your personal battery guardian companion!';

  @override
  String get voltStandingBy =>
      '💚 Standing by and keeping an eye on your hardware!';

  @override
  String get meetVolt => 'Meet Volt';

  @override
  String get meetVoltDesc =>
      'Your smart battery companion. Volt watches over your device and keeps you informed.';

  @override
  String get tapVoltToSayHi => '👆 Tap Volt to say hi!';
}
