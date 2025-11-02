package com.example.charge_alert

import android.content.Intent
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.charge_alert/alarm"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val intent = Intent(this, AlarmService::class.java)
                    ContextCompat.startForegroundService(this, intent)
                    result.success(true)
                }
                "stopService" -> {
                    val intent = Intent(this, AlarmService::class.java)
                    stopService(intent)
                    result.success(true)
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
                                        // Often battery page is the best entry on Samsung
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
    }
}
