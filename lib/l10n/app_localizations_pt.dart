// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'Carregamento inteligente e sentinela da bateria';

  @override
  String get batteryLevel => 'Nível da bateria';

  @override
  String get batteryCharging => 'Carregando';

  @override
  String get batteryDischarging => 'Descarregando';

  @override
  String get batteryFull => 'Cheia';

  @override
  String get batteryNotCharging => 'Não está carregando';

  @override
  String get batteryUnknown => 'Desconhecido';

  @override
  String get hyperCharging => 'CARGA RÁPIDA';

  @override
  String get batteryFullCaps => 'BATERIA CHEIA';

  @override
  String get dischargingCaps => 'DESCARREGANDO';

  @override
  String get targetAlertLimit => 'Limite de alerta desejado';

  @override
  String get targetAlertSubtitle =>
      'O alarme toca quando a bateria atinge esta porcentagem';

  @override
  String get chargingAlarm => 'Alarme de carga';

  @override
  String get chargingAlarmSubtitle =>
      'Tocar alarme quando atingir a porcentagem desejada';

  @override
  String get continuousAlarm => 'Alarme contínuo';

  @override
  String get continuousAlarmSubtitle =>
      'Continuar tocando até ser interrompido manualmente';

  @override
  String get lowBatteryAlert => 'Alerta de bateria fraca';

  @override
  String get lowBatteryAlertSubtitle =>
      'Tocar alarme quando a bateria estiver acabando';

  @override
  String get lowBatteryWarning => 'Aviso de bateria fraca';

  @override
  String get guardianTitle => 'Guardião antirroubo';

  @override
  String get guardianSubtitle =>
      'Dispara sirene contínua se o carregador for desconectado';

  @override
  String get guardianArmed => 'Guardião ativado';

  @override
  String get guardianDisarmed => 'Guardião desativado';

  @override
  String get guardianArmedStatus => 'ATIVADO E PROTEGENDO';

  @override
  String get guardianDisarmedStatus => 'DESATIVADO / EM ESPERA';

  @override
  String get armGuardian => 'Ativar modo guardião';

  @override
  String get disarmGuardian => 'Desativar modo guardião';

  @override
  String get guardianDescription =>
      'Quando ativado, se alguém desconectar seu carregador, uma sirene alta tocará até que você digite seu PIN de 4 dígitos.';

  @override
  String get guardianDisarmPrompt =>
      'Digite seu PIN de 4 dígitos para desativar o modo guardião.';

  @override
  String get setPinTitle => 'Definir PIN de segurança';

  @override
  String get setPinPrompt =>
      'Crie um PIN de 4 dígitos para proteger o modo guardião.';

  @override
  String get confirmPin => 'Confirmar PIN de segurança';

  @override
  String get enterPin => 'Digite o PIN de 4 dígitos';

  @override
  String get wrongPin => 'PIN incorreto. Tente novamente.';

  @override
  String get pinsDoNotMatch => 'Os PINs não coincidem';

  @override
  String get savePin => 'Salvar PIN';

  @override
  String get theftAlarmActive => 'ALARME DE ROUBO ATIVO!';

  @override
  String get alarmRinging => 'Alarme tocando!';

  @override
  String get theftAlarmSubtitle => 'Carregador desconectado! PIN necessário.';

  @override
  String get targetReachedSubtitle => 'Meta atingida ou alerta ativo';

  @override
  String get stop => 'PARAR';

  @override
  String get disarm => 'DESARMAR';

  @override
  String get temperature => 'Temperatura';

  @override
  String get voltage => 'Voltagem';

  @override
  String get health => 'Saúde';

  @override
  String get healthGood => 'Boa';

  @override
  String get plugged => 'Conectado';

  @override
  String get pluggedAc => 'Carregador CA';

  @override
  String get pluggedUsb => 'Porta USB';

  @override
  String get pluggedWireless => 'Sem fio';

  @override
  String get pluggedNone => 'Desconectado';

  @override
  String get technology => 'Tecnologia';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeSystem => 'Padrão do sistema';

  @override
  String get language => 'Idioma';

  @override
  String get languageSelect => 'Selecionar idioma';

  @override
  String get chargeHistory => 'Histórico de carga';

  @override
  String get noHistory => 'Nenhum histórico ainda';

  @override
  String get clearHistory => 'Limpar histórico';

  @override
  String get about => 'Sobre';

  @override
  String get contribute => 'Contribuir';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get faq => 'Perguntas frequentes';

  @override
  String get shareApp => 'Compartilhar aplicativo';

  @override
  String get close => 'Fechar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get voltEnergized => '✨ Todos os sistemas operacionais!';

  @override
  String get voltCharging => '⚡ Absorvendo energia! Fluxo rápido e estável!';

  @override
  String get voltTargetReached =>
      '🎉 Meta atingida! Desconecte para preservar a bateria!';

  @override
  String get voltLowBattery => '🪫 Energia acabando... preciso de carga!';

  @override
  String get voltOverheating =>
      '🔥 Estou esquentando! Por favor, deixe-me esfriar!';

  @override
  String get voltGuardianArmed =>
      '🛡️ Guardião ativo. Desconectar ativará a sirene!';

  @override
  String get voltTheftAlarm => '🚨 ALERTA DE ROUBO! Pare o alarme!';

  @override
  String get quickFaqTitle => 'Perguntas rápidas';

  @override
  String get faqWhyNoAlarm => 'Por que o alarme não tocou?';

  @override
  String get faqWhyNoAlarmDesc =>
      'Certifique-se de permitir atividade em segundo plano, início automático e som nas notificações.';

  @override
  String get faqBackgroundActivity => 'Atividade em segundo plano';

  @override
  String get faqAutostart => 'Início automático';

  @override
  String get faqNotifications => 'Notificações';

  @override
  String get faqOemSettings => 'Como permitir início automático?';

  @override
  String get faqOemSettingsDesc =>
      'Alguns fabricantes exigem configuração nas opções do sistema (Xiaomi/OPPO/Vivo).';

  @override
  String get replaySplashScreen => 'Repetir tela de início';

  @override
  String get introWalkthrough => 'Introdução e guia';

  @override
  String get armedCaps => 'ARMADO';

  @override
  String get idleCaps => 'INATIVO';

  @override
  String get guardianSirenWarning =>
      'A sirene tocará e a tela será bloqueada se desconectado';

  @override
  String get guardianUnplugWarning =>
      'Tocar alarme se alguém desconectar o telefone';

  @override
  String get protectedWithPin => '🔒 Protegido com PIN de 4 dígitos';

  @override
  String get changePin => 'Alterar PIN';

  @override
  String get changeSecurityPin => 'Alterar PIN de segurança';

  @override
  String get pinUpdatedSuccess => 'PIN de segurança atualizado com sucesso!';

  @override
  String get runningWarm => 'Aquecendo';

  @override
  String get nominalTemp => 'Temp. normal';

  @override
  String get operatingWell => 'Funcionando bem';

  @override
  String get powerSource => 'Fonte de energia';

  @override
  String get activeInput => 'Entrada ativa';

  @override
  String get disconnected => 'Desconectado';

  @override
  String get alertMeWhenReaches => 'Avisar quando a bateria atingir:';

  @override
  String get enableAlarmSound => 'Ativar som de alarme';

  @override
  String get continuousAlarmDesc =>
      'O alarme continuará até você desconectar ou desativar';

  @override
  String get lowBatteryAlertDesc =>
      'Avisar quando a bateria ficar abaixo da meta ao descarregar';

  @override
  String get lowTarget => 'Meta baixa';

  @override
  String get allowBackgroundActivity => 'Permitir atividade em segundo plano';

  @override
  String get allowBackgroundActivityDesc =>
      'Abrir configurações de bateria: definir Sem restrições';

  @override
  String get autostartStartup => 'Início automático';

  @override
  String get autostartStartupDesc =>
      'Abrir página de início OEM para permitir ao inicializar';

  @override
  String get notificationSettings => 'Configurações de notificações';

  @override
  String get notificationSettingsDesc =>
      'Certifique-se de que os alertas sonoros são permitidos';

  @override
  String get stopAlarmNow => 'Parar alarme agora';

  @override
  String get testAlarmNow => 'Testar alarme agora';

  @override
  String get plugInChargerFirst =>
      '⚠️ Conecte o carregador antes de armar o Modo Guardião!';

  @override
  String get guardianArmedSnack =>
      '🛡️ Modo Guardião armado! O alarme tocará se desconectado.';

  @override
  String get guardianDisarmedSnack => 'Modo Guardião desarmado.';

  @override
  String targetReached(int pct) {
    return 'Meta de $pct% atingida!';
  }

  @override
  String targetLabel(int pct) {
    return 'Meta: $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '~${mins}m até $pct%';
  }

  @override
  String get aboutDesc =>
      'Avisa quando a bateria atinge a porcentagem escolhida e quando está fraca.';

  @override
  String get keyFeatures => 'Recursos principais:';

  @override
  String get readPrivacyPolicy => 'Ler política de privacidade';

  @override
  String get contributeOnGitHub => 'Contribuir no GitHub';

  @override
  String get couldNotOpenBrowser => 'Não foi possível abrir no navegador';

  @override
  String get linkCopied => 'Link copiado';

  @override
  String get openInUpiApp => 'Abrir no aplicativo UPI';

  @override
  String get couldNotOpenUpi =>
      'Não foi possível abrir o app UPI. Escaneie o QR ou copie abaixo.';

  @override
  String get upiIdCopied => 'ID UPI copiado';

  @override
  String get upiIntentCopied => 'Intenção UPI copiada';

  @override
  String get privacyAssurance =>
      'Não coletamos dados pessoais. O aplicativo é executado localmente em seu dispositivo.';

  @override
  String get openTooltip => 'Abrir';

  @override
  String get copyTooltip => 'Copiar';

  @override
  String get scanToContribute => 'Escanear para apoiar';

  @override
  String get scanUsingUpi => 'Escanear com qualquer app UPI ou câmera';

  @override
  String get voltAwake => '⚡ O Volt acordou! Guardião da bateria pronto!';

  @override
  String get voltCleanJuice =>
      '⚡ Absorvendo energia limpa! O núcleo da bateria está ótimo!';

  @override
  String get voltFastFlow =>
      '🚀 Carga rápida detectada. Em breve estaremos carregados!';

  @override
  String get voltHealthTip =>
      '💡 Manter a carga abaixo de 85% preserva a vida útil da bateria!';

  @override
  String get voltPhoneCovered =>
      '🛡️ Guardião ativo! Eu cuido do seu telefone!';

  @override
  String get voltUnplugWarning =>
      '🚨 Aviso: desconectar sem autorização dispara a sirene!';

  @override
  String get voltAllHealthy =>
      '✨ Células, voltagem e temperatura 100% saudáveis!';

  @override
  String get voltGreetingCompanion =>
      '🤖 Olá! Eu sou o Volt, seu guardião de bateria pessoal!';

  @override
  String get voltStandingBy => '💚 Sempre a postos cuidando do seu aparelho!';

  @override
  String get meetVolt => 'Conheça o Volt';

  @override
  String get meetVoltDesc =>
      'Seu companheiro inteligente de bateria. O Volt cuida do seu dispositivo e mantém você informado.';

  @override
  String get tapVoltToSayHi => '👆 Toque no Volt para dar um olá!';
}
