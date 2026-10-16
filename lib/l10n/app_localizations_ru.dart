// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'ChargeAlert';

  @override
  String get appSubtitle => 'Умная зарядка и страж батареи';

  @override
  String get batteryLevel => 'Уровень заряда';

  @override
  String get batteryCharging => 'Заряжается';

  @override
  String get batteryDischarging => 'Разряжается';

  @override
  String get batteryFull => 'Полный';

  @override
  String get batteryNotCharging => 'Не заряжается';

  @override
  String get batteryUnknown => 'Неизвестно';

  @override
  String get hyperCharging => 'БЫСТРАЯ ЗАРЯДКА';

  @override
  String get batteryFullCaps => 'БАТАРЕЯ ПОЛНАЯ';

  @override
  String get dischargingCaps => 'РАЗРЯЖАЕТСЯ';

  @override
  String get targetAlertLimit => 'Целевой уровень заряда';

  @override
  String get targetAlertSubtitle =>
      'Сигнал прозвучит при достижении этого процента';

  @override
  String get chargingAlarm => 'Сигнал зарядки';

  @override
  String get chargingAlarmSubtitle =>
      'Подавать сигнал при достижении целевого процента';

  @override
  String get continuousAlarm => 'Непрерывный сигнал';

  @override
  String get continuousAlarmSubtitle => 'Звонить до ручного отключения';

  @override
  String get lowBatteryAlert => 'Сигнал низкого заряда';

  @override
  String get lowBatteryAlertSubtitle =>
      'Подавать сигнал, когда батарея садится';

  @override
  String get lowBatteryWarning => 'Низкий заряд батареи';

  @override
  String get guardianTitle => 'Антивор страж';

  @override
  String get guardianSubtitle =>
      'Включает громкую сирену при отключении зарядки';

  @override
  String get guardianArmed => 'Страж включен';

  @override
  String get guardianDisarmed => 'Страж отключен';

  @override
  String get guardianArmedStatus => 'АКТИВЕН И ЗАЩИЩАЕТ';

  @override
  String get guardianDisarmedStatus => 'ОТКЛЮЧЕН / ОЖИДАНИЕ';

  @override
  String get armGuardian => 'Включить защиту';

  @override
  String get disarmGuardian => 'Отключить защиту';

  @override
  String get guardianDescription =>
      'Если кто-то выдернет зарядку, включится громкая сирена, пока вы не введете 4-значный PIN.';

  @override
  String get guardianDisarmPrompt =>
      'Введите 4-значный PIN для отключения режима защиты.';

  @override
  String get setPinTitle => 'Установить PIN';

  @override
  String get setPinPrompt => 'Создайте 4-значный PIN для защиты режима стража.';

  @override
  String get confirmPin => 'Подтвердите PIN';

  @override
  String get enterPin => 'Введите 4-значный PIN';

  @override
  String get wrongPin => 'Неверный PIN. Попробуйте снова.';

  @override
  String get pinsDoNotMatch => 'PIN-коды не совпадают';

  @override
  String get savePin => 'Сохранить PIN';

  @override
  String get theftAlarmActive => 'СИГНАЛ ТРЕВОГИ: АНТИВОР!';

  @override
  String get alarmRinging => 'Звенит будильник!';

  @override
  String get theftAlarmSubtitle => 'Зарядка отключена! Требуется PIN.';

  @override
  String get targetReachedSubtitle => 'Цель достигнута или активна тревога';

  @override
  String get stop => 'СТОП';

  @override
  String get disarm => 'ОТКЛЮЧИТЬ';

  @override
  String get temperature => 'Температура';

  @override
  String get voltage => 'Напряжение';

  @override
  String get health => 'Состояние';

  @override
  String get healthGood => 'Хорошее';

  @override
  String get plugged => 'Подключено';

  @override
  String get pluggedAc => 'Сетевая зарядка';

  @override
  String get pluggedUsb => 'USB порт';

  @override
  String get pluggedWireless => 'Беспроводная';

  @override
  String get pluggedNone => 'Отключено';

  @override
  String get technology => 'Технология';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Темная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get language => 'Язык';

  @override
  String get languageSelect => 'Выбрать язык';

  @override
  String get chargeHistory => 'История зарядки';

  @override
  String get noHistory => 'Истории пока нет';

  @override
  String get clearHistory => 'Очистить историю';

  @override
  String get about => 'О приложении';

  @override
  String get contribute => 'Поддержать';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get faq => 'Частые вопросы';

  @override
  String get shareApp => 'Поделиться';

  @override
  String get close => 'Закрыть';

  @override
  String get cancel => 'Отмена';

  @override
  String get ok => 'ОК';

  @override
  String get voltEnergized => '✨ Все системы работают отлично!';

  @override
  String get voltCharging => '⚡ Заряжаюсь энергией! Быстрый и плавный ток!';

  @override
  String get voltTargetReached =>
      '🎉 Цель достигнута! Отключите зарядку для здоровья батареи!';

  @override
  String get voltLowBattery =>
      '🪫 Заканчивается заряд... накормите меня энергией!';

  @override
  String get voltOverheating => '🔥 Мне горячо! Дайте немного остыть!';

  @override
  String get voltGuardianArmed =>
      '🛡️ Страж наготове. Отключение вызовет сирену!';

  @override
  String get voltTheftAlarm => '🚨 ТРЕВОГА! Остановите сигнализацию!';

  @override
  String get quickFaqTitle => 'Частые вопросы';

  @override
  String get faqWhyNoAlarm => 'Почему не сработал сигнал?';

  @override
  String get faqWhyNoAlarmDesc =>
      'Убедитесь, что разрешена фоновая активность, включен автозапуск и включен звук уведомлений.';

  @override
  String get faqBackgroundActivity => 'Фоновая активность';

  @override
  String get faqAutostart => 'Автозапуск';

  @override
  String get faqNotifications => 'Уведомления';

  @override
  String get faqOemSettings => 'Как включить автозапуск?';

  @override
  String get faqOemSettingsDesc =>
      'На смартфонах Xiaomi/OPPO/Vivo это настраивается в параметрах приложений.';

  @override
  String get replaySplashScreen => 'Повторить заставку';

  @override
  String get introWalkthrough => 'Введение и руководство';

  @override
  String get armedCaps => 'АКТИВЕН';

  @override
  String get idleCaps => 'ОЖИДАНИЕ';

  @override
  String get guardianSirenWarning =>
      'Включится сирена и заблокируется экран при отключении';

  @override
  String get guardianUnplugWarning =>
      'Сигнал тревоги, если кто-то отключит телефон';

  @override
  String get protectedWithPin => '🔒 Защищено 4-значным PIN-кодом';

  @override
  String get changePin => 'Изменить PIN';

  @override
  String get changeSecurityPin => 'Изменить защитный PIN-код';

  @override
  String get pinUpdatedSuccess => 'Защитный PIN-код успешно обновлен!';

  @override
  String get runningWarm => 'Нагрев';

  @override
  String get nominalTemp => 'Нормальная темп.';

  @override
  String get operatingWell => 'Работает хорошо';

  @override
  String get powerSource => 'Источник питания';

  @override
  String get activeInput => 'Подключено';

  @override
  String get disconnected => 'Отключено';

  @override
  String get alertMeWhenReaches => 'Оповестить при достижении:';

  @override
  String get enableAlarmSound => 'Включить звук будильника';

  @override
  String get continuousAlarmDesc =>
      'Сигнал звучит до отключения питания или выключения';

  @override
  String get lowBatteryAlertDesc =>
      'Оповещать, если уровень падает ниже порога';

  @override
  String get lowTarget => 'Нижний порог';

  @override
  String get allowBackgroundActivity => 'Разрешить работу в фоне';

  @override
  String get allowBackgroundActivityDesc =>
      'Открыть настройки батареи: выбрать Без ограничений / Разрешить';

  @override
  String get autostartStartup => 'Автозапуск / Запуск';

  @override
  String get autostartStartupDesc =>
      'Открыть OEM-настройки автозапуска при загрузке устройства';

  @override
  String get notificationSettings => 'Настройки уведомлений';

  @override
  String get notificationSettingsDesc =>
      'Убедитесь, что оповещения со звуком разрешены';

  @override
  String get stopAlarmNow => 'Остановить тревогу сейчас';

  @override
  String get testAlarmNow => 'Проверить тревогу сейчас';

  @override
  String get plugInChargerFirst =>
      '⚠️ Подключите зарядное устройство перед включением режима Стража!';

  @override
  String get guardianArmedSnack =>
      '🛡️ Режим Стража активен! Сигнал сработает при отключении.';

  @override
  String get guardianDisarmedSnack => 'Режим Стража отключен.';

  @override
  String targetReached(int pct) {
    return 'Цель $pct% достигнута!';
  }

  @override
  String targetLabel(int pct) {
    return 'Цель: $pct%';
  }

  @override
  String timeToTarget(int mins, int pct) {
    return '~$mins мин до $pct%';
  }

  @override
  String get aboutDesc =>
      'Оповещает при достижении заданного процента и при низком заряде.';

  @override
  String get keyFeatures => 'Ключевые особенности:';

  @override
  String get readPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get contributeOnGitHub => 'Внести вклад на GitHub';

  @override
  String get couldNotOpenBrowser => 'Не удалось открыть в браузере';

  @override
  String get linkCopied => 'Ссылка скопирована';

  @override
  String get openInUpiApp => 'Открыть в приложении UPI';

  @override
  String get couldNotOpenUpi =>
      'Не удалось открыть приложение UPI. Отсканируйте QR или скопируйте ниже.';

  @override
  String get upiIdCopied => 'UPI ID скопирован';

  @override
  String get upiIntentCopied => 'UPI intent скопирован';

  @override
  String get privacyAssurance =>
      'Мы не собираем личные данные. Приложение работает локально на вашем устройстве.';

  @override
  String get openTooltip => 'Открыть';

  @override
  String get copyTooltip => 'Копировать';

  @override
  String get scanToContribute => 'Сканируйте для поддержки';

  @override
  String get scanUsingUpi => 'Сканируйте через приложение UPI или камеру';

  @override
  String get voltAwake => '⚡ Вольт проснулся! Страж батареи готов!';

  @override
  String get voltCleanJuice => '⚡ Чистая энергия поступает! Батарея в порядке!';

  @override
  String get voltFastFlow => '🚀 Быстрая зарядка! Скоро будем полны энергии!';

  @override
  String get voltHealthTip =>
      '💡 Зарядка до 85% продлевает срок службы батареи!';

  @override
  String get voltPhoneCovered => '🛡️ Защита активна! Я охраняю твой телефон!';

  @override
  String get voltUnplugWarning =>
      '🚨 Внимание: при отключении сработает громкая сирена!';

  @override
  String get voltAllHealthy => '✨ Элементы, напряжение и температура в норме!';

  @override
  String get voltGreetingCompanion =>
      '🤖 Привет! Я Вольт, твой личный страж батареи!';

  @override
  String get voltStandingBy => '💚 Всегда на страже твоего устройства!';

  @override
  String get meetVolt => 'Познакомьтесь с Вольтом';

  @override
  String get meetVoltDesc =>
      'Ваш умный спутник батареи. Вольт следит за устройством и сообщает обо всем важном.';

  @override
  String get tapVoltToSayHi => '👆 Нажмите на Вольта, чтобы поздороваться!';
}
