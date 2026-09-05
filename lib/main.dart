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
import 'package:share_plus/share_plus.dart';
import 'pages/history_page.dart';
import 'pages/splash_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/about_page.dart';
import 'pages/contribute_page.dart';
import 'pages/privacy_policy_page.dart';
import 'widgets/liquid_core_painter.dart';
import 'widgets/volt_companion.dart';
import 'widgets/guardian_dialog.dart';

class BatteryDetails {
  final double temperature;
  final double voltage;
  final String health;
  final String plugged;
  final String technology;

  const BatteryDetails({
    this.temperature = 0,
    this.voltage = 0,
    this.health = 'Good',
    this.plugged = 'Unknown',
    this.technology = 'Li-ion',
  });
}

// Providers
final alertPercentageProvider = StateNotifierProvider<AlertPercentageNotifier, double>((ref) => AlertPercentageNotifier());
final currentBatteryProvider = StateProvider<int>((ref) => 0);
final batteryStateProvider = StateProvider<BatteryState>((ref) => BatteryState.unknown);
final alarmEnabledProvider = StateNotifierProvider<AlarmEnabledNotifier, bool>((ref) => AlarmEnabledNotifier());
final continuousAlarmProvider = StateNotifierProvider<ContinuousAlarmNotifier, bool>((ref) => ContinuousAlarmNotifier());
final lowAlertPercentageProvider = StateNotifierProvider<LowAlertPercentageNotifier, double>((ref) => LowAlertPercentageNotifier());
final lowAlarmEnabledProvider = StateNotifierProvider<LowAlarmEnabledNotifier, bool>((ref) => LowAlarmEnabledNotifier());
final guardianArmedProvider = StateNotifierProvider<GuardianArmedNotifier, bool>((ref) => GuardianArmedNotifier());
final theftPinProvider = StateNotifierProvider<TheftPinNotifier, String>((ref) => TheftPinNotifier());
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) => ThemeModeNotifier());

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString('themeMode') ?? 'system';
    if (modeStr == 'light') {
      state = ThemeMode.light;
    } else if (modeStr == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    final modeStr = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await prefs.setString('themeMode', modeStr);
  }

  Future<void> toggle() async {
    if (state == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}

class GuardianArmedNotifier extends StateNotifier<bool> {
  GuardianArmedNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('guardianArmed') ?? false;
  }

  Future<void> setArmed(bool armed) async {
    state = armed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guardianArmed', armed);
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'guardianArmed',
        'type': 'bool',
        'value': armed,
      });
    } catch (_) {}
  }
}

class TheftPinNotifier extends StateNotifier<String> {
  TheftPinNotifier() : super('1234') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('theftPin') ?? '1234';
  }

  Future<void> setPin(String pin) async {
    state = pin;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theftPin', pin);
  }
}

// Initialize battery and notification plugins
final battery = Battery();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class AlertPercentageNotifier extends StateNotifier<double> {
  AlertPercentageNotifier() : super(80) {
    _loadSavedPercentage();
  }

  Future<void> _loadSavedPercentage() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getDouble('alertPercentage') ?? 80;
    state = val;
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'alertPercentage',
        'type': 'double',
        'value': val,
      });
    } catch (_) {}
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
    final val = prefs.getDouble('lowAlertPercentage') ?? 15;
    state = val;
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'lowAlertPercentage',
        'type': 'double',
        'value': val,
      });
    } catch (_) {}
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
    final val = prefs.getBool('lowAlarmEnabled') ?? false;
    state = val;
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'lowAlarmEnabled',
        'type': 'bool',
        'value': val,
      });
    } catch (_) {}
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
    final val = prefs.getBool('alarmEnabled') ?? true;
    state = val;
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'alarmEnabled',
        'type': 'bool',
        'value': val,
      });
    } catch (_) {}
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
    final val = prefs.getBool('continuousAlarm') ?? false;
    state = val;
    try {
      await _platform.invokeMethod('savePreference', {
        'key': 'continuousAlarm',
        'type': 'bool',
        'value': val,
      });
    } catch (_) {}
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
final MethodChannel _platform = const MethodChannel('com.technorchid.charge_alert/alarm');

class ChargeAlertApp extends ConsumerWidget {
  const ChargeAlertApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChargeAlert',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0288D1),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 1,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00E5FF),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020810),
        cardTheme: const CardThemeData(
          color: Color(0xFF0F172A),
          elevation: 2,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const SplashPage();
            break;
          case '/onboarding':
            page = const OnboardingPage();
            break;
          case '/home':
            page = const ChargeAlertScreen();
            break;
          case '/history':
            page = const ChargeHistoryPage();
            break;
          case '/about':
            page = const AboutPage();
            break;
          case '/contribute':
            page = const ContributePage();
            break;
          case '/privacy':
            page = const PrivacyPolicyPage();
            break;
          default:
            page = const ChargeAlertScreen();
        }

        // Fluid, premium shared-axis cross-fade with gentle scale
        // Completely eliminates dark dips, blank pauses, and jarring cuts
        if (settings.name == '/' || settings.name == '/home' || settings.name == '/onboarding') {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              );
              return FadeTransition(
                opacity: curved,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 380),
            reverseTransitionDuration: const Duration(milliseconds: 350),
          );
        }

        return MaterialPageRoute(builder: (_) => page, settings: settings);
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
  BatteryDetails _batteryDetails = const BatteryDetails();

  StreamSubscription<BatteryState>? _batterySub;
  int _lastSavedTs = 0;
  int? _lastSavedLevel;
  String? _lastSavedState;
  BatteryState? _previousBatteryState;
  bool _isTheftLockoutShowing = false;

  void _showFaqBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
    _setupPlatformListener();
    _checkInitialAlarmState();
    _initializeBatteryMonitoring();
    _fetchBatteryDetails();
  }

  void _setupPlatformListener() {
    _platform.setMethodCallHandler((call) async {
      if (call.method == 'onAlarmStatusChanged') {
        final isAlarming = call.arguments?['isAlarming'] as bool? ?? false;
        if (mounted) {
          setState(() {
            _isAlarming = isAlarming;
          });
          if (isAlarming && ref.read(guardianArmedProvider)) {
            final bState = ref.read(batteryStateProvider);
            if (bState != BatteryState.charging && bState != BatteryState.full) {
              _triggerTheftAlarm();
            }
          }
          if (!isAlarming) {
            _alarmTimer?.cancel();
            _alarmTimer = null;
            try {
              flutterLocalNotificationsPlugin.cancel(0);
            } catch (_) {}
          }
        }
      } else if (call.method == 'onTheftAlarmTriggered') {
        if (mounted) {
          _triggerTheftAlarm();
        }
      }
    });
  }

  Future<void> _checkInitialAlarmState() async {
    try {
      final running = await _platform.invokeMethod<bool>('isAlarmRunning');
      if (running == true && mounted) {
        setState(() => _isAlarming = true);
        if (ref.read(guardianArmedProvider)) {
          final bState = ref.read(batteryStateProvider);
          if (bState != BatteryState.charging && bState != BatteryState.full) {
            _triggerTheftAlarm();
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchBatteryDetails() async {
    try {
      final res = await _platform.invokeMethod<Map>('getBatteryDetails');
      if (res != null && mounted) {
        setState(() {
          _batteryDetails = BatteryDetails(
            temperature: (res['temperature'] as num?)?.toDouble() ?? 0,
            voltage: (res['voltage'] as num?)?.toDouble() ?? 0,
            health: res['health']?.toString() ?? 'Good',
            plugged: res['plugged']?.toString() ?? 'Unknown',
            technology: res['technology']?.toString() ?? 'Li-ion',
          );
        });
      }
    } catch (_) {}
  }

  Future<void> _startForegroundAlarm({bool isTheft = false}) async {
    setState(() => _isAlarming = true);
    try {
      await _platform.invokeMethod('startService', {'isTheft': isTheft});
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
      final prevState = _previousBatteryState;
      _previousBatteryState = state;
      ref.read(batteryStateProvider.notifier).state = state;

      // Guardian Mode: Anti-Theft Unplug Detection
      final isArmed = ref.read(guardianArmedProvider);
      if (isArmed &&
          (prevState == BatteryState.charging || prevState == BatteryState.full) &&
          (state != BatteryState.charging && state != BatteryState.full)) {
        _triggerTheftAlarm();
      }

      try {
        final level = await battery.batteryLevel;
        if (!mounted) return;
        ref.read(currentBatteryProvider.notifier).state = level;
        _checkBatteryLevel(level);
        _maybeRecordSample(level, state);
        _fetchBatteryDetails();
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
        _fetchBatteryDetails();
      } catch (_) {}
    });
  }

  void _checkBatteryLevel(int level) {
    if (_isTheftLockoutShowing) return;
    final isArmed = ref.read(guardianArmedProvider);
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
      if (!isArmed) {
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
      }
    } else if (batteryState == BatteryState.charging && level < targetLevel) {
      if (_isAlarming) {
        _stopAlarm();
      }
    } else if (batteryState != BatteryState.charging && level > lowTargetLevel) {
      if (_isAlarming && !isArmed) {
        _stopAlarm();
      }
    }
  }

  void _stopAlarm() {
    setState(() {
      _isAlarming = false;
    });
    _alarmTimer?.cancel();
    _alarmTimer = null;
    try {
      flutterLocalNotificationsPlugin.cancel(0);
    } catch (_) {}
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

  Future<void> _startInAppAlarm({bool isTheft = false}) async {
    if (_isAlarming) {
      try { await _startForegroundAlarm(isTheft: isTheft); } catch (_) {}
    }
  }

  Future<void> _triggerTheftAlarm() async {
    if (_isTheftLockoutShowing) return;
    _isTheftLockoutShowing = true;
    _isAlarming = true;
    try {
      await _startForegroundAlarm(isTheft: true);
    } catch (_) {}

    if (!mounted) {
      _isTheftLockoutShowing = false;
      return;
    }

    final pin = ref.read(theftPinProvider);
    await GuardianDialogs.showTheftAlarmLockout(
      context: context,
      currentPin: pin,
      onDisarmed: () async {
        _stopAlarm();
        ref.read(guardianArmedProvider.notifier).setArmed(false);
      },
    );
    _isTheftLockoutShowing = false;
  }

  Future<void> _handleGuardianToggle(bool targetArmed) async {
    final currentPin = ref.read(theftPinProvider);
    final currentState = ref.read(batteryStateProvider);

    if (targetArmed) {
      if (currentState != BatteryState.charging && currentState != BatteryState.full) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Please plug in your charger before arming Guardian Mode!'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final confirmed = await GuardianDialogs.showPinConfirmation(
        context: context,
        currentPin: currentPin,
        isArming: true,
      );
      if (confirmed == true && mounted) {
        _previousBatteryState = BatteryState.charging;
        await ref.read(guardianArmedProvider.notifier).setArmed(true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🛡️ Guardian Mode Armed! Alarm will sound if unplugged.'),
              backgroundColor: Colors.indigo,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else {
      final confirmed = await GuardianDialogs.showPinConfirmation(
        context: context,
        currentPin: currentPin,
        isArming: false,
      );
      if (confirmed == true && mounted) {
        await ref.read(guardianArmedProvider.notifier).setArmed(false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Guardian Mode Disarmed.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _changePinDialog() async {
    final pinController = TextEditingController();
    String? error;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.password, color: Color(0xFF38BDF8)),
              SizedBox(width: 8),
              Text('Change Security PIN', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter a new 4-digit PIN for Guardian Mode.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 12),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '••••',
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorText: error,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () {
                final newPin = pinController.text.trim();
                if (newPin.length == 4) {
                  ref.read(theftPinProvider.notifier).setPin(newPin);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Security PIN updated successfully!'), behavior: SnackBarBehavior.floating),
                  );
                } else {
                  setDState(() => error = 'Must be exactly 4 digits');
                }
              },
              child: const Text('Save PIN'),
            ),
          ],
        ),
      ),
    );
  }

  VoltMood _getVoltMood(int batteryLevel, BatteryState batteryState, bool isArmed) {
    if (_isAlarming) return VoltMood.overheating;
    if (isArmed) return VoltMood.guardianArmed;
    if (_batteryDetails.temperature > 42) return VoltMood.overheating;
    if (batteryState == BatteryState.charging) {
      final target = ref.read(alertPercentageProvider);
      if (batteryLevel >= target) return VoltMood.targetReached;
      return VoltMood.charging;
    }
    if (batteryLevel <= ref.read(lowAlertPercentageProvider)) return VoltMood.lowBattery;
    return VoltMood.normal;
  }

  String _getVoltSpeech(int batteryLevel, BatteryState batteryState, bool isArmed) {
    if (_isAlarming) return "🚨 INTRUSION OR ALERT! Stop the alarm!";
    if (isArmed) return "🛡️ Guardian Armed. Unplugging triggers loud siren!";
    if (_batteryDetails.temperature > 42) return "🔥 I'm running hot! Please give me some air!";
    if (batteryState == BatteryState.charging) {
      final target = ref.read(alertPercentageProvider);
      if (batteryLevel >= target) return "🎉 Target reached! Unplug now to save battery life!";
      return "⚡ Absorbing energy! Flowing fast & smooth!";
    }
    if (batteryLevel <= ref.read(lowAlertPercentageProvider)) return "🪫 My energy is running out... feed me power!";
    return "✨ All systems operational!";
  }

  Widget _buildHoloTelemetryCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                        fontSize: 11,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

    final tempColor = _batteryDetails.temperature > 42
        ? Colors.red
        : _batteryDetails.temperature > 38
            ? Colors.orange
            : Colors.green;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("ChargeAlert"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggle();
            },
          ),
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
                case 'theme':
                  final current = ref.read(themeModeProvider);
                  showDialog(
                    context: context,
                    builder: (ctx) => SimpleDialog(
                      title: const Text('Choose Theme'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
                            Navigator.pop(ctx);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.brightness_auto),
                              const SizedBox(width: 12),
                              const Text('System Default'),
                              if (current == ThemeMode.system) ...[
                                const Spacer(),
                                const Icon(Icons.check, color: Colors.blue),
                              ],
                            ],
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                            Navigator.pop(ctx);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.light_mode),
                              const SizedBox(width: 12),
                              const Text('Light Theme'),
                              if (current == ThemeMode.light) ...[
                                const Spacer(),
                                const Icon(Icons.check, color: Colors.blue),
                              ],
                            ],
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                            Navigator.pop(ctx);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.dark_mode),
                              const SizedBox(width: 12),
                              const Text('Dark Theme'),
                              if (current == ThemeMode.dark) ...[
                                const Spacer(),
                                const Icon(Icons.check, color: Colors.blue),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  break;
                case 'history':
                  Navigator.of(context).pushNamed('/history');
                  break;
                case 'onboarding':
                  Navigator.of(context).pushNamed('/onboarding');
                  break;
                case 'splash':
                  Navigator.of(context).pushNamed('/');
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
              PopupMenuItem(value: 'theme', child: Text('Theme: Light / Dark / Auto')),
              PopupMenuItem(value: 'splash', child: Text('Replay Splash Screen')),
              PopupMenuItem(value: 'onboarding', child: Text('Intro & Walkthrough')),
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
                  const SizedBox(height: 12),
                  // Active Alarm Alert Banner
                  if (_isAlarming)
                    Consumer(
                      builder: (context, ref, _) {
                        final isArmed = ref.watch(guardianArmedProvider);
                        final bState = ref.watch(batteryStateProvider);
                        final isTheftAlert = isArmed && bState != BatteryState.charging && bState != BatteryState.full;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isTheftAlert ? const Color(0xFF7F1D1D) : Colors.red.shade700,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (isTheftAlert ? Colors.red.shade900 : Colors.red).withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isTheftAlert ? Icons.warning_amber_rounded : Icons.alarm_on,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isTheftAlert ? 'THEFT ALARM ACTIVE!' : 'Alarm Ringing!',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isTheftAlert ? 'Charger disconnected! PIN required.' : 'Target reached or alert active',
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: isTheftAlert ? const Color(0xFF991B1B) : Colors.red.shade900,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                                onPressed: isTheftAlert ? _triggerTheftAlarm : _stopAlarm,
                                child: Text(
                                  isTheftAlert ? 'DISARM' : 'STOP',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 12),
                  // 1. Hero Liquid Capsule & Volt Companion
                  Center(
                    child: LiquidBatteryCore(
                      batteryLevel: currentBattery,
                      isCharging: batteryState == BatteryState.charging,
                      primaryColor: color,
                      height: 220,
                      width: 220,
                      child: Center(
                        child: VoltCompanion(
                          mood: _getVoltMood(currentBattery, batteryState, ref.watch(guardianArmedProvider)),
                          speechText: _getVoltSpeech(currentBattery, batteryState, ref.watch(guardianArmedProvider)),
                          size: 110,
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Battery Percentage & Speedometer Telemetry Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$currentBattery%",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          height: 28,
                          width: 1.5,
                          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  batteryState == BatteryState.charging
                                      ? Icons.electric_bolt
                                      : Icons.battery_std,
                                  size: 15,
                                  color: color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  batteryState == BatteryState.charging
                                      ? 'HYPER CHARGING'
                                      : batteryState == BatteryState.full
                                          ? 'BATTERY FULL'
                                          : 'DISCHARGING',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              batteryState == BatteryState.charging
                                  ? (currentBattery < alertPercentage
                                      ? '~${((alertPercentage - currentBattery) * 1.1).round().clamp(1, 180)}m to ${alertPercentage.round()}%'
                                      : 'Target ${alertPercentage.round()}% Reached!')
                                  : 'Target: ${alertPercentage.round()}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Anti-Theft Guardian Mode Security Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: ref.watch(guardianArmedProvider)
                            ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                            : [
                                Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                                Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ref.watch(guardianArmedProvider)
                            ? const Color(0xFF818CF8)
                            : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
                        width: ref.watch(guardianArmedProvider) ? 2 : 1,
                      ),
                      boxShadow: ref.watch(guardianArmedProvider)
                          ? [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ref.watch(guardianArmedProvider)
                                    ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                                    : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                ref.watch(guardianArmedProvider) ? Icons.shield : Icons.shield_outlined,
                                color: ref.watch(guardianArmedProvider) ? const Color(0xFF818CF8) : Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 6,
                                    children: [
                                      Text(
                                        'Guardian Anti-Theft',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: ref.watch(guardianArmedProvider) ? Colors.white : null,
                                            ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: ref.watch(guardianArmedProvider) ? Colors.green.shade600 : Colors.grey.withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          ref.watch(guardianArmedProvider) ? 'ARMED' : 'IDLE',
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    ref.watch(guardianArmedProvider)
                                        ? 'Siren will blast & lock screen if unplugged'
                                        : 'Sound alarm if someone unplugs phone',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ref.watch(guardianArmedProvider)
                                          ? Colors.white70
                                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: ref.watch(guardianArmedProvider),
                              activeThumbColor: const Color(0xFF818CF8),
                              onChanged: (val) => _handleGuardianToggle(val),
                            ),
                          ],
                        ),
                        if (ref.watch(guardianArmedProvider)) ...[
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '🔒 Protected with 4-digit PIN',
                                style: TextStyle(fontSize: 11, color: Colors.white60),
                              ),
                              GestureDetector(
                                onTap: _changePinDialog,
                                child: const Text(
                                  'Change PIN',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF93C5FD),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Live 2x2 Telemetry Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.2,
                    children: [
                      _buildHoloTelemetryCard(
                        icon: Icons.thermostat,
                        label: 'Temperature',
                        value: _batteryDetails.temperature > 0
                            ? '${_batteryDetails.temperature.toStringAsFixed(1)}°C'
                            : '--',
                        subtitle: _batteryDetails.temperature > 40 ? 'Running Warm' : 'Nominal Temp',
                        color: tempColor,
                      ),
                      _buildHoloTelemetryCard(
                        icon: Icons.favorite_border,
                        label: 'Battery Health',
                        value: _batteryDetails.health,
                        subtitle: 'Operating Well',
                        color: _batteryDetails.health == 'Good' ? Colors.green : Colors.orange,
                      ),
                      _buildHoloTelemetryCard(
                        icon: Icons.electric_bolt,
                        label: 'Voltage',
                        value: _batteryDetails.voltage > 0
                            ? '${_batteryDetails.voltage.toStringAsFixed(2)} V'
                            : '--',
                        subtitle: _batteryDetails.technology,
                        color: Colors.amber,
                      ),
                      _buildHoloTelemetryCard(
                        icon: Icons.power,
                        label: 'Power Source',
                        value: _batteryDetails.plugged,
                        subtitle: batteryState == BatteryState.charging ? 'Active Input' : 'Disconnected',
                        color: Colors.cyan,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  Text(
                    "Alert me when battery reaches:",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${alertPercentage.round()}%",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
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
                              style: _isAlarming
                                  ? ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade700,
                                      foregroundColor: Colors.white,
                                    )
                                  : null,
                              onPressed: () async {
                                if (_isAlarming) {
                                  _stopAlarm();
                                } else {
                                  try { await _startForegroundAlarm(); } catch (_) {}
                                }
                              },
                              icon: Icon(_isAlarming ? Icons.stop : Icons.alarm),
                              label: Text(_isAlarming ? "Stop alarm now" : "Test alarm now"),
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