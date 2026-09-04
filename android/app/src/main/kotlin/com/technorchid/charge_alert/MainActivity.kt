package com.technorchid.charge_alert

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.SharedPreferences
import android.net.Uri
import android.os.BatteryManager
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.technorchid.charge_alert/alarm"
    private var methodChannel: MethodChannel? = null
    private var alarmBroadcastReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    try {
                        val intent = Intent(this, AlarmService::class.java)
                        ContextCompat.startForegroundService(this, intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("START_SERVICE_ERROR", e.message, null)
                    }
                }
                "stopService" -> {
                    try {
                        val intent = Intent(this, AlarmService::class.java).apply { action = "STOP_ALARM" }
                        startService(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        try {
                            stopService(Intent(this, AlarmService::class.java))
                            result.success(true)
                        } catch (e2: Exception) {
                            result.error("STOP_SERVICE_ERROR", e2.message, null)
                        }
                    }
                }
                "isAlarmRunning" -> {
                    result.success(AlarmService.isRunning)
                }
                "getBatteryDetails" -> {
                    try {
                        val ifilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                        val bIntent = registerReceiver(null, ifilter)
                        if (bIntent != null) {
                            val rawTemp = bIntent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0)
                            val tempCelsius = rawTemp / 10.0
                            val rawVoltage = bIntent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0)
                            val voltageVolts = rawVoltage / 1000.0
                            val healthCode = bIntent.getIntExtra(BatteryManager.EXTRA_HEALTH, BatteryManager.BATTERY_HEALTH_UNKNOWN)
                            val healthStr = when (healthCode) {
                                BatteryManager.BATTERY_HEALTH_GOOD -> "Good"
                                BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheat"
                                BatteryManager.BATTERY_HEALTH_DEAD -> "Dead"
                                BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage"
                                BatteryManager.BATTERY_HEALTH_COLD -> "Cold"
                                else -> "Good"
                            }
                            val pluggedCode = bIntent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0)
                            val pluggedStr = when (pluggedCode) {
                                BatteryManager.BATTERY_PLUGGED_AC -> "AC Charger"
                                BatteryManager.BATTERY_PLUGGED_USB -> "USB Port"
                                BatteryManager.BATTERY_PLUGGED_WIRELESS -> "Wireless"
                                else -> "Unplugged"
                            }
                            val tech = bIntent.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: "Li-ion"

                            result.success(mapOf(
                                "temperature" to tempCelsius,
                                "voltage" to voltageVolts,
                                "health" to healthStr,
                                "plugged" to pluggedStr,
                                "technology" to tech
                            ))
                        } else {
                            result.success(emptyMap<String, Any>())
                        }
                    } catch (e: Exception) {
                        result.error("BATTERY_INFO_ERROR", e.message, null)
                    }
                }
                "openSettings" -> {
                    val args = call.arguments as? Map<*, *>
                    val type = args?.get("type") as? String
                    try {
                        when (type) {
                            "battery_optimization_request" -> {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                    val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
                                    if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                                        val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
                                        intent.data = Uri.parse("package:$packageName")
                                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                        startActivity(intent)
                                    }
                                }
                            }
                            "battery_optimization_settings" -> {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                    val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                    startActivity(intent)
                                }
                            }
                            "app_battery_settings" -> {
                                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                                intent.data = Uri.parse("package:$packageName")
                                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                startActivity(intent)
                            }
                            "notification_settings" -> {
                                val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                                intent.putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                startActivity(intent)
                            }
                            "autostart_settings" -> {
                                val manu = Build.MANUFACTURER.lowercase()
                                var launched = false
                                fun tryStart(pkg: String, cls: String? = null) {
                                    if (launched) return
                                    try {
                                        val intent = if (cls != null) Intent().setClassName(pkg, cls) else packageManager.getLaunchIntentForPackage(pkg)
                                        if (intent != null) {
                                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                            startActivity(intent)
                                            launched = true
                                        }
                                    } catch (_: Exception) {}
                                }
                                when {
                                    manu.contains("xiaomi") || manu.contains("redmi") || manu.contains("poco") -> {
                                        tryStart("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")
                                        tryStart("com.miui.securitycenter")
                                    }
                                    manu.contains("oppo") || manu.contains("realme") -> {
                                        tryStart("com.coloros.safecenter")
                                        tryStart("com.coloros.oppoguardelf")
                                        tryStart("com.oppo.safe")
                                    }
                                    manu.contains("vivo") || manu.contains("iqoo") -> {
                                        tryStart("com.iqoo.secure")
                                    }
                                    manu.contains("huawei") || manu.contains("honor") -> {
                                        tryStart("com.huawei.systemmanager")
                                    }
                                    manu.contains("samsung") -> {
                                        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                                        intent.data = Uri.parse("package:$packageName")
                                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                        startActivity(intent)
                                        launched = true
                                    }
                                }
                                if (!launched) {
                                    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                                    intent.data = Uri.parse("package:$packageName")
                                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                    startActivity(intent)
                                }
                            }
                        }
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("OPEN_SETTINGS_ERROR", e.message, null)
                    }
                }
                "savePreference" -> {
                    val args = call.arguments as? Map<*, *>
                    val key = args?.get("key") as? String
                    val type = args?.get("type") as? String
                    val prefs: SharedPreferences = getSharedPreferences("ChargeAlertPrefs", Context.MODE_PRIVATE)
                    if (key != null && type != null) {
                        val editor = prefs.edit()
                        when (type) {
                            "double" -> {
                                val v = (args.get("value") as? Number)?.toDouble() ?: 0.0
                                editor.putFloat(key, v.toFloat())
                            }
                            "bool" -> {
                                val v = args.get("value") as? Boolean ?: false
                                editor.putBoolean(key, v)
                            }
                            "int" -> {
                                val v = (args.get("value") as? Number)?.toInt() ?: 0
                                editor.putInt(key, v)
                            }
                        }
                        editor.apply()
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGS", "Missing key/type", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // Register broadcast receiver for alarm state changes
        registerAlarmReceiver()
    }

    private fun registerAlarmReceiver() {
        alarmBroadcastReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                when (intent?.action) {
                    "com.technorchid.charge_alert.ALARM_STARTED" -> {
                        methodChannel?.invokeMethod("onAlarmStatusChanged", mapOf("isAlarming" to true))
                    }
                    "com.technorchid.charge_alert.ALARM_STOPPED" -> {
                        methodChannel?.invokeMethod("onAlarmStatusChanged", mapOf("isAlarming" to false))
                    }
                }
            }
        }
        val filter = IntentFilter().apply {
            addAction("com.technorchid.charge_alert.ALARM_STARTED")
            addAction("com.technorchid.charge_alert.ALARM_STOPPED")
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(alarmBroadcastReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(alarmBroadcastReceiver, filter)
        }
    }

    override fun onDestroy() {
        try {
            if (alarmBroadcastReceiver != null) {
                unregisterReceiver(alarmBroadcastReceiver)
            }
        } catch (_: Exception) {}
        super.onDestroy()
    }
}
