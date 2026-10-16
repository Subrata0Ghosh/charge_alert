// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charge_alert/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Start-to-End Language Switching Test across 12 Languages on Emulator', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    await prefs.remove('selected_language_code');

    await tester.pumpWidget(
      const ProviderScope(
        child: ChargeAlertApp(),
      ),
    );

    // Allow splash page to mount
    await tester.pump(const Duration(milliseconds: 500));

    // Tap anywhere to skip splash screen immediately
    final gestureDetector = find.byType(GestureDetector);
    if (gestureDetector.evaluate().isNotEmpty) {
      await tester.tap(gestureDetector.first);
    }

    // Pump frames until Home screen appears
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 300));
      if (find.text('Guardian Anti-Theft').evaluate().isNotEmpty) break;
    }

    // Helper to select a language from the dialog modal by unique key
    Future<void> switchLanguage(String langCode) async {
      final langBtn = find.byIcon(Icons.language_rounded);
      expect(langBtn, findsOneWidget);
      await tester.tap(langBtn);
      await tester.pump(const Duration(milliseconds: 400));

      final itemFinder = find.byKey(Key('lang_$langCode'));
      final listFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(itemFinder, 50, scrollable: listFinder);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(itemFinder);
      await tester.pump(const Duration(milliseconds: 600));
    }

    // ==========================================
    // 1. ENGLISH (en) - Initial Verification
    // ==========================================
    expect(find.text('Guardian Anti-Theft'), findsOneWidget);
    expect(find.text('Battery Health'), findsOneWidget);
    expect(find.text('Alert me when battery reaches:'), findsOneWidget);
    expect(find.text('Enable Alarm Sound'), findsOneWidget);
    expect(find.text('Continuous Alarm'), findsOneWidget);
    print('>>> [1/13] English Initial Home Dashboard Verified.');

    // ==========================================
    // 2. LATVIAN (lv) - Primary Required Language Deep-Dive
    // ==========================================
    print('>>> [2/13] Switching to Latvian (Latviešu)...');
    await switchLanguage('lv');

    // Verify Home Screen in Latvian
    expect(find.text('Aizsardzība pret zādzībām'), findsOneWidget);
    expect(find.text('DĪKSTĀVE'), findsOneWidget);
    expect(find.text('Stāvoklis'), findsOneWidget);
    expect(find.text('Darbojas labi'), findsOneWidget);
    expect(find.text('Barošanas avots'), findsOneWidget);
    expect(find.text('Temperatūra'), findsOneWidget);
    expect(find.text('Spriegums'), findsOneWidget);
    expect(find.text('Brīdināt, kad akumulators sasniedz:'), findsOneWidget);
    expect(find.text('Ieslēgt trauksmes skaņu'), findsOneWidget);
    expect(find.text('Nepārtraukta trauksme'), findsOneWidget);
    expect(find.text('Zema uzlādes līmeņa trauksme'), findsOneWidget);
    expect(find.text('Zemais mērķis'), findsOneWidget);
    expect(find.text('Atļaut fona darbību'), findsOneWidget);
    expect(find.text('Automātiskā palaišana'), findsOneWidget);
    expect(find.text('Paziņojumu iestatījumi'), findsOneWidget);
    expect(find.text('Pārbaudīt trauksmi tūlīt'), findsOneWidget);

    // Verify 3-Dot Menu in Latvian
    final popupMenu = find.byType(PopupMenuButton<String>);
    expect(popupMenu, findsOneWidget);
    await tester.tap(popupMenu);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Valoda: 🌐'), findsOneWidget);
    expect(find.text('Motīvs'), findsOneWidget);
    expect(find.text('Atkārtot sākuma ekrānu'), findsOneWidget);
    expect(find.text('Ievads un ceļvedis'), findsOneWidget);
    expect(find.text('Uzlādes vēsture'), findsOneWidget);
    expect(find.text('Par lietotni'), findsOneWidget);
    expect(find.text('Atbalstīt'), findsOneWidget);
    expect(find.text('Privātuma politika'), findsOneWidget);
    expect(find.text('Biežāk uzdotie jautājumi'), findsOneWidget);
    expect(find.text('Kopīgot lietotni'), findsOneWidget);

    // Open FAQ BottomSheet in Latvian
    await tester.tap(find.text('Biežāk uzdotie jautājumi'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Biežāk uzdotie jautājumi'), findsWidgets);
    expect(find.text('Fona darbība'), findsOneWidget);
    expect(find.text('Automātiskā palaišana'), findsWidgets);

    // Dismiss FAQ modal
    Navigator.of(tester.element(find.text('Fona darbība'))).pop();
    await tester.pump(const Duration(milliseconds: 600));

    // Verify Latvian About Page
    await tester.tap(popupMenu);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Par lietotni'));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Par lietotni'), findsWidgets);
    expect(find.text('Galvenās funkcijas:'), findsOneWidget);
    expect(find.text('Lasīt privātuma politiku'), findsOneWidget);
    expect(find.text('Piedalīties GitHub'), findsOneWidget);

    Navigator.of(tester.element(find.text('Galvenās funkcijas:'))).pop();
    await tester.pump(const Duration(milliseconds: 600));

    // Verify Latvian Contribute Page
    await tester.tap(popupMenu);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Atbalstīt'));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Atbalstīt'), findsWidgets);
    expect(find.text('Skenējiet, lai atbalstītu'), findsOneWidget);
    expect(find.text('Atvērt UPI lietotnē'), findsOneWidget);
    expect(find.text('UPI ID'), findsOneWidget);

    Navigator.of(tester.element(find.text('Skenējiet, lai atbalstītu'))).pop();
    await tester.pump(const Duration(milliseconds: 600));
    print('>>> [2/13] Latvian 100% Full UI Check PASSED (Dashboard, Popup, FAQ, About, Contribute).');

    // ==========================================
    // 3. SPANISH (es)
    // ==========================================
    print('>>> [3/13] Switching to Spanish (Español)...');
    await switchLanguage('es');
    expect(find.text('Temperatura'), findsOneWidget);
    expect(find.text('Avisarme cuando la batería alcance:'), findsOneWidget);
    expect(find.text('Activar sonido de alarma'), findsOneWidget);
    expect(find.text('Alarma continua'), findsOneWidget);
    expect(find.text('Probar alarma ahora'), findsOneWidget);
    print('>>> [3/13] Spanish Dashboard Verified.');

    // ==========================================
    // 4. GERMAN (de)
    // ==========================================
    print('>>> [4/13] Switching to German (Deutsch)...');
    await switchLanguage('de');
    expect(find.text('Temperatur'), findsOneWidget);
    expect(find.text('Benachrichtigen, wenn Akku erreicht:'), findsOneWidget);
    expect(find.text('Alarmton aktivieren'), findsOneWidget);
    expect(find.text('Daueralarm'), findsOneWidget);
    expect(find.text('Alarm jetzt testen'), findsOneWidget);
    print('>>> [4/13] German Dashboard Verified.');

    // ==========================================
    // 5. FRENCH (fr)
    // ==========================================
    print('>>> [5/13] Switching to French (Français)...');
    await switchLanguage('fr');
    expect(find.text('Température'), findsOneWidget);
    expect(find.text("M'alerter quand la batterie atteint :"), findsOneWidget);
    expect(find.text("Activer le son de l'alarme"), findsOneWidget);
    expect(find.text('Alarme continue'), findsOneWidget);
    expect(find.text("Tester l'alarme maintenant"), findsOneWidget);
    print('>>> [5/13] French Dashboard Verified.');

    // ==========================================
    // 6. RUSSIAN (ru)
    // ==========================================
    print('>>> [6/13] Switching to Russian (Русский)...');
    await switchLanguage('ru');
    expect(find.text('Температура'), findsOneWidget);
    expect(find.text('Оповестить при достижении:'), findsOneWidget);
    expect(find.text('Включить звук будильника'), findsOneWidget);
    expect(find.text('Непрерывный сигнал'), findsOneWidget);
    expect(find.text('Проверить тревогу сейчас'), findsOneWidget);
    print('>>> [6/13] Russian Dashboard Verified.');

    // ==========================================
    // 7. PORTUGUESE (pt)
    // ==========================================
    print('>>> [7/13] Switching to Portuguese (Português)...');
    await switchLanguage('pt');
    expect(find.text('Temperatura'), findsOneWidget);
    expect(find.text('Avisar quando a bateria atingir:'), findsOneWidget);
    expect(find.text('Ativar som de alarme'), findsOneWidget);
    expect(find.text('Alarme contínuo'), findsOneWidget);
    expect(find.text('Testar alarme agora'), findsOneWidget);
    print('>>> [7/13] Portuguese Dashboard Verified.');

    // ==========================================
    // 8. HINDI (hi)
    // ==========================================
    print('>>> [8/13] Switching to Hindi (हिन्दी)...');
    await switchLanguage('hi');
    expect(find.text('तापमान'), findsOneWidget);
    expect(find.text('बैटरी इस स्तर पर पहुंचने पर अलर्ट करें:'), findsOneWidget);
    expect(find.text('अलार्म ध्वनि सक्षम करें'), findsOneWidget);
    expect(find.text('लगातार अलार्म'), findsOneWidget);
    expect(find.text('अलार्म का परीक्षण करें'), findsOneWidget);
    print('>>> [8/13] Hindi Dashboard Verified.');

    // ==========================================
    // 9. BENGALI (bn)
    // ==========================================
    print('>>> [9/13] Switching to Bengali (বাংলা)...');
    await switchLanguage('bn');
    expect(find.text('তাপমাত্রা'), findsOneWidget);
    expect(find.text('ব্যাটারি এই স্তরে পৌঁছালে সতর্ক করুন:'), findsOneWidget);
    expect(find.text('অ্যালার্ম সাউন্ড চালু করুন'), findsOneWidget);
    expect(find.text('একটানা অ্যালার্ম'), findsOneWidget);
    expect(find.text('এখনই অ্যালার্ম পরীক্ষা করুন'), findsOneWidget);
    print('>>> [9/13] Bengali Dashboard Verified.');

    // ==========================================
    // 10. ARABIC (ar)
    // ==========================================
    print('>>> [10/13] Switching to Arabic (العربية)...');
    await switchLanguage('ar');
    expect(find.text('درجة الحرارة'), findsOneWidget);
    expect(find.text('تنبيهي عندما تصل البطارية إلى:'), findsOneWidget);
    expect(find.text('تفعيل صوت المنبه'), findsOneWidget);
    expect(find.text('منبه مستمر'), findsOneWidget);
    expect(find.text('اختبار المنبه الآن'), findsOneWidget);
    print('>>> [10/13] Arabic Dashboard Verified.');

    // ==========================================
    // 11. CHINESE (zh)
    // ==========================================
    print('>>> [11/13] Switching to Chinese (简体中文)...');
    await switchLanguage('zh');
    expect(find.text('温度'), findsOneWidget);
    expect(find.text('电量达到以下值时提醒我：'), findsOneWidget);
    expect(find.text('启用报警声音'), findsOneWidget);
    expect(find.text('持续警报'), findsOneWidget);
    expect(find.text('立即测试警报'), findsOneWidget);
    print('>>> [11/13] Chinese Dashboard Verified.');

    // ==========================================
    // 12. JAPANESE (ja)
    // ==========================================
    print('>>> [12/13] Switching to Japanese (日本語)...');
    await switchLanguage('ja');
    expect(find.text('温度'), findsOneWidget);
    expect(find.text('バッテリーが次に達したら通知：'), findsOneWidget);
    expect(find.text('アラーム音を有効にする'), findsOneWidget);
    expect(find.text('連続アラーム'), findsOneWidget);
    expect(find.text('今すぐアラームをテスト'), findsOneWidget);
    print('>>> [12/13] Japanese Dashboard Verified.');

    // ==========================================
    // 13. RESTORE TO ENGLISH (en)
    // ==========================================
    print('>>> [13/13] Switching back to English...');
    await switchLanguage('en');
    expect(find.text('Guardian Anti-Theft'), findsOneWidget);
    expect(find.text('Battery Health'), findsOneWidget);
    expect(find.text('Alert me when battery reaches:'), findsOneWidget);
    expect(find.text('Enable Alarm Sound'), findsOneWidget);
    print('>>> [ALL SUCCESS] Full End-to-End Multilingual UI Switch verified across all 12 languages on emulator!');
  });
}
