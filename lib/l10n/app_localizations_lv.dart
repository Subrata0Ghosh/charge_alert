// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'Viedā uzlāde un akumulatora sargs';

  @override
  String get batteryLevel => 'Akumulatora līmenis';

  @override
  String get batteryCharging => 'Uzlādējas';

  @override
  String get batteryDischarging => 'Izlādējas';

  @override
  String get batteryFull => 'Pilns';

  @override
  String get batteryNotCharging => 'Netiek uzlādēts';

  @override
  String get batteryUnknown => 'Nezināms';

  @override
  String get hyperCharging => 'ĀTRĀ UZLĀDE';

  @override
  String get batteryFullCaps => 'AKUMULATORS PILNS';

  @override
  String get dischargingCaps => 'IZLĀDĒJAS';

  @override
  String get targetAlertLimit => 'Mērķa uzlādes limits';

  @override
  String get targetAlertSubtitle =>
      'Atskaņo trauksmi, kad akumulators sasniedz šo līmeni';

  @override
  String get chargingAlarm => 'Uzlādes trauksme';

  @override
  String get chargingAlarmSubtitle =>
      'Atskaņot signālu, kad sasniegts mērķa procents';

  @override
  String get continuousAlarm => 'Nepārtraukta trauksme';

  @override
  String get continuousAlarmSubtitle =>
      'Zvanīt nepārtraukti, līdz tiek apturēts manuāli';

  @override
  String get lowBatteryAlert => 'Zema uzlādes līmeņa trauksme';

  @override
  String get lowBatteryAlertSubtitle =>
      'Atskaņot signālu, kad akumulators izlādējas';

  @override
  String get lowBatteryWarning => 'Zema akumulatora brīdinājums';

  @override
  String get guardianTitle => 'Aizsardzība pret zādzībām';

  @override
  String get guardianSubtitle =>
      'Atskaņo skaļu sirēnu, ja lādētājs tiek atvienots';

  @override
  String get guardianArmed => 'Aizsardzība ieslēgta';

  @override
  String get guardianDisarmed => 'Aizsardzība izslēgta';

  @override
  String get guardianArmedStatus => 'IESLĒGTS UN AIZSARGĀ';

  @override
  String get guardianDisarmedStatus => 'IZSLĒGTS / GAIDA';

  @override
  String get armGuardian => 'Ieslēgt aizsardzības režīmu';

  @override
  String get disarmGuardian => 'Izslēgt aizsardzības režīmu';

  @override
  String get guardianDescription =>
      'Kamēr režīms ir aktīvs, atvienojot lādētāju, atskanēs skaļa sirēna, līdz ievadīsiet 4 ciparu PIN kodu.';

  @override
  String get guardianDisarmPrompt =>
      'Ievadiet savu 4 ciparu PIN kodu, lai izslēgtu aizsardzību pret zādzībām.';

  @override
  String get setPinTitle => 'Iestatīt drošības PIN';

  @override
  String get setPinPrompt =>
      'Izveidojiet 4 ciparu PIN kodu aizsardzības režīma drošībai.';

  @override
  String get confirmPin => 'Apstiprināt drošības PIN';

  @override
  String get enterPin => 'Ievadiet 4 ciparu drošības PIN';

  @override
  String get wrongPin => 'Nepareizs PIN. Mēģiniet vēlreiz.';

  @override
  String get pinsDoNotMatch => 'PIN kodi nesakrīt';

  @override
  String get savePin => 'Saglabāt PIN';

  @override
  String get theftAlarmActive => 'ZĀDZĪBAS TRAUKSME AKTĪVA!';

  @override
  String get alarmRinging => 'Trauksmes signāls skan!';

  @override
  String get theftAlarmSubtitle => 'Lādētājs atvienots! Nepieciešams PIN.';

  @override
  String get targetReachedSubtitle => 'Mērķis sasniegts vai brīdinājums aktīvs';

  @override
  String get stop => 'APTURĒT';

  @override
  String get disarm => 'ATSLĒGT';

  @override
  String get temperature => 'Temperatūra';

  @override
  String get voltage => 'Spriegums';

  @override
  String get health => 'Stāvoklis';

  @override
  String get healthGood => 'Labs';

  @override
  String get plugged => 'Pieslēgts';

  @override
  String get pluggedAc => 'Tīkla lādētājs';

  @override
  String get pluggedUsb => 'USB pieslēgvieta';

  @override
  String get pluggedWireless => 'Bezvadu uzlāde';

  @override
  String get pluggedNone => 'Atvienots';

  @override
  String get technology => 'Tehnoloģija';

  @override
  String get theme => 'Motīvs';

  @override
  String get themeLight => 'Gaišais';

  @override
  String get themeDark => 'Tumšais';

  @override
  String get themeSystem => 'Sistēmas noklusējums';

  @override
  String get language => 'Valoda';

  @override
  String get languageSelect => 'Izvēlēties valodu';

  @override
  String get chargeHistory => 'Uzlādes vēsture';

  @override
  String get noHistory => 'Vēstures vēl nav';

  @override
  String get clearHistory => 'Notīrīt vēsturi';

  @override
  String get about => 'Par lietotni';

  @override
  String get contribute => 'Atbalstīt';

  @override
  String get privacyPolicy => 'Privātuma politika';

  @override
  String get faq => 'Biežāk uzdotie jautājumi';

  @override
  String get shareApp => 'Kopīgot lietotni';

  @override
  String get close => 'Aizvērt';

  @override
  String get cancel => 'Atcelt';

  @override
  String get ok => 'Labi';

  @override
  String get voltEnergized => '✨ Visas sistēmas darbojas nevainojami!';

  @override
  String get voltCharging => '⚡ Uzņemu enerģiju! Ātra un vienmērīga plūsma!';

  @override
  String get voltTargetReached =>
      '🎉 Mērķis sasniegts! Atvienojiet lādētāju, lai saudzētu akumulatoru!';

  @override
  String get voltLowBattery =>
      '🪫 Man trūkst enerģijas... pieslēdziet lādētāju!';

  @override
  String get voltOverheating => '🔥 Pārāk karsts! Lūdzu, ļaujiet man atdzist!';

  @override
  String get voltGuardianArmed =>
      '🛡️ Aizsargs aktīvs. Atvienošana iedarbinās skaļu sirēnu!';

  @override
  String get voltTheftAlarm => '🚨 ZĀDZĪBAS BRĪDINĀJUMS! Apturiet trauksmi!';

  @override
  String get quickFaqTitle => 'Biežāk uzdotie jautājumi';

  @override
  String get faqWhyNoAlarm => 'Kāpēc neatskanēja trauksmes signāls?';

  @override
  String get faqWhyNoAlarmDesc =>
      'Pārliecinieties, ka fona darbība ir atļauta, automātiskā palaišana ir iespējota un paziņojumiem ir skaņa. Izmantojiet saīsnes zemāk.';

  @override
  String get faqBackgroundActivity => 'Fona darbība';

  @override
  String get faqAutostart => 'Automātiskā palaišana';

  @override
  String get faqNotifications => 'Paziņojumi';

  @override
  String get faqOemSettings => 'Kā iespējot automātisko palaišanu?';

  @override
  String get faqOemSettingsDesc =>
      'Dažādi ražotāji to novieto OEM iestatījumos (piem., Xiaomi/OPPO/Vivo). Izmantojiet augstāk esošo saīsni un iespējojiet to lietotnei ChargeAlert.';

  @override
  String get replaySplashScreen => 'Atkārtot sākuma ekrānu';

  @override
  String get introWalkthrough => 'Ievads un ceļvedis';

  @override
  String get armedCaps => 'IESLĒGTS';

  @override
  String get idleCaps => 'DĪKSTĀVE';

  @override
  String get guardianSirenWarning =>
      'Sirēna skanēs un ekrāns bloķēsies, ja atvienots';

  @override
  String get guardianUnplugWarning =>
      'Atskaņot trauksmi, ja kāds atvieno tālruni';

  @override
  String get protectedWithPin => '🔒 Aizsargāts ar 4 ciparu PIN';

  @override
  String get changePin => 'Mainīt PIN';

  @override
  String get changeSecurityPin => 'Mainīt drošības PIN';

  @override
  String get pinUpdatedSuccess => 'Drošības PIN veiksmīgi atjaunināts!';

  @override
  String get runningWarm => 'Sakarst';

  @override
  String get nominalTemp => 'Normāla temp.';

  @override
  String get operatingWell => 'Darbojas labi';

  @override
  String get powerSource => 'Barošanas avots';

  @override
  String get activeInput => 'Aktīva ieeja';

  @override
  String get disconnected => 'Atvienots';

  @override
  String get alertMeWhenReaches => 'Brīdināt, kad akumulators sasniedz:';

  @override
  String get enableAlarmSound => 'Ieslēgt trauksmes skaņu';

  @override
  String get continuousAlarmDesc =>
      'Trauksme skanēs, līdz atvienosiet vai izslēgsiet';

  @override
  String get lowBatteryAlertDesc =>
      'Brīdināt, kad akumulatora līmenis nokrītas zem mērķa';

  @override
  String get lowTarget => 'Zemais mērķis';

  @override
  String get allowBackgroundActivity => 'Atļaut fona darbību';

  @override
  String get allowBackgroundActivityDesc =>
      'Atvērt akumulatora iestatījumus: iestatīt Neierobežots / Atļaut';

  @override
  String get autostartStartup => 'Automātiskā palaišana';

  @override
  String get autostartStartupDesc =>
      'Atvērt automātiskās palaišanas lapu, lai atļautu palaišanu pēc sāknēšanas';

  @override
  String get notificationSettings => 'Paziņojumu iestatījumi';

  @override
  String get notificationSettingsDesc =>
      'Pārliecinieties, ka brīdinājumi ir atļauti ar skaņu';

  @override
  String get stopAlarmNow => 'Apturēt trauksmi tūlīt';

  @override
  String get testAlarmNow => 'Pārbaudīt trauksmi tūlīt';

  @override
  String get plugInChargerFirst =>
      '⚠️ Lūdzu, pievienojiet lādētāju pirms aizsarga režīma ieslēgšanas!';

  @override
  String get guardianArmedSnack =>
      '🛡️ Aizsarga režīms ieslēgts! Trauksme skanēs, ja atvienots.';

  @override
  String get guardianDisarmedSnack => 'Aizsarga režīms izslēgts.';

  @override
  String targetReached(int pct) {
    return 'Mērķis $pct% sasniegts!';
  }

  @override
  String targetLabel(int pct) {
    return 'Mērķis: $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '~$mins min līdz $pct%';
  }

  @override
  String get aboutDesc =>
      'Brīdina, kad akumulators sasniedz izvēlēto procentu un kad uzlāde ir zema.';

  @override
  String get keyFeatures => 'Galvenās funkcijas:';

  @override
  String get readPrivacyPolicy => 'Lasīt privātuma politiku';

  @override
  String get contributeOnGitHub => 'Piedalīties GitHub';

  @override
  String get couldNotOpenBrowser => 'Nevarēja atvērt pārlūkprogrammā';

  @override
  String get linkCopied => 'Saite nokopēta';

  @override
  String get openInUpiApp => 'Atvērt UPI lietotnē';

  @override
  String get couldNotOpenUpi =>
      'Nevarēja atvērt UPI lietotni. Mēģiniet skenēt QR vai kopēt datus zemāk.';

  @override
  String get upiIdCopied => 'UPI ID nokopēts';

  @override
  String get upiIntentCopied => 'UPI nodoms nokopēts';

  @override
  String get privacyAssurance =>
      'Mēs neapkopojam personas datus. Lietotne darbojas lokāli jūsu ierīcē.';

  @override
  String get openTooltip => 'Atvērt';

  @override
  String get copyTooltip => 'Kopēt';

  @override
  String get scanToContribute => 'Skenējiet, lai atbalstītu';

  @override
  String get scanUsingUpi =>
      'Skenējiet ar jebkuru UPI lietotni vai kameras skeneri';

  @override
  String get voltAwake => '⚡ Volts ir modies! Akumulatora sargs gatavs!';

  @override
  String get voltCleanJuice =>
      '⚡ Uzsūcu tīru enerģiju! Akumulatora serde jūtas lieliski!';

  @override
  String get voltFastFlow =>
      '🚀 Noteikta ātra uzlāde. Drīz būsim pilnībā uzlādēti!';

  @override
  String get voltHealthTip =>
      '💡 Uzlādes uzturēšana zem 85% pagarina akumulatora mūžu!';

  @override
  String get voltPhoneCovered =>
      '🛡️ Aizsargs aktīvs! Es uzraugu tavu tālruni!';

  @override
  String get voltUnplugWarning =>
      '🚨 Brīdinājums: neatļauta atvienošana iedarbinās skaļu sirēnu!';

  @override
  String get voltAllHealthy =>
      '✨ Akumulatora šūnas, spriegums un temperatūra ir teicamā stāvoklī!';

  @override
  String get voltGreetingCompanion =>
      '🤖 Sveiki! Es esmu Volts, tavs viedais akumulatora sargs!';

  @override
  String get voltStandingBy => '💚 Esmu gatavībā un uzraugu tavu ierīci!';

  @override
  String get meetVolt => 'Iepazīstieties ar Voltu';

  @override
  String get meetVoltDesc =>
      'Tavs viedais akumulatora pavadonis. Volts uzrauga tavu ierīci un informē tevi.';

  @override
  String get tapVoltToSayHi => '👆 Pieskaries Voltam, lai sasveicinātos!';
}
