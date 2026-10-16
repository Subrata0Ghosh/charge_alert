// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'Intelligentes Laden & Akku-Wächter';

  @override
  String get batteryLevel => 'Akkustand';

  @override
  String get batteryCharging => 'Lädt';

  @override
  String get batteryDischarging => 'Entlädt';

  @override
  String get batteryFull => 'Voll';

  @override
  String get batteryNotCharging => 'Lädt nicht';

  @override
  String get batteryUnknown => 'Unbekannt';

  @override
  String get hyperCharging => 'SCHNELLLADEN';

  @override
  String get batteryFullCaps => 'AKKU VOLL';

  @override
  String get dischargingCaps => 'ENTLÄDT';

  @override
  String get targetAlertLimit => 'Ziel-Ladelimit';

  @override
  String get targetAlertSubtitle =>
      'Alarm ertönt, wenn der Akku diesen Prozentsatz erreicht';

  @override
  String get chargingAlarm => 'Lade-Alarm';

  @override
  String get chargingAlarmSubtitle =>
      'Alarm auslösen, wenn der Zielprozentsatz erreicht ist';

  @override
  String get continuousAlarm => 'Daueralarm';

  @override
  String get continuousAlarmSubtitle =>
      'Klingelt weiter, bis er manuell beendet wird';

  @override
  String get lowBatteryAlert => 'Niedriger Akkustand Alarm';

  @override
  String get lowBatteryAlertSubtitle =>
      'Alarm ertönt, wenn der Akku fast leer ist';

  @override
  String get lowBatteryWarning => 'Niedriger Akkustand Warnung';

  @override
  String get guardianTitle => 'Diebstahlschutz';

  @override
  String get guardianSubtitle =>
      'Lauter Sirenenton, falls das Ladekabel abgezogen wird';

  @override
  String get guardianArmed => 'Schutz aktiviert';

  @override
  String get guardianDisarmed => 'Schutz deaktiviert';

  @override
  String get guardianArmedStatus => 'AKTIVIERT & GESCHÜTZT';

  @override
  String get guardianDisarmedStatus => 'DEAKTIVIERT / BEREIT';

  @override
  String get armGuardian => 'Schutzmodus aktivieren';

  @override
  String get disarmGuardian => 'Schutzmodus deaktivieren';

  @override
  String get guardianDescription =>
      'Wenn aktiviert, ertönt eine laute Sirene, falls jemand das Ladekabel abzieht, bis Ihre 4-stellige PIN eingegeben wird.';

  @override
  String get guardianDisarmPrompt =>
      'Geben Sie Ihre 4-stellige PIN ein, um den Schutzmodus zu deaktivieren.';

  @override
  String get setPinTitle => 'Sicherheits-PIN festlegen';

  @override
  String get setPinPrompt =>
      'Erstellen Sie eine 4-stellige PIN für den Diebstahlschutz.';

  @override
  String get confirmPin => 'Sicherheits-PIN bestätigen';

  @override
  String get enterPin => '4-stellige PIN eingeben';

  @override
  String get wrongPin => 'Falsche PIN. Bitte erneut versuchen.';

  @override
  String get pinsDoNotMatch => 'PINs stimmen nicht überein';

  @override
  String get savePin => 'PIN speichern';

  @override
  String get theftAlarmActive => 'DIEBSTAHLALARM AKTIV!';

  @override
  String get alarmRinging => 'Alarm klingelt!';

  @override
  String get theftAlarmSubtitle => 'Ladekabel abgezogen! PIN erforderlich.';

  @override
  String get targetReachedSubtitle => 'Ziel erreicht oder Alarm aktiv';

  @override
  String get stop => 'STOPP';

  @override
  String get disarm => 'ENTSICHERN';

  @override
  String get temperature => 'Temperatur';

  @override
  String get voltage => 'Spannung';

  @override
  String get health => 'Zustand';

  @override
  String get healthGood => 'Gut';

  @override
  String get plugged => 'Angeschlossen';

  @override
  String get pluggedAc => 'Netzteil';

  @override
  String get pluggedUsb => 'USB-Anschluss';

  @override
  String get pluggedWireless => 'Drahtlos';

  @override
  String get pluggedNone => 'Getrennt';

  @override
  String get technology => 'Technologie';

  @override
  String get theme => 'Design';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeSystem => 'Systemstandard';

  @override
  String get language => 'Sprache';

  @override
  String get languageSelect => 'Sprache auswählen';

  @override
  String get chargeHistory => 'Ladeverlauf';

  @override
  String get noHistory => 'Noch kein Verlauf vorhanden';

  @override
  String get clearHistory => 'Verlauf löschen';

  @override
  String get about => 'Über die App';

  @override
  String get contribute => 'Unterstützen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get faq => 'Häufige Fragen';

  @override
  String get shareApp => 'App teilen';

  @override
  String get close => 'Schließen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get voltEnergized => '✨ Alle Systeme betriebsbereit!';

  @override
  String get voltCharging => '⚡ Energie fließt! Schnell und stabil!';

  @override
  String get voltTargetReached =>
      '🎉 Ziel erreicht! Jetzt abstecken, um den Akku zu schonen!';

  @override
  String get voltLowBattery => '🪫 Akku wird schwach... bitte aufladen!';

  @override
  String get voltOverheating => '🔥 Mir ist zu heiß! Bitte abkühlen lassen!';

  @override
  String get voltGuardianArmed =>
      '🛡️ Wächter aktiv. Abstecken löst Alarm aus!';

  @override
  String get voltTheftAlarm => '🚨 DIEBSTAHLWARNUNG! Alarm stoppen!';

  @override
  String get quickFaqTitle => 'Häufige Fragen';

  @override
  String get faqWhyNoAlarm => 'Warum hat der Alarm nicht geklingelt?';

  @override
  String get faqWhyNoAlarmDesc =>
      'Stellen Sie sicher, dass Hintergrundaktivität und Autostart erlaubt sind.';

  @override
  String get faqBackgroundActivity => 'Hintergrundaktivität';

  @override
  String get faqAutostart => 'Autostart';

  @override
  String get faqNotifications => 'Benachrichtigungen';

  @override
  String get faqOemSettings => 'Wie aktiviere ich Autostart?';

  @override
  String get faqOemSettingsDesc =>
      'Einige Hersteller (z.B. Xiaomi/OPPO/Vivo) haben dies in den OEM-Einstellungen.';

  @override
  String get replaySplashScreen => 'Startbildschirm wiederholen';

  @override
  String get introWalkthrough => 'Einführung & Anleitung';

  @override
  String get armedCaps => 'SCHARF';

  @override
  String get idleCaps => 'BEREIT';

  @override
  String get guardianSirenWarning =>
      'Sirene ertönt und sperrt Bildschirm beim Abstecken';

  @override
  String get guardianUnplugWarning =>
      'Alarm auslösen, wenn jemand das Telefon absteckt';

  @override
  String get protectedWithPin => '🔒 Mit 4-stelligem PIN geschützt';

  @override
  String get changePin => 'PIN ändern';

  @override
  String get changeSecurityPin => 'Sicherheits-PIN ändern';

  @override
  String get pinUpdatedSuccess => 'Sicherheits-PIN erfolgreich aktualisiert!';

  @override
  String get runningWarm => 'Warm';

  @override
  String get nominalTemp => 'Normale Temp.';

  @override
  String get operatingWell => 'Einwandfrei';

  @override
  String get powerSource => 'Stromquelle';

  @override
  String get activeInput => 'Aktiver Eingang';

  @override
  String get disconnected => 'Getrennt';

  @override
  String get alertMeWhenReaches => 'Benachrichtigen, wenn Akku erreicht:';

  @override
  String get enableAlarmSound => 'Alarmton aktivieren';

  @override
  String get continuousAlarmDesc =>
      'Alarm ertönt, bis er ausgesteckt oder deaktiviert wird';

  @override
  String get lowBatteryAlertDesc =>
      'Warnen, wenn der Akku unter das Ziel sinkt';

  @override
  String get lowTarget => 'Niedrig-Ziel';

  @override
  String get allowBackgroundActivity => 'Hintergrundaktivität zulassen';

  @override
  String get allowBackgroundActivityDesc =>
      'Akku-Einstellungen: auf Uneingeschränkt / Erlauben setzen';

  @override
  String get autostartStartup => 'Autostart / Systemstart';

  @override
  String get autostartStartupDesc =>
      'OEM-Autostart-Seite öffnen, um Start beim Hochfahren zu erlauben';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get notificationSettingsDesc =>
      'Sicherstellen, dass Alarme mit Ton erlaubt sind';

  @override
  String get stopAlarmNow => 'Alarm jetzt stoppen';

  @override
  String get testAlarmNow => 'Alarm jetzt testen';

  @override
  String get plugInChargerFirst =>
      '⚠️ Bitte Ladekabel anschließen, bevor Wächter-Modus aktiviert wird!';

  @override
  String get guardianArmedSnack =>
      '🛡️ Wächter-Modus scharf! Alarm ertönt beim Ausstecken.';

  @override
  String get guardianDisarmedSnack => 'Wächter-Modus deaktiviert.';

  @override
  String targetReached(int pct) {
    return 'Ziel $pct% erreicht!';
  }

  @override
  String targetLabel(int pct) {
    return 'Ziel: $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '~$mins Min. bis $pct%';
  }

  @override
  String get aboutDesc =>
      'Benachrichtigt Sie, wenn der Akku den gewählten Prozentsatz erreicht und fast leer ist.';

  @override
  String get keyFeatures => 'Hauptmerkmale:';

  @override
  String get readPrivacyPolicy => 'Datenschutzerklärung lesen';

  @override
  String get contributeOnGitHub => 'Auf GitHub beitragen';

  @override
  String get couldNotOpenBrowser => 'Konnte nicht im Browser geöffnet werden';

  @override
  String get linkCopied => 'Link kopiert';

  @override
  String get openInUpiApp => 'In UPI-App öffnen';

  @override
  String get couldNotOpenUpi =>
      'UPI-App konnte nicht geöffnet werden. Bitte QR scannen oder kopieren.';

  @override
  String get upiIdCopied => 'UPI-ID kopiert';

  @override
  String get upiIntentCopied => 'UPI-Intent kopiert';

  @override
  String get privacyAssurance =>
      'Wir erfassen keine persönlichen Daten. Die App läuft lokal auf Ihrem Gerät.';

  @override
  String get openTooltip => 'Öffnen';

  @override
  String get copyTooltip => 'Kopieren';

  @override
  String get scanToContribute => 'Scannen zum Beitragen';

  @override
  String get scanUsingUpi => 'Mit einer UPI-App oder Kamera scannen';

  @override
  String get voltAwake => '⚡ Volt ist wach! Akku-Wächter ist bereit!';

  @override
  String get voltCleanJuice =>
      '⚡ Saubere Energie fließt! Akkukern fühlt sich super an!';

  @override
  String get voltFastFlow =>
      '🚀 Schnelles Laden erkannt. Bald voll aufgeladen!';

  @override
  String get voltHealthTip =>
      '💡 Laden bis unter 85% verlängert die Akkulebensdauer!';

  @override
  String get voltPhoneCovered =>
      '🛡️ Wächter aktiv! Ich passe auf dein Telefon auf!';

  @override
  String get voltUnplugWarning =>
      '🚨 Warnung: Unerlaubtes Trennen löst lauten Alarm aus!';

  @override
  String get voltAllHealthy =>
      '✨ Akkuzellen, Spannung und Temperatur sind optimal!';

  @override
  String get voltGreetingCompanion =>
      '🤖 Hallo! Ich bin Volt, dein persönlicher Akku-Wächter!';

  @override
  String get voltStandingBy => '💚 Bereit und aufmerksam für deine Hardware!';

  @override
  String get meetVolt => 'Lerne Volt kennen';

  @override
  String get meetVoltDesc =>
      'Dein smarter Akku-Begleiter. Volt überwacht dein Gerät und hält dich informiert.';

  @override
  String get tapVoltToSayHi => '👆 Tippe auf Volt, um Hallo zu sagen!';
}
