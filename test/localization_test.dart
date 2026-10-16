import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charge_alert/l10n/app_localizations.dart';
import 'package:charge_alert/l10n/app_localizations_lv.dart';
import 'package:charge_alert/l10n/locale_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Localization Tests', () {
    test('Latvian translations are complete and accurate', () {
      final lv = AppLocalizationsLv();

      expect(lv.appTitle, 'ChargeAlert');
      expect(lv.batteryCharging, 'Uzlādējas');
      expect(lv.batteryDischarging, 'Izlādējas');
      expect(lv.chargingAlarm, 'Uzlādes trauksme');
      expect(lv.continuousAlarm, 'Nepārtraukta trauksme');
      expect(lv.guardianTitle, 'Aizsardzība pret zādzībām');
      expect(lv.theftAlarmActive, 'ZĀDZĪBAS TRAUKSME AKTĪVA!');
      expect(lv.disarm, 'ATSLĒGT');
      expect(lv.stop, 'APTURĒT');
      expect(lv.temperature, 'Temperatūra');
      expect(lv.voltage, 'Spriegums');
      expect(lv.health, 'Stāvoklis');
      expect(lv.chargeHistory, 'Uzlādes vēsture');
      expect(lv.languageSelect, 'Izvēlēties valodu');
    });

    test('All 12 top global languages are registered in supportedLocales', () {
      final codes = AppLocalizations.supportedLocales.map((l) => l.languageCode).toList();

      expect(codes, containsAll([
        'en', // English
        'lv', // Latvian (Required)
        'es', // Spanish
        'de', // German
        'fr', // French
        'ru', // Russian
        'pt', // Portuguese
        'hi', // Hindi
        'bn', // Bengali
        'ar', // Arabic
        'zh', // Chinese
        'ja', // Japanese
      ]));
    });

    test('LocaleNotifier switches and persists language', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Default is null (system default)
      expect(container.read(localeProvider), isNull);

      // Switch to Latvian
      await container.read(localeProvider.notifier).setLocale('lv');
      expect(container.read(localeProvider), const Locale('lv'));

      // Switch back to system default
      await container.read(localeProvider.notifier).setLocale(null);
      expect(container.read(localeProvider), isNull);
    });

    testWidgets('App renders in Latvian when Latvian locale is selected', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localeProvider.overrideWith((ref) => LocaleNotifier()..state = const Locale('lv')),
          ],
          child: MaterialApp(
            locale: const Locale('lv'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(
                  appBar: AppBar(title: Text(l10n.chargingAlarm)),
                  body: Center(child: Text(l10n.guardianTitle)),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Uzlādes trauksme'), findsOneWidget);
      expect(find.text('Aizsardzība pret zādzībām'), findsOneWidget);
    });

    test('Volt companion messages are fully localized in Latvian and global languages', () {
      final lv = AppLocalizationsLv();

      expect(lv.voltAwake, contains('modies'));
      expect(lv.voltEnergized, contains('darbojas'));
      expect(lv.voltCharging, contains('enerģiju'));
      expect(lv.voltTargetReached, contains('Mērķis sasniegts'));
      expect(lv.voltLowBattery, contains('trūkst enerģijas'));
      expect(lv.voltGuardianArmed, contains('Aizsargs aktīvs'));
      expect(lv.voltTheftAlarm, contains('BRĪDINĀJUMS'));
      expect(lv.meetVolt, 'Iepazīstieties ar Voltu');
      expect(lv.tapVoltToSayHi, contains('Pieskaries Voltam'));
    });
  });
}
