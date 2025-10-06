import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/legacy.dart';

// Providers
final alertPercentageProvider = StateProvider<double>((ref) => 80);
final currentBatteryProvider = StateProvider<int>((ref) => 0);
final isMonitoringProvider = StateProvider<bool>((ref) => false);

// Initialize battery and notification plugins
final battery = Battery();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // On Android create the notification channel
  if (Platform.isAndroid) {
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'battery_channel', // id
      'Battery Alerts', // title
      description: 'Channel for battery level alerts',
      importance: Importance.max,
    );

    await androidPlugin?.createNotificationChannel(channel);

    // Request runtime notification permission on Android 13+ using permission_handler
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  runApp(ProviderScope(child: ChargeAlertApp()));
}

class ChargeAlertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChargeAlert',
      home: ChargeAlertScreen(),
    );
  }
}

class ChargeAlertScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ChargeAlertScreen> createState() => _ChargeAlertScreenState();
}

class _ChargeAlertScreenState extends ConsumerState<ChargeAlertScreen> {
  Timer? _timer;
  BatteryState? _batteryState;

  @override
  void initState() {
    super.initState();
    // Get initial battery level
    battery.batteryLevel.then((level) {
      ref.read(currentBatteryProvider.notifier).state = level;
    }).catchError((_) {});

    battery.onBatteryStateChanged.listen((BatteryState state) async {
      _batteryState = state;
      // Update current battery level whenever state changes
      try {
        final level = await battery.batteryLevel;
        ref.read(currentBatteryProvider.notifier).state = level;
      } catch (_) {}

      if (state == BatteryState.charging && ref.read(isMonitoringProvider)) {
        _startMonitoring();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startMonitoring() {
    _timer?.cancel();
    // Read immediately, then schedule periodic checks
    () async {
      try {
        final level = await battery.batteryLevel;
        ref.read(currentBatteryProvider.notifier).state = level;
        final double target = ref.read(alertPercentageProvider);
        if (level >= target) {
          _showNotification(target.toInt());
          ref.read(isMonitoringProvider.notifier).state = false;
          return;
        }
      } catch (_) {}
    }();

    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      int level = await battery.batteryLevel;
      ref.read(currentBatteryProvider.notifier).state = level;

      double target = ref.read(alertPercentageProvider);
      if (level >= target) {
        _showNotification(target.toInt());
        _timer?.cancel();
        ref.read(isMonitoringProvider.notifier).state = false;
      }
    });
  }

  Future<void> _showNotification(int target) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'battery_channel',
      'Battery Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Battery Alert',
      'Battery reached $target%',
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final alertPercentage = ref.watch(alertPercentageProvider);
    final currentBattery = ref.watch(currentBatteryProvider);

    return Scaffold(
      appBar: AppBar(title: Text("ChargeAlert"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Set Battery Percentage Alert",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("${alertPercentage.round()}%", style: TextStyle(fontSize: 28)),
            Slider(
              value: alertPercentage,
              min: 1,
              max: 100,
              divisions: 100,
              label: "${alertPercentage.round()}%",
              onChanged: (value) {
                ref.read(alertPercentageProvider.notifier).state = value;
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ref.read(isMonitoringProvider.notifier).state = true;
                if (_batteryState == BatteryState.charging) {
                  _startMonitoring();
                }
              },
              child: Text("Start Monitoring"),
            ),
            SizedBox(height: 30),
            Text(
              "Current Battery: $currentBattery%",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
