// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'Carga inteligente y centinela de batería';

  @override
  String get batteryLevel => 'Nivel de batería';

  @override
  String get batteryCharging => 'Cargando';

  @override
  String get batteryDischarging => 'Descargando';

  @override
  String get batteryFull => 'Completa';

  @override
  String get batteryNotCharging => 'No está cargando';

  @override
  String get batteryUnknown => 'Desconocido';

  @override
  String get hyperCharging => 'CARGA RÁPIDA';

  @override
  String get batteryFullCaps => 'BATERÍA LLENA';

  @override
  String get dischargingCaps => 'DESCARGANDO';

  @override
  String get targetAlertLimit => 'Límite de alerta objetivo';

  @override
  String get targetAlertSubtitle =>
      'Suena la alarma cuando la batería alcanza este porcentaje';

  @override
  String get chargingAlarm => 'Alarma de carga';

  @override
  String get chargingAlarmSubtitle =>
      'Hacer sonar la alarma cuando se alcance el porcentaje objetivo';

  @override
  String get continuousAlarm => 'Alarma continua';

  @override
  String get continuousAlarmSubtitle =>
      'Seguir sonando hasta que se detenga manualmente';

  @override
  String get lowBatteryAlert => 'Alerta de batería baja';

  @override
  String get lowBatteryAlertSubtitle =>
      'Hacer sonar la alarma cuando la batería se esté agotando';

  @override
  String get lowBatteryWarning => 'Aviso de batería baja';

  @override
  String get guardianTitle => 'Guardián antirrobo';

  @override
  String get guardianSubtitle =>
      'Suena una sirena continua si se desconecta el cargador';

  @override
  String get guardianArmed => 'Guardián activado';

  @override
  String get guardianDisarmed => 'Guardián desactivado';

  @override
  String get guardianArmedStatus => 'ACTIVADO Y PROTEGIENDO';

  @override
  String get guardianDisarmedStatus => 'DESACTIVADO / EN ESPERA';

  @override
  String get armGuardian => 'Activar modo guardián';

  @override
  String get disarmGuardian => 'Desactivar modo guardián';

  @override
  String get guardianDescription =>
      'Mientras esté activado, si alguien desenchufa el cargador, sonará una sirena fuerte hasta que ingrese su PIN de 4 dígitos.';

  @override
  String get guardianDisarmPrompt =>
      'Ingrese su PIN de 4 dígitos para desactivar el modo guardián.';

  @override
  String get setPinTitle => 'Establecer PIN de seguridad';

  @override
  String get setPinPrompt =>
      'Cree un PIN de 4 dígitos para proteger el modo guardián.';

  @override
  String get confirmPin => 'Confirmar PIN de seguridad';

  @override
  String get enterPin => 'Ingrese PIN de 4 dígitos';

  @override
  String get wrongPin => 'PIN incorrecto. Inténtelo de nuevo.';

  @override
  String get pinsDoNotMatch => 'Los PIN no coinciden';

  @override
  String get savePin => 'Guardar PIN';

  @override
  String get theftAlarmActive => '¡ALARMA DE ROBO ACTIVA!';

  @override
  String get alarmRinging => '¡Alarma sonando!';

  @override
  String get theftAlarmSubtitle => '¡Cargador desconectado! Se requiere PIN.';

  @override
  String get targetReachedSubtitle => 'Objetivo alcanzado o alerta activa';

  @override
  String get stop => 'DETENER';

  @override
  String get disarm => 'DESARMAR';

  @override
  String get temperature => 'Temperatura';

  @override
  String get voltage => 'Voltaje';

  @override
  String get health => 'Salud';

  @override
  String get healthGood => 'Buena';

  @override
  String get plugged => 'Conectado';

  @override
  String get pluggedAc => 'Cargador CA';

  @override
  String get pluggedUsb => 'Puerto USB';

  @override
  String get pluggedWireless => 'Inalámbrico';

  @override
  String get pluggedNone => 'Desconectado';

  @override
  String get technology => 'Tecnología';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Predeterminado del sistema';

  @override
  String get language => 'Idioma';

  @override
  String get languageSelect => 'Seleccionar idioma';

  @override
  String get chargeHistory => 'Historial de carga';

  @override
  String get noHistory => 'Sin historial aún';

  @override
  String get clearHistory => 'Borrar historial';

  @override
  String get about => 'Acerca de';

  @override
  String get contribute => 'Contribuir';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get faq => 'Preguntas frecuentes';

  @override
  String get shareApp => 'Compartir aplicación';

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'Aceptar';

  @override
  String get voltEnergized => '✨ ¡Todos los sistemas operativos!';

  @override
  String get voltCharging =>
      '⚡ ¡Absorbiendo energía! ¡Flujo rápido y constante!';

  @override
  String get voltTargetReached =>
      '🎉 ¡Objetivo alcanzado! ¡Desenchufa para cuidar la batería!';

  @override
  String get voltLowBattery =>
      '🪫 Me estoy quedando sin energía... ¡dame poder!';

  @override
  String get voltOverheating => '🔥 ¡Estoy muy caliente! ¡Por favor dame aire!';

  @override
  String get voltGuardianArmed =>
      '🛡️ Guardián armado. ¡Desconectar activará la sirena!';

  @override
  String get voltTheftAlarm => '🚨 ¡ALERTA DE ROBO! ¡Detén la alarma!';

  @override
  String get quickFaqTitle => 'Preguntas frecuentes';

  @override
  String get faqWhyNoAlarm => '¿Por qué no sonó la alarma?';

  @override
  String get faqWhyNoAlarmDesc =>
      'Asegúrate de permitir la actividad en segundo plano, inicio automático y sonido en las notificaciones.';

  @override
  String get faqBackgroundActivity => 'Actividad en segundo plano';

  @override
  String get faqAutostart => 'Inicio automático';

  @override
  String get faqNotifications => 'Notificaciones';

  @override
  String get faqOemSettings => '¿Cómo permitir el inicio automático?';

  @override
  String get faqOemSettingsDesc =>
      'Diferentes marcas lo ubican en ajustes OEM (ej. Xiaomi/OPPO/Vivo). Usa el acceso directo superior.';

  @override
  String get replaySplashScreen => 'Repetir pantalla de bienvenida';

  @override
  String get introWalkthrough => 'Introducción y guía';

  @override
  String get armedCaps => 'ARMADO';

  @override
  String get idleCaps => 'INACTIVO';

  @override
  String get guardianSirenWarning =>
      'La sirena sonará y bloqueará la pantalla si se desconecta';

  @override
  String get guardianUnplugWarning =>
      'Hacer sonar la alarma si alguien desconecta el teléfono';

  @override
  String get protectedWithPin => '🔒 Protegido con PIN de 4 dígitos';

  @override
  String get changePin => 'Cambiar PIN';

  @override
  String get changeSecurityPin => 'Cambiar PIN de seguridad';

  @override
  String get pinUpdatedSuccess => '¡PIN de seguridad actualizado con éxito!';

  @override
  String get runningWarm => 'Caliente';

  @override
  String get nominalTemp => 'Temp. nominal';

  @override
  String get operatingWell => 'Buen estado';

  @override
  String get powerSource => 'Fuente de energía';

  @override
  String get activeInput => 'Entrada activa';

  @override
  String get disconnected => 'Desconectado';

  @override
  String get alertMeWhenReaches => 'Avisarme cuando la batería alcance:';

  @override
  String get enableAlarmSound => 'Activar sonido de alarma';

  @override
  String get continuousAlarmDesc =>
      'La alarma continuará hasta que desconectes o desactives';

  @override
  String get lowBatteryAlertDesc =>
      'Avisar cuando baje del objetivo durante la descarga';

  @override
  String get lowTarget => 'Objetivo bajo';

  @override
  String get allowBackgroundActivity => 'Permitir actividad en segundo plano';

  @override
  String get allowBackgroundActivityDesc =>
      'Abrir ajustes de batería: definir Sin restricciones / Permitir';

  @override
  String get autostartStartup => 'Inicio automático';

  @override
  String get autostartStartupDesc =>
      'Abrir ajustes OEM para permitir inicio con el sistema';

  @override
  String get notificationSettings => 'Ajustes de notificaciones';

  @override
  String get notificationSettingsDesc =>
      'Asegúrate de permitir alertas con sonido';

  @override
  String get stopAlarmNow => 'Detener alarma ahora';

  @override
  String get testAlarmNow => 'Probar alarma ahora';

  @override
  String get plugInChargerFirst =>
      '⚠️ ¡Conecte el cargador antes de armar el Modo Guardián!';

  @override
  String get guardianArmedSnack =>
      '🛡️ ¡Modo Guardián armado! Sonará alarma si se desenchufa.';

  @override
  String get guardianDisarmedSnack => 'Modo Guardián desarmado.';

  @override
  String targetReached(int pct) {
    return '¡Objetivo $pct% alcanzado!';
  }

  @override
  String targetLabel(int pct) {
    return 'Objetivo: $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '~${mins}m hasta $pct%';
  }

  @override
  String get aboutDesc =>
      'Te avisa cuando la batería alcanza el porcentaje elegido y cuando está baja.';

  @override
  String get keyFeatures => 'Características principales:';

  @override
  String get readPrivacyPolicy => 'Leer política de privacidad';

  @override
  String get contributeOnGitHub => 'Contribuir en GitHub';

  @override
  String get couldNotOpenBrowser => 'No se pudo abrir en el navegador';

  @override
  String get linkCopied => 'Enlace copiado';

  @override
  String get openInUpiApp => 'Abrir en aplicación UPI';

  @override
  String get couldNotOpenUpi =>
      'No se pudo abrir una aplicación UPI. Intenta escanear el QR o copia abajo.';

  @override
  String get upiIdCopied => 'ID de UPI copiado';

  @override
  String get upiIntentCopied => 'Intención UPI copiada';

  @override
  String get privacyAssurance =>
      'No recopilamos datos personales. La aplicación se ejecuta localmente en tu dispositivo.';

  @override
  String get openTooltip => 'Abrir';

  @override
  String get copyTooltip => 'Copiar';

  @override
  String get scanToContribute => 'Escanear para contribuir';

  @override
  String get scanUsingUpi => 'Escanear usando cualquier app UPI o lector';

  @override
  String get voltAwake => '⚡ ¡Volt está despierto! ¡Guardián listo!';

  @override
  String get voltCleanJuice =>
      '⚡ ¡Absorbiendo energía limpia! ¡El núcleo se siente genial!';

  @override
  String get voltFastFlow =>
      '🚀 Flujo rápido detectado. ¡Pronto estará al 100%!';

  @override
  String get voltHealthTip =>
      '💡 ¡Mantener la carga bajo el 85% cuida la salud de la batería!';

  @override
  String get voltPhoneCovered => '🛡️ ¡Guardián activo! ¡Yo cuido tu teléfono!';

  @override
  String get voltUnplugWarning =>
      '🚨 ¡Aviso: desconectar sin permiso activará la alarma fuerte!';

  @override
  String get voltAllHealthy =>
      '✨ ¡Celdas, voltaje y temperatura al 100% saludables!';

  @override
  String get voltGreetingCompanion =>
      '🤖 ¡Hola! Soy Volt, tu compañero guardián de batería.';

  @override
  String get voltStandingBy => '💚 ¡En guardia y supervisando tu dispositivo!';

  @override
  String get meetVolt => 'Conoce a Volt';

  @override
  String get meetVoltDesc =>
      'Tu compañero inteligente de batería. Volt vigila tu dispositivo y te mantiene al tanto.';

  @override
  String get tapVoltToSayHi => '👆 ¡Toca a Volt para saludar!';
}
