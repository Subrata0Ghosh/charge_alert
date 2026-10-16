// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'Charge intelligente et sentinelle de batterie';

  @override
  String get batteryLevel => 'Niveau de batterie';

  @override
  String get batteryCharging => 'En charge';

  @override
  String get batteryDischarging => 'Décharge';

  @override
  String get batteryFull => 'Plein';

  @override
  String get batteryNotCharging => 'Ne charge pas';

  @override
  String get batteryUnknown => 'Inconnu';

  @override
  String get hyperCharging => 'CHARGE ULTRA-RAPIDE';

  @override
  String get batteryFullCaps => 'BATTERIE PLEINE';

  @override
  String get dischargingCaps => 'DÉCHARGE';

  @override
  String get targetAlertLimit => 'Limite d\'alerte cible';

  @override
  String get targetAlertSubtitle =>
      'L\'alarme sonne lorsque la batterie atteint ce pourcentage';

  @override
  String get chargingAlarm => 'Alarme de charge';

  @override
  String get chargingAlarmSubtitle =>
      'Faire sonner lorsque le pourcentage cible est atteint';

  @override
  String get continuousAlarm => 'Alarme continue';

  @override
  String get continuousAlarmSubtitle =>
      'Continuer de sonner jusqu\'à l\'arrêt manuel';

  @override
  String get lowBatteryAlert => 'Alerte batterie faible';

  @override
  String get lowBatteryAlertSubtitle =>
      'Faire sonner lorsque la batterie est presque épuisée';

  @override
  String get lowBatteryWarning => 'Avertissement batterie faible';

  @override
  String get guardianTitle => 'Gardien antivol';

  @override
  String get guardianSubtitle =>
      'Déclenche une sirène si le chargeur est débranché';

  @override
  String get guardianArmed => 'Gardien activé';

  @override
  String get guardianDisarmed => 'Gardien désactivé';

  @override
  String get guardianArmedStatus => 'ACTIVÉ ET PROTÉGÉ';

  @override
  String get guardianDisarmedStatus => 'DÉSACTIVÉ / EN ATTENTE';

  @override
  String get armGuardian => 'Activer le gardien';

  @override
  String get disarmGuardian => 'Désactiver le gardien';

  @override
  String get guardianDescription =>
      'Lorsqu\'il est activé, si quelqu\'un débranche le chargeur, une sirène retentira jusqu\'à la saisie de votre code PIN.';

  @override
  String get guardianDisarmPrompt =>
      'Entrez votre code PIN à 4 chiffres pour désactiver le mode gardien.';

  @override
  String get setPinTitle => 'Définir le code PIN';

  @override
  String get setPinPrompt =>
      'Créez un code PIN à 4 chiffres pour sécuriser le mode antivol.';

  @override
  String get confirmPin => 'Confirmer le code PIN';

  @override
  String get enterPin => 'Entrez le code PIN';

  @override
  String get wrongPin => 'Code PIN incorrect. Veuillez réessayer.';

  @override
  String get pinsDoNotMatch => 'Les codes PIN ne correspondent pas';

  @override
  String get savePin => 'Enregistrer le PIN';

  @override
  String get theftAlarmActive => 'ALARME ANTIVOL ACTIVE !';

  @override
  String get alarmRinging => 'L\'alarme sonne !';

  @override
  String get theftAlarmSubtitle => 'Chargeur débranché ! Code PIN requis.';

  @override
  String get targetReachedSubtitle => 'Cible atteinte ou alerte active';

  @override
  String get stop => 'ARRÊTER';

  @override
  String get disarm => 'DÉSARMER';

  @override
  String get temperature => 'Température';

  @override
  String get voltage => 'Tension';

  @override
  String get health => 'Santé';

  @override
  String get healthGood => 'Bonne';

  @override
  String get plugged => 'Branché';

  @override
  String get pluggedAc => 'Chargeur secteur';

  @override
  String get pluggedUsb => 'Port USB';

  @override
  String get pluggedWireless => 'Sans fil';

  @override
  String get pluggedNone => 'Débranché';

  @override
  String get technology => 'Technologie';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système par défaut';

  @override
  String get language => 'Langue';

  @override
  String get languageSelect => 'Sélectionner la langue';

  @override
  String get chargeHistory => 'Historique de charge';

  @override
  String get noHistory => 'Aucun historique';

  @override
  String get clearHistory => 'Effacer l\'historique';

  @override
  String get about => 'À propos';

  @override
  String get contribute => 'Contribuer';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get faq => 'Foire aux questions';

  @override
  String get shareApp => 'Partager l\'application';

  @override
  String get close => 'Fermer';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get voltEnergized => '✨ Tous les systèmes sont opérationnels !';

  @override
  String get voltCharging => '⚡ Énergie absorbée ! Flux rapide et fluide !';

  @override
  String get voltTargetReached =>
      '🎉 Cible atteinte ! Débranchez pour préserver la batterie !';

  @override
  String get voltLowBattery => '🪫 Batterie faible... branchez-moi !';

  @override
  String get voltOverheating =>
      '🔥 C\'est trop chaud ! Laissez-moi refroidir !';

  @override
  String get voltGuardianArmed =>
      '🛡️ Gardien actif. Débrancher déclenchera l\'alarme !';

  @override
  String get voltTheftAlarm => '🚨 ALERTE ANTIVOL ! Arrêtez l\'alarme !';

  @override
  String get quickFaqTitle => 'FAQ rapide';

  @override
  String get faqWhyNoAlarm => 'Pourquoi l\'alarme n\'a-t-elle pas sonné ?';

  @override
  String get faqWhyNoAlarmDesc =>
      'Vérifiez que l\'activité en arrière-plan et le démarrage automatique sont autorisés.';

  @override
  String get faqBackgroundActivity => 'Activité en arrière-plan';

  @override
  String get faqAutostart => 'Démarrage automatique';

  @override
  String get faqNotifications => 'Notifications';

  @override
  String get faqOemSettings => 'Comment autoriser le démarrage auto ?';

  @override
  String get faqOemSettingsDesc =>
      'Selon le fabricant (Xiaomi/OPPO/Vivo), cela se règle dans les paramètres OEM.';

  @override
  String get replaySplashScreen => 'Rejouer l\'écran d\'accueil';

  @override
  String get introWalkthrough => 'Intro et guide';

  @override
  String get armedCaps => 'ARMÉ';

  @override
  String get idleCaps => 'INACTIF';

  @override
  String get guardianSirenWarning =>
      'La sirène retentira et verrouillera l\'écran en cas de débranchement';

  @override
  String get guardianUnplugWarning =>
      'Déclencher l\'alarme si quelqu\'un débranche le téléphone';

  @override
  String get protectedWithPin => '🔒 Protégé par un code PIN à 4 chiffres';

  @override
  String get changePin => 'Modifier le code PIN';

  @override
  String get changeSecurityPin => 'Modifier le code PIN de sécurité';

  @override
  String get pinUpdatedSuccess =>
      'Code PIN de sécurité mis à jour avec succès !';

  @override
  String get runningWarm => 'Chaud';

  @override
  String get nominalTemp => 'Temp. normale';

  @override
  String get operatingWell => 'Bon fonctionnement';

  @override
  String get powerSource => 'Source d\'alimentation';

  @override
  String get activeInput => 'Entrée active';

  @override
  String get disconnected => 'Déconnecté';

  @override
  String get alertMeWhenReaches => 'M\'alerter quand la batterie atteint :';

  @override
  String get enableAlarmSound => 'Activer le son de l\'alarme';

  @override
  String get continuousAlarmDesc =>
      'L\'alarme continue jusqu\'au débranchement ou désactivation';

  @override
  String get lowBatteryAlertDesc =>
      'Alerter si la batterie passe sous le seuil lors de la décharge';

  @override
  String get lowTarget => 'Seuil bas';

  @override
  String get allowBackgroundActivity => 'Autoriser l\'activité en arrière-plan';

  @override
  String get allowBackgroundActivityDesc =>
      'Ouvrir les paramètres de batterie : définir sur Sans restriction';

  @override
  String get autostartStartup => 'Démarrage automatique';

  @override
  String get autostartStartupDesc =>
      'Ouvrir les paramètres OEM pour autoriser le démarrage au boot';

  @override
  String get notificationSettings => 'Paramètres de notification';

  @override
  String get notificationSettingsDesc =>
      'S\'assurer que les alertes sonores sont autorisées';

  @override
  String get stopAlarmNow => 'Arrêter l\'alarme maintenant';

  @override
  String get testAlarmNow => 'Tester l\'alarme maintenant';

  @override
  String get plugInChargerFirst =>
      '⚠️ Veuillez brancher le chargeur avant d\'armer le mode Gardien !';

  @override
  String get guardianArmedSnack =>
      '🛡️ Mode Gardien armé ! L\'alarme sonnera si débranché.';

  @override
  String get guardianDisarmedSnack => 'Mode Gardien désarmé.';

  @override
  String targetReached(int pct) {
    return 'Cible de $pct% atteinte !';
  }

  @override
  String targetLabel(int pct) {
    return 'Cible : $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '~${mins}m jusqu\'à $pct%';
  }

  @override
  String get aboutDesc =>
      'Vous alerte quand la batterie atteint votre pourcentage et quand elle est faible.';

  @override
  String get keyFeatures => 'Fonctionnalités clés :';

  @override
  String get readPrivacyPolicy => 'Lire la politique de confidentialité';

  @override
  String get contributeOnGitHub => 'Contribuer sur GitHub';

  @override
  String get couldNotOpenBrowser => 'Impossible d\'ouvrir dans le navigateur';

  @override
  String get linkCopied => 'Lien copié';

  @override
  String get openInUpiApp => 'Ouvrir dans l\'application UPI';

  @override
  String get couldNotOpenUpi =>
      'Impossible d\'ouvrir l\'app UPI. Scannez le QR ou copiez les détails.';

  @override
  String get upiIdCopied => 'ID UPI copié';

  @override
  String get upiIntentCopied => 'Intention UPI copiée';

  @override
  String get privacyAssurance =>
      'Nous ne collectons aucune donnée personnelle. L\'application s\'exécute localement sur votre appareil.';

  @override
  String get openTooltip => 'Ouvrir';

  @override
  String get copyTooltip => 'Copier';

  @override
  String get scanToContribute => 'Scanner pour contribuer';

  @override
  String get scanUsingUpi =>
      'Scanner avec une application UPI ou l\'appareil photo';

  @override
  String get voltAwake => '⚡ Volt est réveillé ! Gardien de batterie prêt !';

  @override
  String get voltCleanJuice =>
      '⚡ Absorption d\'énergie pure ! La batterie est au top !';

  @override
  String get voltFastFlow => '🚀 Charge rapide détectée. Bientôt à 100% !';

  @override
  String get voltHealthTip =>
      '💡 Garder la charge sous 85% préserve la durée de vie !';

  @override
  String get voltPhoneCovered =>
      '🛡️ Gardien actif ! Je veille sur ton téléphone !';

  @override
  String get voltUnplugWarning =>
      '🚨 Attention : tout débranchement déclenche la sirène !';

  @override
  String get voltAllHealthy =>
      '✨ Cellules, tension et température en parfaite santé !';

  @override
  String get voltGreetingCompanion =>
      '🤖 Salut ! Je suis Volt, ton compagnon gardien de batterie !';

  @override
  String get voltStandingBy =>
      '💚 Toujours en veille pour protéger ton appareil !';

  @override
  String get meetVolt => 'Rencontrez Volt';

  @override
  String get meetVoltDesc =>
      'Votre compagnon de batterie intelligent. Volt veille sur votre appareil et vous informe.';

  @override
  String get tapVoltToSayHi => '👆 Touchez Volt pour lui dire bonjour !';
}
