import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';
import 'pages/history_page.dart';
import 'pages/splash_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/about_page.dart';
import 'pages/contribute_page.dart';
import 'pages/privacy_policy_page.dart';
// foreground-task plugin removed in favor of native AlarmService for reliability
// no isolate send/receive used currently

// Providers
final alertPercentageProvider = StateNotifierProvider<AlertPercentageNotifier, double>((ref) => AlertPercentageNotifier());
final currentBatteryProvider = StateProvider<int>((ref) => 0);
final batteryStateProvider = StateProvider<BatteryState>((ref) => BatteryState.unknown);
final alarmEnabledProvider = StateNotifierProvider<AlarmEnabledNotifier, bool>((ref) => AlarmEnabledNotifier());
final continuousAlarmProvider = StateNotifierProvider<ContinuousAlarmNotifier, bool>((ref) => ContinuousAlarmNotifier());
final lowAlertPercentageProvider = StateNotifierProvider<LowAlertPercentageNotifier, double>((ref) => LowAlertPercentageNotifier());
final lowAlarmEnabledProvider = StateNotifierProvider<LowAlarmEnabledNotifier, bool>((ref) => LowAlarmEnabledNotifier());

// Initialize battery and notification plugins
final battery = Battery();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final AudioPlayer _audioPlayer = AudioPlayer();

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
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'alertPercentage',
        'type': 'double',
        'value': value,
      });
    } catch (_) {}
  }
}

class LowAlertPercentageNotifier extends StateNotifier<double> {
  LowAlertPercentageNotifier() : super(15) {
    _loadSavedPercentage();
  }

  Future<void> _loadSavedPercentage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble('lowAlertPercentage') ?? 15;
  }

  Future<void> updatePercentage(double value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('lowAlertPercentage', value);
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'lowAlertPercentage',
        'type': 'double',
        'value': value,
      });
    } catch (_) {}
  }
}

class LowAlarmEnabledNotifier extends StateNotifier<bool> {
  LowAlarmEnabledNotifier() : super(false) {
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('lowAlarmEnabled') ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lowAlarmEnabled', state);
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'lowAlarmEnabled',
        'type': 'bool',
        'value': state,
      });
    } catch (_) {}
  }
}

class AlarmEnabledNotifier extends StateNotifier<bool> {
  AlarmEnabledNotifier() : super(true) {
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('alarmEnabled') ?? true;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alarmEnabled', state);
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'alarmEnabled',
        'type': 'bool',
        'value': state,
      });
    } catch (_) {}
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alarmEnabled', state);
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'alarmEnabled',
        'type': 'bool',
        'value': state,
      });
    } catch (_) {}
  }
}

class ContinuousAlarmNotifier extends StateNotifier<bool> {
  ContinuousAlarmNotifier() : super(false) {
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('continuousAlarm') ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('continuousAlarm', state);
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'continuousAlarm',
        'type': 'bool',
        'value': state,
      });
    } catch (_) {}
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Foreground service initialization is currently deferred because the
  // flutter_foreground_task package API version in this project needs a
  // coordinated update to the TaskHandler implementation and initialization
  // parameters. Keeping the in-app alarm and notification functionality
  // available while we align the foreground service integration.

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
      
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create notification channel and request permission
  if (Platform.isAndroid) {
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'battery_channel',
      'Battery Alerts',
      description: 'Channel for battery level alerts',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await androidPlugin?.createNotificationChannel(channel);
    
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  runApp(const ProviderScope(child: ChargeAlertApp()));
}

// Platform channel to control native AlarmService
final MethodChannel _platform = const MethodChannel('com.example.charge_alert/alarm');

class ChargeAlertApp extends StatelessWidget {
  const ChargeAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChargeAlert',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
        '/onboarding': (_) => const OnboardingPage(),
        '/home': (_) => const ChargeAlertScreen(),
        '/history': (_) => const ChargeHistoryPage(),
        '/about': (_) => const AboutPage(),
        '/contribute': (_) => const ContributePage(),
        '/privacy': (_) => const PrivacyPolicyPage(),
      },
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
  Timer? _alarmTimer;
  bool _isAlarming = false;
  
  StreamSubscription<BatteryState>? _batterySub;
  int _lastSavedTs = 0;
  int? _lastSavedLevel;
  String? _lastSavedState;

  void _showFaqBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick FAQ', style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 12),
                Text('• Why didn\'t the alarm ring?'),
                const SizedBox(height: 4),
                Text(
                  'Ensure background activity is allowed, autostart/startup is enabled, and notifications have sound. Use the shortcuts below to open settings.',
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.battery_saver, size: 18),
                      label: const Text('Background activity'),
                      onPressed: () async {
                        try { await _platform.invokeMethod('openSettings', {'type': 'app_battery_settings'}); } catch (_) {}
                      },
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.start, size: 18),
                      label: const Text('Autostart'),
                      onPressed: () async {
                        try { await _platform.invokeMethod('openSettings', {'type': 'autostart_settings'}); } catch (_) {}
                      },
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.notifications_active, size: 18),
                      label: const Text('Notifications'),
                      onPressed: () async {
                        try { await _platform.invokeMethod('openSettings', {'type': 'notification_settings'}); } catch (_) {}
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('• How to allow autostart/startup?'),
                const SizedBox(height: 4),
                Text(
                  'Different brands place this in OEM settings (e.g., Xiaomi/OPPO/Vivo). Use the Autostart shortcut above and enable startup for ChargeAlert.',
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeBatteryMonitoring();
  }

  Future<void> _startForegroundAlarm() async {
    try {
      await _platform.invokeMethod('startService');
    } catch (_) {}
  }

  Future<void> _stopForegroundAlarm() async {
    try {
      await _platform.invokeMethod('stopService');
    } catch (_) {}
  }

  Future<void> _initializeBatteryMonitoring() async {
    // Get initial battery level
    try {
      final level = await battery.batteryLevel;
      ref.read(currentBatteryProvider.notifier).state = level;
    } catch (_) {}

    // Listen to battery state changes
    _batterySub?.cancel();
    _batterySub = battery.onBatteryStateChanged.listen((state) async {
      if (!mounted) return;
      ref.read(batteryStateProvider.notifier).state = state;
      try {
        final level = await battery.batteryLevel;
        if (!mounted) return;
        ref.read(currentBatteryProvider.notifier).state = level;
        _checkBatteryLevel(level);
        _maybeRecordSample(level, state);
      } catch (_) {}
    });

    // Start periodic monitoring
    _startPeriodicCheck();
  }

  void _startPeriodicCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (!mounted) return;
      try {
        final level = await battery.batteryLevel;
        if (!mounted) return;
        ref.read(currentBatteryProvider.notifier).state = level;
        _checkBatteryLevel(level);
        _maybeRecordSample(level, ref.read(batteryStateProvider));
      } catch (_) {}
    });
  }

  void _checkBatteryLevel(int level) {
    final targetLevel = ref.read(alertPercentageProvider);
    final batteryState = ref.read(batteryStateProvider);
    final alarmEnabled = ref.read(alarmEnabledProvider);
    final isContinuous = ref.read(continuousAlarmProvider);
    final lowTargetLevel = ref.read(lowAlertPercentageProvider);
    final lowAlarmEnabled = ref.read(lowAlarmEnabledProvider);
    
    if (batteryState == BatteryState.charging && level >= targetLevel && alarmEnabled) {
      if (!_isAlarming) {
        _isAlarming = true;
        _showNotification(targetLevel.toInt());
        
        if (isContinuous) {
          _alarmTimer?.cancel();
          _alarmTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
            if (ref.read(alarmEnabledProvider)) {
              _showNotification(targetLevel.toInt());
            } else {
              _stopAlarm();
            }
          });
        }
      }
    } else if ((batteryState != BatteryState.charging && lowAlarmEnabled && level <= lowTargetLevel) && !_isAlarming) {
      _isAlarming = true;
      _showNotification(lowTargetLevel.toInt());
      if (isContinuous) {
        _alarmTimer?.cancel();
        _alarmTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
          if (ref.read(lowAlarmEnabledProvider)) {
            _showNotification(lowTargetLevel.toInt());
          } else {
            _stopAlarm();
          }
        });
      }
    } else if (batteryState == BatteryState.charging && level < targetLevel) {
      _stopAlarm();
    } else if (batteryState != BatteryState.charging && level > lowTargetLevel) {
      _stopAlarm();
    }
  }

  void _stopAlarm() {
    _isAlarming = false;
    _alarmTimer?.cancel();
    _alarmTimer = null;
    // stop audio
    try {
      _audioPlayer.stop();
    } catch (_) {}
    // stop foreground service if running
    _stopForegroundAlarm();
  }

  Future<void> _showNotification(int target) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'battery_channel',
      'Battery Alerts',
      channelDescription: 'Channel for battery level alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
      enableVibration: true,
      enableLights: true,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    await flutterLocalNotificationsPlugin.show(
      0,
      'Battery Alert',
      'Battery reached $target%',
      platformDetails,
    );

    // Start native foreground alarm service and show overlay
    _startInAppAlarm();
  }

  Future<void> _startInAppAlarm() async {
    if (_isAlarming) {
      // Start native foreground service (keeps running even if app killed)
      try { await _startForegroundAlarm(); } catch (_) {}
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final alertPercentage = ref.watch(alertPercentageProvider);
    final currentBattery = ref.watch(currentBatteryProvider);
    final batteryState = ref.watch(batteryStateProvider);

    final color = batteryState == BatteryState.charging
        ? Colors.green
        : currentBattery < 20
            ? Colors.red
            : currentBattery < 50
                ? Colors.orange
                : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text("ChargeAlert"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'History',
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              Navigator.of(context).pushNamed('/history');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'history':
                  Navigator.of(context).pushNamed('/history');
                  break;
                case 'about':
                  Navigator.of(context).pushNamed('/about');
                  break;
                case 'contribute':
                  Navigator.of(context).pushNamed('/contribute');
                  break;
                case 'privacy':
                  Navigator.of(context).pushNamed('/privacy');
                  break;
                case 'faq':
                  _showFaqBottomSheet(context);
                  break;
                case 'share':
                  Share.share('Check out ChargeAlert — smart charging alarms.\nGitHub: https://github.com/Subrata0Ghosh/charge_alert');
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'history', child: Text('Charge History')),
              PopupMenuItem(value: 'about', child: Text('About')),
              PopupMenuItem(value: 'contribute', child: Text('Contribute')),
              PopupMenuItem(value: 'privacy', child: Text('Privacy Policy')),
              PopupMenuItem(value: 'faq', child: Text('FAQ')),
              PopupMenuItem(value: 'share', child: Text('Share app')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: color, width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: currentBattery / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$currentBattery%",
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (batteryState == BatteryState.charging)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.bolt, color: color, size: 28),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    "Alert me when battery reaches:",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${alertPercentage.round()}%",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: color,
                      thumbColor: color,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
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
                  ),
                  const SizedBox(height: 16),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text(
                            "Enable Alarm Sound",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          value: ref.watch(alarmEnabledProvider),
                          activeThumbColor: color,
                          onChanged: (value) {
                            ref.read(alarmEnabledProvider.notifier).toggle();
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Continuous Alarm",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: const Text(
                            "Alarm will continue until you unplug or disable it",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: ref.watch(continuousAlarmProvider),
                          activeThumbColor: color,
                          onChanged: (value) {
                            ref.read(continuousAlarmProvider.notifier).toggle();
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: Text(
                            "Low Battery Alert",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: const Text(
                            "Alert when battery goes below target while discharging",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: ref.watch(lowAlarmEnabledProvider),
                          activeThumbColor: color,
                          onChanged: (value) {
                            ref.read(lowAlarmEnabledProvider.notifier).toggle();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Low target"),
                              Text("${ref.watch(lowAlertPercentageProvider).round()}%"),
                            ],
                          ),
                        ),
                        Slider(
                          value: ref.watch(lowAlertPercentageProvider),
                          min: 1,
                          max: 50,
                          divisions: 49,
                          label: "${ref.watch(lowAlertPercentageProvider).round()}%",
                          onChanged: (v) {
                            ref.read(lowAlertPercentageProvider.notifier).updatePercentage(v);
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.battery_saver),
                          title: const Text("Allow background activity"),
                          subtitle: const Text("Open app battery settings: set to Unrestricted / Allow"),
                          onTap: () async {
                            try {
                              await _platform.invokeMethod('openSettings', {'type': 'app_battery_settings'});
                            } catch (_) {}
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.start),
                          title: const Text("Autostart / Startup"),
                          subtitle: const Text("Open OEM autostart page to allow startup on boot"),
                          onTap: () async {
                            try {
                              await _platform.invokeMethod('openSettings', {'type': 'autostart_settings'});
                            } catch (_) {}
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.notifications_active),
                          title: const Text("Notification settings"),
                          subtitle: const Text("Ensure alerts are allowed with sound"),
                          onTap: () async {
                            try {
                              await _platform.invokeMethod('openSettings', {'type': 'notification_settings'});
                            } catch (_) {}
                          },
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try { await _startForegroundAlarm(); } catch (_) {}
                              },
                              icon: const Icon(Icons.alarm),
                              label: const Text("Test alarm now"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _maybeRecordSample(int level, BatteryState state) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final stateStr = state == BatteryState.charging
        ? 'charging'
        : state == BatteryState.discharging
            ? 'discharging'
            : state == BatteryState.full
                ? 'full'
                : 'unknown';
    final elapsed = now - _lastSavedTs;
    final changedEnough = _lastSavedLevel == null ||
        (_lastSavedLevel! - level).abs() >= 1 ||
        _lastSavedState != stateStr ||
        elapsed >= 5 * 60 * 1000;
    if (!changedEnough) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('chargeHistory');
      List<Map<String, dynamic>> list = [];
      if (raw != null && raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) {
            list = decoded
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          }
        } catch (_) {}
      }
      list.add({'ts': now, 'level': level, 'state': stateStr});
      if (list.length > 500) {
        list = list.sublist(list.length - 500);
      }
      await prefs.setString('chargeHistory', jsonEncode(list));
      _lastSavedTs = now;
      _lastSavedLevel = level;
      _lastSavedState = stateStr;
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    _alarmTimer?.cancel();
    _batterySub?.cancel();
    super.dispose();
  }
}