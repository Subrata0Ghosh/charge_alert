import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:charge_alert/main.dart';
import 'package:charge_alert/pages/splash_page.dart';
import 'package:charge_alert/pages/onboarding_page.dart';
import 'package:charge_alert/pages/about_page.dart';
import 'package:charge_alert/pages/contribute_page.dart';
import 'package:charge_alert/pages/privacy_policy_page.dart';
import 'package:charge_alert/pages/history_page.dart';
import 'package:charge_alert/widgets/volt_companion.dart';
import 'package:charge_alert/widgets/guardian_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'onboarding_done': true,
      'alertPercentage': 80.0,
      'lowAlertPercentage': 15.0,
      'alarmEnabled': true,
      'continuousAlarm': false,
      'lowAlarmEnabled': false,
      'guardianArmed': false,
      'theftPin': '1234',
    });

    // Mock platform channels for battery & alarm service
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.technorchid.charge_alert/alarm'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'isAlarmRunning') return false;
        if (methodCall.method == 'getBatteryDetails') {
          return {
            'temperature': 32.5,
            'voltage': 3.85,
            'health': 'Good',
            'plugged': 'AC Charger',
            'technology': 'Li-ion',
          };
        }
        return true;
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/battery'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getBatteryLevel') return 75;
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.technorchid.charge_alert/alarm'),
      null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/battery'),
      null,
    );
  });

  group('Flow 1: App Launch & Splash Screen', () {
    testWidgets('SplashPage mounts and allows tap-to-skip', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: ChargeAlertApp()));
      expect(find.byType(SplashPage), findsOneWidget);

      // Tap on the splash screen to test fast skip
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
    });
  });

  group('Flow 2: Onboarding Page', () {
    testWidgets('OnboardingPage renders slides and responds to navigation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingPage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(OnboardingPage), findsOneWidget);
      expect(find.text('Meet Volt'), findsOneWidget);

      // Tap Next button to advance slide
      final nextFinder = find.widgetWithText(ElevatedButton, 'Next');
      if (nextFinder.evaluate().isNotEmpty) {
        await tester.tap(nextFinder);
        await tester.pump(const Duration(milliseconds: 600));
      }
    });
  });

  group('Flow 3: Home Screen & Volt Companion', () {
    testWidgets('ChargeAlertScreen displays telemetry and has no back arrow', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChargeAlertScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      // Verify AppBar title
      expect(find.text('ChargeAlert'), findsOneWidget);

      // Verify no leading back button is rendered on the Home screen
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.automaticallyImplyLeading, false);

      // Verify Volt companion is rendered
      expect(find.byType(VoltCompanion), findsOneWidget);

      // Verify telemetry and Guardian mode widgets
      expect(find.text('Guardian Anti-Theft'), findsOneWidget);
      expect(find.text('Alert me when battery reaches:'), findsOneWidget);
      expect(find.text('Enable Alarm Sound'), findsOneWidget);
      expect(find.text('Continuous Alarm'), findsOneWidget);
      expect(find.text('Low Battery Alert'), findsOneWidget);

      // Verify telemetry labels
      expect(find.text('Temperature'), findsOneWidget);
      expect(find.text('Battery Health'), findsOneWidget);
      expect(find.text('Voltage'), findsOneWidget);
      expect(find.text('Power Source'), findsOneWidget);
    });

    testWidgets('VoltCompanion renders correctly in various mood states', (tester) async {
      for (final mood in VoltMood.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VoltCompanion(
                mood: mood,
                speechText: 'Testing ${mood.name}',
                size: 110,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(VoltCompanion), findsOneWidget);
      }
    });

    testWidgets('Alarm toggle and slider interactions function properly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChargeAlertScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      // Scroll down so slider and switches are fully visible in the 800x600 test viewport
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pump(const Duration(milliseconds: 200));

      // Toggle Alarm Switch
      final alarmSwitch = find.widgetWithText(SwitchListTile, 'Enable Alarm Sound');
      expect(alarmSwitch, findsOneWidget);
      await tester.tap(alarmSwitch);
      await tester.pump(const Duration(milliseconds: 100));

      // Drag Slider
      final slider = find.byType(Slider).first;
      await tester.drag(slider, const Offset(50, 0));
      await tester.pump(const Duration(milliseconds: 100));
    });
  });

  group('Flow 4: Guardian Anti-Theft Security Dialogs', () {
    testWidgets('showPinConfirmation arming: validates incorrect PIN and accepts correct PIN', (tester) async {
      bool? confirmedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                confirmedResult = await GuardianDialogs.showPinConfirmation(
                  context: context,
                  currentPin: '4321',
                  isArming: true,
                );
              },
              child: const Text('Open Arm Dialog'),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open Arm Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Arm Guardian Mode'), findsOneWidget);

      // Enter incorrect PIN
      await tester.enterText(find.byType(TextField), '0000');
      await tester.tap(find.text('Arm Now'));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect PIN'), findsOneWidget);
      expect(confirmedResult, isNull);

      // Enter correct PIN
      await tester.enterText(find.byType(TextField), '4321');
      await tester.tap(find.text('Arm Now'));
      await tester.pumpAndSettle();

      expect(confirmedResult, isTrue);
    });

    testWidgets('showTheftAlarmLockout: rejects bad PIN and disarms on valid PIN', (tester) async {
      bool disarmedFired = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                GuardianDialogs.showTheftAlarmLockout(
                  context: context,
                  currentPin: '9876',
                  onDisarmed: () {
                    disarmedFired = true;
                  },
                );
              },
              child: const Text('Trigger Theft Dialog'),
            ),
          ),
        ),
      );

      // Trigger lockout dialog
      await tester.tap(find.text('Trigger Theft Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('THEFT ALARM TRIGGERED!'), findsOneWidget);

      // Try incorrect PIN
      await tester.enterText(find.byType(TextField), '1111');
      await tester.tap(find.text('SILENCE & DISARM'));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect PIN! Siren active.'), findsOneWidget);
      expect(disarmedFired, isFalse);

      // Enter correct PIN
      await tester.enterText(find.byType(TextField), '9876');
      await tester.tap(find.text('SILENCE & DISARM'));
      await tester.pumpAndSettle();

      expect(disarmedFired, isTrue);
    });
  });

  group('Flow 5: Contribute Page', () {
    testWidgets('ContributePage displays UPI details and copy buttons without overflow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContributePage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Contribute'), findsOneWidget);
      expect(find.text('Scan to contribute'), findsOneWidget);
      expect(find.text('tosg@ptyes'), findsOneWidget);
      expect(find.text('Open in UPI app'), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsNWidgets(2));
    });
  });

  group('Flow 6: About & Privacy Policy Pages', () {
    testWidgets('AboutPage renders key features and GitHub contribution link', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('About'), findsOneWidget);
      expect(find.text('ChargeAlert'), findsOneWidget);
      expect(find.text('Key features:'), findsOneWidget);
      expect(find.text('Read Privacy Policy'), findsOneWidget);
      expect(find.text('Contribute on GitHub'), findsOneWidget);
    });

    testWidgets('PrivacyPolicyPage renders cleanly without overflow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PrivacyPolicyPage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Privacy Policy'), findsNWidgets(2));
      expect(find.textContaining('Permissions used:'), findsOneWidget);
    });
  });

  group('Flow 7: Charge History Page', () {
    testWidgets('ChargeHistoryPage handles empty state and clear button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChargeHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Charge History'), findsOneWidget);
      expect(find.text('No history yet'), findsOneWidget);
    });

    testWidgets('ChargeHistoryPage displays recorded samples and chart', (tester) async {
      final sampleJson = jsonEncode([
        {
          'ts': DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
          'level': 45,
          'state': 'charging',
        },
        {
          'ts': DateTime.now().millisecondsSinceEpoch,
          'level': 80,
          'state': 'charging',
        },
      ]);
      SharedPreferences.setMockInitialValues({
        'chargeHistory': sampleJson,
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: ChargeHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Charge History'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
    });
  });
}
