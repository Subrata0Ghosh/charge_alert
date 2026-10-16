import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('lv'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ChargeAlert'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Charging & Battery Sentinel'**
  String get appSubtitle;

  /// No description provided for @batteryLevel.
  ///
  /// In en, this message translates to:
  /// **'Battery Level'**
  String get batteryLevel;

  /// No description provided for @batteryCharging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get batteryCharging;

  /// No description provided for @batteryDischarging.
  ///
  /// In en, this message translates to:
  /// **'Discharging'**
  String get batteryDischarging;

  /// No description provided for @batteryFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get batteryFull;

  /// No description provided for @batteryNotCharging.
  ///
  /// In en, this message translates to:
  /// **'Not Charging'**
  String get batteryNotCharging;

  /// No description provided for @batteryUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get batteryUnknown;

  /// No description provided for @hyperCharging.
  ///
  /// In en, this message translates to:
  /// **'HYPER CHARGING'**
  String get hyperCharging;

  /// No description provided for @batteryFullCaps.
  ///
  /// In en, this message translates to:
  /// **'BATTERY FULL'**
  String get batteryFullCaps;

  /// No description provided for @dischargingCaps.
  ///
  /// In en, this message translates to:
  /// **'DISCHARGING'**
  String get dischargingCaps;

  /// No description provided for @targetAlertLimit.
  ///
  /// In en, this message translates to:
  /// **'Target Alert Limit'**
  String get targetAlertLimit;

  /// No description provided for @targetAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sounds alarm when battery reaches this percentage'**
  String get targetAlertSubtitle;

  /// No description provided for @chargingAlarm.
  ///
  /// In en, this message translates to:
  /// **'Charging Alarm'**
  String get chargingAlarm;

  /// No description provided for @chargingAlarmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sound alarm when target percentage is reached'**
  String get chargingAlarmSubtitle;

  /// No description provided for @continuousAlarm.
  ///
  /// In en, this message translates to:
  /// **'Continuous Alarm'**
  String get continuousAlarm;

  /// No description provided for @continuousAlarmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep ringing until dismissed manually'**
  String get continuousAlarmSubtitle;

  /// No description provided for @lowBatteryAlert.
  ///
  /// In en, this message translates to:
  /// **'Low Battery Alert'**
  String get lowBatteryAlert;

  /// No description provided for @lowBatteryAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sound alarm when battery is running out'**
  String get lowBatteryAlertSubtitle;

  /// No description provided for @lowBatteryWarning.
  ///
  /// In en, this message translates to:
  /// **'Low Battery Warning'**
  String get lowBatteryWarning;

  /// No description provided for @guardianTitle.
  ///
  /// In en, this message translates to:
  /// **'Guardian Anti-Theft'**
  String get guardianTitle;

  /// No description provided for @guardianSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sounds continuous siren if charger is unplugged'**
  String get guardianSubtitle;

  /// No description provided for @guardianArmed.
  ///
  /// In en, this message translates to:
  /// **'Guardian Armed'**
  String get guardianArmed;

  /// No description provided for @guardianDisarmed.
  ///
  /// In en, this message translates to:
  /// **'Guardian Disarmed'**
  String get guardianDisarmed;

  /// No description provided for @guardianArmedStatus.
  ///
  /// In en, this message translates to:
  /// **'ARMED & PROTECTING'**
  String get guardianArmedStatus;

  /// No description provided for @guardianDisarmedStatus.
  ///
  /// In en, this message translates to:
  /// **'DISARMED / STANDBY'**
  String get guardianDisarmedStatus;

  /// No description provided for @armGuardian.
  ///
  /// In en, this message translates to:
  /// **'Arm Guardian Mode'**
  String get armGuardian;

  /// No description provided for @disarmGuardian.
  ///
  /// In en, this message translates to:
  /// **'Disarm Guardian Mode'**
  String get disarmGuardian;

  /// No description provided for @guardianDescription.
  ///
  /// In en, this message translates to:
  /// **'While armed, if anyone unplugs your charger, a loud siren will blast until your 4-digit PIN is entered.'**
  String get guardianDescription;

  /// No description provided for @guardianDisarmPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit PIN to disarm Anti-Theft Guardian Mode.'**
  String get guardianDisarmPrompt;

  /// No description provided for @setPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Security PIN'**
  String get setPinTitle;

  /// No description provided for @setPinPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create a 4-digit PIN to secure Anti-Theft Guardian Mode.'**
  String get setPinPrompt;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm Security PIN'**
  String get confirmPin;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-Digit Security PIN'**
  String get enterPin;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Try again.'**
  String get wrongPin;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinsDoNotMatch;

  /// No description provided for @savePin.
  ///
  /// In en, this message translates to:
  /// **'Save PIN'**
  String get savePin;

  /// No description provided for @theftAlarmActive.
  ///
  /// In en, this message translates to:
  /// **'THEFT ALARM ACTIVE!'**
  String get theftAlarmActive;

  /// No description provided for @alarmRinging.
  ///
  /// In en, this message translates to:
  /// **'Alarm Ringing!'**
  String get alarmRinging;

  /// No description provided for @theftAlarmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Charger disconnected! PIN required.'**
  String get theftAlarmSubtitle;

  /// No description provided for @targetReachedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Target reached or alert active'**
  String get targetReachedSubtitle;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'STOP'**
  String get stop;

  /// No description provided for @disarm.
  ///
  /// In en, this message translates to:
  /// **'DISARM'**
  String get disarm;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @voltage.
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get voltage;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Battery Health'**
  String get health;

  /// No description provided for @healthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get healthGood;

  /// No description provided for @plugged.
  ///
  /// In en, this message translates to:
  /// **'Plugged'**
  String get plugged;

  /// No description provided for @pluggedAc.
  ///
  /// In en, this message translates to:
  /// **'AC Charger'**
  String get pluggedAc;

  /// No description provided for @pluggedUsb.
  ///
  /// In en, this message translates to:
  /// **'USB Port'**
  String get pluggedUsb;

  /// No description provided for @pluggedWireless.
  ///
  /// In en, this message translates to:
  /// **'Wireless'**
  String get pluggedWireless;

  /// No description provided for @pluggedNone.
  ///
  /// In en, this message translates to:
  /// **'Unplugged'**
  String get pluggedNone;

  /// No description provided for @technology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get technology;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languageSelect;

  /// No description provided for @chargeHistory.
  ///
  /// In en, this message translates to:
  /// **'Charge History'**
  String get chargeHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistory;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Quick FAQ'**
  String get faq;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @voltEnergized.
  ///
  /// In en, this message translates to:
  /// **'✨ All systems operational!'**
  String get voltEnergized;

  /// No description provided for @voltCharging.
  ///
  /// In en, this message translates to:
  /// **'⚡ Absorbing energy! Flowing fast & smooth!'**
  String get voltCharging;

  /// No description provided for @voltTargetReached.
  ///
  /// In en, this message translates to:
  /// **'🎉 Target reached! Unplug now to save battery life!'**
  String get voltTargetReached;

  /// No description provided for @voltLowBattery.
  ///
  /// In en, this message translates to:
  /// **'🪫 My energy is running out... feed me power!'**
  String get voltLowBattery;

  /// No description provided for @voltOverheating.
  ///
  /// In en, this message translates to:
  /// **'🔥 I\'m running hot! Please give me some air!'**
  String get voltOverheating;

  /// No description provided for @voltGuardianArmed.
  ///
  /// In en, this message translates to:
  /// **'🛡️ Guardian Armed. Unplugging triggers loud siren!'**
  String get voltGuardianArmed;

  /// No description provided for @voltTheftAlarm.
  ///
  /// In en, this message translates to:
  /// **'🚨 INTRUSION OR ALERT! Stop the alarm!'**
  String get voltTheftAlarm;

  /// No description provided for @quickFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick FAQ'**
  String get quickFaqTitle;

  /// No description provided for @faqWhyNoAlarm.
  ///
  /// In en, this message translates to:
  /// **'Why didn\'t the alarm ring?'**
  String get faqWhyNoAlarm;

  /// No description provided for @faqWhyNoAlarmDesc.
  ///
  /// In en, this message translates to:
  /// **'Ensure background activity is allowed, autostart is enabled, and notifications have sound. Use the shortcuts below to open settings.'**
  String get faqWhyNoAlarmDesc;

  /// No description provided for @faqBackgroundActivity.
  ///
  /// In en, this message translates to:
  /// **'Background activity'**
  String get faqBackgroundActivity;

  /// No description provided for @faqAutostart.
  ///
  /// In en, this message translates to:
  /// **'Autostart'**
  String get faqAutostart;

  /// No description provided for @faqNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get faqNotifications;

  /// No description provided for @faqOemSettings.
  ///
  /// In en, this message translates to:
  /// **'How to allow autostart/startup?'**
  String get faqOemSettings;

  /// No description provided for @faqOemSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Different brands place this in OEM settings (e.g., Xiaomi/OPPO/Vivo). Use the Autostart shortcut and enable startup for ChargeAlert.'**
  String get faqOemSettingsDesc;

  /// No description provided for @replaySplashScreen.
  ///
  /// In en, this message translates to:
  /// **'Replay Splash Screen'**
  String get replaySplashScreen;

  /// No description provided for @introWalkthrough.
  ///
  /// In en, this message translates to:
  /// **'Intro & Walkthrough'**
  String get introWalkthrough;

  /// No description provided for @armedCaps.
  ///
  /// In en, this message translates to:
  /// **'ARMED'**
  String get armedCaps;

  /// No description provided for @idleCaps.
  ///
  /// In en, this message translates to:
  /// **'IDLE'**
  String get idleCaps;

  /// No description provided for @guardianSirenWarning.
  ///
  /// In en, this message translates to:
  /// **'Siren will blast & lock screen if unplugged'**
  String get guardianSirenWarning;

  /// No description provided for @guardianUnplugWarning.
  ///
  /// In en, this message translates to:
  /// **'Sound alarm if someone unplugs phone'**
  String get guardianUnplugWarning;

  /// No description provided for @protectedWithPin.
  ///
  /// In en, this message translates to:
  /// **'🔒 Protected with 4-digit PIN'**
  String get protectedWithPin;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @changeSecurityPin.
  ///
  /// In en, this message translates to:
  /// **'Change Security PIN'**
  String get changeSecurityPin;

  /// No description provided for @pinUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Security PIN updated successfully!'**
  String get pinUpdatedSuccess;

  /// No description provided for @runningWarm.
  ///
  /// In en, this message translates to:
  /// **'Running Warm'**
  String get runningWarm;

  /// No description provided for @nominalTemp.
  ///
  /// In en, this message translates to:
  /// **'Nominal Temp'**
  String get nominalTemp;

  /// No description provided for @operatingWell.
  ///
  /// In en, this message translates to:
  /// **'Operating Well'**
  String get operatingWell;

  /// No description provided for @powerSource.
  ///
  /// In en, this message translates to:
  /// **'Power Source'**
  String get powerSource;

  /// No description provided for @activeInput.
  ///
  /// In en, this message translates to:
  /// **'Active Input'**
  String get activeInput;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @alertMeWhenReaches.
  ///
  /// In en, this message translates to:
  /// **'Alert me when battery reaches:'**
  String get alertMeWhenReaches;

  /// No description provided for @enableAlarmSound.
  ///
  /// In en, this message translates to:
  /// **'Enable Alarm Sound'**
  String get enableAlarmSound;

  /// No description provided for @continuousAlarmDesc.
  ///
  /// In en, this message translates to:
  /// **'Alarm will continue until you unplug or disable it'**
  String get continuousAlarmDesc;

  /// No description provided for @lowBatteryAlertDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert when battery goes below target while discharging'**
  String get lowBatteryAlertDesc;

  /// No description provided for @lowTarget.
  ///
  /// In en, this message translates to:
  /// **'Low target'**
  String get lowTarget;

  /// No description provided for @allowBackgroundActivity.
  ///
  /// In en, this message translates to:
  /// **'Allow background activity'**
  String get allowBackgroundActivity;

  /// No description provided for @allowBackgroundActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Open app battery settings: set to Unrestricted / Allow'**
  String get allowBackgroundActivityDesc;

  /// No description provided for @autostartStartup.
  ///
  /// In en, this message translates to:
  /// **'Autostart / Startup'**
  String get autostartStartup;

  /// No description provided for @autostartStartupDesc.
  ///
  /// In en, this message translates to:
  /// **'Open OEM autostart page to allow startup on boot'**
  String get autostartStartupDesc;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettings;

  /// No description provided for @notificationSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Ensure alerts are allowed with sound'**
  String get notificationSettingsDesc;

  /// No description provided for @stopAlarmNow.
  ///
  /// In en, this message translates to:
  /// **'Stop alarm now'**
  String get stopAlarmNow;

  /// No description provided for @testAlarmNow.
  ///
  /// In en, this message translates to:
  /// **'Test alarm now'**
  String get testAlarmNow;

  /// No description provided for @plugInChargerFirst.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Please plug in your charger before arming Guardian Mode!'**
  String get plugInChargerFirst;

  /// No description provided for @guardianArmedSnack.
  ///
  /// In en, this message translates to:
  /// **'🛡️ Guardian Mode Armed! Alarm will sound if unplugged.'**
  String get guardianArmedSnack;

  /// No description provided for @guardianDisarmedSnack.
  ///
  /// In en, this message translates to:
  /// **'Guardian Mode Disarmed.'**
  String get guardianDisarmedSnack;

  /// No description provided for @targetReached.
  ///
  /// In en, this message translates to:
  /// **'Target {pct}% Reached!'**
  String targetReached(int pct);

  /// No description provided for @targetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target: {pct}%'**
  String targetLabel(int pct);

  /// No description provided for @timeToTarget.
  ///
  /// In en, this message translates to:
  /// **'~{mins}m to {pct}%'**
  String timeToTarget(int mins, int pct);

  /// No description provided for @aboutDesc.
  ///
  /// In en, this message translates to:
  /// **'Alerts you when battery reaches your chosen percentage and when battery is low.'**
  String get aboutDesc;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key features:'**
  String get keyFeatures;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read Privacy Policy'**
  String get readPrivacyPolicy;

  /// No description provided for @contributeOnGitHub.
  ///
  /// In en, this message translates to:
  /// **'Contribute on GitHub'**
  String get contributeOnGitHub;

  /// No description provided for @couldNotOpenBrowser.
  ///
  /// In en, this message translates to:
  /// **'Could not open in browser'**
  String get couldNotOpenBrowser;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @openInUpiApp.
  ///
  /// In en, this message translates to:
  /// **'Open in UPI app'**
  String get openInUpiApp;

  /// No description provided for @couldNotOpenUpi.
  ///
  /// In en, this message translates to:
  /// **'Could not open a UPI app. Try scanning the QR or copy details below.'**
  String get couldNotOpenUpi;

  /// No description provided for @upiIdCopied.
  ///
  /// In en, this message translates to:
  /// **'UPI ID copied'**
  String get upiIdCopied;

  /// No description provided for @upiIntentCopied.
  ///
  /// In en, this message translates to:
  /// **'UPI intent copied'**
  String get upiIntentCopied;

  /// No description provided for @privacyAssurance.
  ///
  /// In en, this message translates to:
  /// **'We do not collect personal data. The app runs locally on your device.'**
  String get privacyAssurance;

  /// No description provided for @openTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openTooltip;

  /// No description provided for @copyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyTooltip;

  /// No description provided for @scanToContribute.
  ///
  /// In en, this message translates to:
  /// **'Scan to contribute'**
  String get scanToContribute;

  /// No description provided for @scanUsingUpi.
  ///
  /// In en, this message translates to:
  /// **'Scan using any UPI app or camera scanner'**
  String get scanUsingUpi;

  /// No description provided for @voltAwake.
  ///
  /// In en, this message translates to:
  /// **'⚡ Volt is awake! Battery guardian ready!'**
  String get voltAwake;

  /// No description provided for @voltCleanJuice.
  ///
  /// In en, this message translates to:
  /// **'⚡ Absorbing clean juice! Battery core feels great!'**
  String get voltCleanJuice;

  /// No description provided for @voltFastFlow.
  ///
  /// In en, this message translates to:
  /// **'🚀 Fast flow detected. We\'ll be fully powered soon!'**
  String get voltFastFlow;

  /// No description provided for @voltHealthTip.
  ///
  /// In en, this message translates to:
  /// **'💡 Keeping charge under 85% extends battery cell health!'**
  String get voltHealthTip;

  /// No description provided for @voltPhoneCovered.
  ///
  /// In en, this message translates to:
  /// **'🛡️ Guardian Active! Step away, I\'ve got your phone covered!'**
  String get voltPhoneCovered;

  /// No description provided for @voltUnplugWarning.
  ///
  /// In en, this message translates to:
  /// **'🚨 Warning: Any unauthorized unplug sounds the loud siren!'**
  String get voltUnplugWarning;

  /// No description provided for @voltAllHealthy.
  ///
  /// In en, this message translates to:
  /// **'✨ Battery cells, voltage, and thermals all 100% healthy!'**
  String get voltAllHealthy;

  /// No description provided for @voltGreetingCompanion.
  ///
  /// In en, this message translates to:
  /// **'🤖 Hey! I\'m Volt, your personal battery guardian companion!'**
  String get voltGreetingCompanion;

  /// No description provided for @voltStandingBy.
  ///
  /// In en, this message translates to:
  /// **'💚 Standing by and keeping an eye on your hardware!'**
  String get voltStandingBy;

  /// No description provided for @meetVolt.
  ///
  /// In en, this message translates to:
  /// **'Meet Volt'**
  String get meetVolt;

  /// No description provided for @meetVoltDesc.
  ///
  /// In en, this message translates to:
  /// **'Your smart battery companion. Volt watches over your device and keeps you informed.'**
  String get meetVoltDesc;

  /// No description provided for @tapVoltToSayHi.
  ///
  /// In en, this message translates to:
  /// **'👆 Tap Volt to say hi!'**
  String get tapVoltToSayHi;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'lv',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'lv':
      return AppLocalizationsLv();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
