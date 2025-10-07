import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers
final alertPercentageProvider = StateNotifierProvider<AlertPercentageNotifier, double>((ref) => AlertPercentageNotifier());
final currentBatteryProvider = StateProvider<int>((ref) => 0);
final batteryStateProvider = StateProvider<BatteryState>((ref) => BatteryState.unknown);

// Initialize battery and notification plugins
final battery = Battery();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class AlertPercentageNotifier extends StateNotifier<double> {
  AlertPercentageNotifier() : super(80) {
    _loadSavedPercentage();
  }

  Future<void> _loadSavedPercentage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble('alertPercentage') ?? 80;
  }

  Future<void> updatePercentage(double value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('alertPercentage', value);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create notification channel and request permission
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'battery_channel',
    'Battery Alerts',
    description: 'Channel for battery level alerts',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(const ProviderScope(child: ChargeAlertApp()));
}

class ChargeAlertApp extends StatelessWidget {
  const ChargeAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChargeAlert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ChargeAlertScreen(),
    );
  }
}

class ChargeAlertScreen extends ConsumerStatefulWidget {
  const ChargeAlertScreen({super.key});

  @override
  ConsumerState<ChargeAlertScreen> createState() => _ChargeAlertScreenState();
}

class _ChargeAlertScreenState extends ConsumerState<ChargeAlertScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeBatteryMonitoring();
  }

  Future<void> _initializeBatteryMonitoring() async {
    // Get initial battery level
    try {
      final level = await battery.batteryLevel;
      ref.read(currentBatteryProvider.notifier).state = level;
    } catch (_) {}

    // Listen to battery state changes
    battery.onBatteryStateChanged.listen((state) async {
      ref.read(batteryStateProvider.notifier).state = state;
      try {
        final level = await battery.batteryLevel;
        ref.read(currentBatteryProvider.notifier).state = level;
        _checkBatteryLevel(level);
      } catch (_) {}
    });

    // Start periodic monitoring
    _startPeriodicCheck();
  }

  void _startPeriodicCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        final level = await battery.batteryLevel;
        ref.read(currentBatteryProvider.notifier).state = level;
        _checkBatteryLevel(level);
      } catch (_) {}
    });
  }

  void _checkBatteryLevel(int level) {
    final targetLevel = ref.read(alertPercentageProvider);
    final batteryState = ref.read(batteryStateProvider);
    
    if (batteryState == BatteryState.charging && level >= targetLevel) {
      _showNotification(targetLevel.toInt());
    }
  }

  Future<void> _showNotification(int target) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'battery_channel',
      'Battery Alerts',
      channelDescription: 'Channel for battery level alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
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
    final batteryState = ref.watch(batteryStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ChargeAlert"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildBatteryIndicator(currentBattery, batteryState),
              const SizedBox(height: 40),
              Text(
                "Alert me when battery reaches:",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "${alertPercentage.round()}%",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Slider(
                  value: alertPercentage,
                  min: 1,
                  max: 100,
                  divisions: 100,
                  label: "${alertPercentage.round()}%",
                  onChanged: (value) {
                    ref.read(alertPercentageProvider.notifier).updatePercentage(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryIndicator(int level, BatteryState state) {
    final color = state == BatteryState.charging
        ? Colors.green
        : level < 20
            ? Colors.red
            : level < 50
                ? Colors.orange
                : Colors.blue;

    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: level / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha:3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$level%",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state == BatteryState.charging)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.bolt, color: color, size: 28),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}