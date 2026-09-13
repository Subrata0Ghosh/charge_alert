package com.technorchid.charge_alert

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.content.pm.ServiceInfo
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class MonitorService : Service() {
    private val CHANNEL_ID = "charge_monitor_channel"
    private val NOTIF_ID = 1002

    private var batteryReceiver: BroadcastReceiver? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private val handler = Handler(Looper.getMainLooper())

    // Fallback periodic check to ensure we catch battery level changes even
    // if ACTION_BATTERY_CHANGED delivery is throttled during Doze
    private val periodicCheck = object : Runnable {
        override fun run() {
            checkBatteryAndTrigger()
            handler.postDelayed(this, 60_000) // every 60 seconds
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        acquireWakeLock()
        startInForeground()
        registerBatteryReceiver()
        // Start fallback periodic polling after an initial 60s delay
        handler.postDelayed(periodicCheck, 60_000)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP_MONITOR") {
            stopSelf()
            return START_NOT_STICKY
        }
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(periodicCheck)
        releaseWakeLock()
        super.onDestroy()
        try {
            if (batteryReceiver != null) unregisterReceiver(batteryReceiver)
        } catch (_: Exception) {}
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                stopForeground(STOP_FOREGROUND_REMOVE)
            } else {
                @Suppress("DEPRECATION")
                stopForeground(true)
            }
        } catch (_: Exception) {}
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun acquireWakeLock() {
        try {
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock = pm.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "ChargeAlert::MonitorWakeLock"
            ).apply {
                acquire() // Held for the lifetime of the foreground service
            }
        } catch (_: Exception) {}
    }

    private fun releaseWakeLock() {
        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
            }
            wakeLock = null
        } catch (_: Exception) {}
    }

    /**
     * Fallback battery check using BatteryManager API (does not depend on
     * broadcast delivery). Called periodically by the Handler to guard
     * against Doze-throttled ACTION_BATTERY_CHANGED broadcasts.
     */
    private fun checkBatteryAndTrigger() {
        try {
            val bm = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            val percent = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

            // Determine charging status from the sticky battery intent
            val batteryStatus = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
            val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL

            val prefs = getSharedPreferences("ChargeAlertPrefs", Context.MODE_PRIVATE)
            val enabled = prefs.getBoolean("alarmEnabled", true)
            val target = prefs.getFloat("alertPercentage", 80f).toInt()
            val lowEnabled = prefs.getBoolean("lowAlarmEnabled", false)
            val lowTarget = prefs.getFloat("lowAlertPercentage", 15f).toInt()
            val guardianArmed = prefs.getBoolean("guardianArmed", false)

            if (percent >= 0) {
                updateNotification(percent, isCharging, target)

                if (isCharging) {
                    if (enabled && percent >= target && !AlarmService.isRunning) {
                        try {
                            val serviceIntent = Intent(this, AlarmService::class.java)
                            ContextCompat.startForegroundService(this, serviceIntent)
                        } catch (_: Exception) {}
                    }
                } else {
                    // Low-battery alarm
                    if (lowEnabled && percent <= lowTarget && !AlarmService.isRunning) {
                        try {
                            val serviceIntent = Intent(this, AlarmService::class.java)
                            ContextCompat.startForegroundService(this, serviceIntent)
                        } catch (_: Exception) {}
                    }
                }
            }
        } catch (_: Exception) {}
    }

    private fun buildNotification(contentText: String): Notification {
        val stopIntent = Intent(this, MonitorService::class.java).apply { action = "STOP_MONITOR" }
        val stopPending = PendingIntent.getService(
            this,
            2,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("ChargeAlert")
            .setContentText(contentText)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .setOngoing(true)
            .addAction(R.mipmap.ic_launcher, "Stop", stopPending)
            .build()
    }

    private fun startInForeground() {
        val notification = buildNotification("Monitoring battery charging status")
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(NOTIF_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE)
            } else {
                startForeground(NOTIF_ID, notification)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun updateNotification(percent: Int, isCharging: Boolean, target: Int) {
        val text = if (isCharging) {
            "Charging: $percent% • Alert at $target%"
        } else {
            "Battery: $percent% • Monitoring"
        }
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(NOTIF_ID, buildNotification(text))
    }

    private fun registerBatteryReceiver() {
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_BATTERY_CHANGED)
            addAction(Intent.ACTION_POWER_DISCONNECTED)
            addAction(Intent.ACTION_POWER_CONNECTED)
        }
        batteryReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                when (intent.action) {
                    Intent.ACTION_POWER_CONNECTED -> {
                        // Keep monitoring
                    }
                    Intent.ACTION_POWER_DISCONNECTED -> {
                        val prefs = context.getSharedPreferences("ChargeAlertPrefs", Context.MODE_PRIVATE)
                        val lowEnabled = prefs.getBoolean("lowAlarmEnabled", false)
                        val guardianArmed = prefs.getBoolean("guardianArmed", false)
                        if (guardianArmed) {
                            try {
                                val startAlarm = Intent(context, AlarmService::class.java).apply {
                                    putExtra("isTheftAlarm", true)
                                }
                                ContextCompat.startForegroundService(context, startAlarm)
                            } catch (_: Exception) {}
                            try {
                                val mainIntent = Intent(context, MainActivity::class.java).apply {
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                                    putExtra("isTheftAlarm", true)
                                }
                                context.startActivity(mainIntent)
                            } catch (_: Exception) {}
                        } else if (!lowEnabled) {
                            try {
                                val stopAlarm = Intent(context, AlarmService::class.java).apply { action = "STOP_ALARM" }
                                context.startService(stopAlarm)
                            } catch (_: Exception) {}
                            stopSelf()
                        }
                    }
                    Intent.ACTION_BATTERY_CHANGED -> {
                        val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                        val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL
                        val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                        val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                        val percent = if (level >= 0 && scale > 0) (level * 100) / scale else -1

                        val prefs = context.getSharedPreferences("ChargeAlertPrefs", Context.MODE_PRIVATE)
                        val enabled = prefs.getBoolean("alarmEnabled", true)
                        val target = prefs.getFloat("alertPercentage", 80f).toInt()
                        val lowEnabled = prefs.getBoolean("lowAlarmEnabled", false)
                        val lowTarget = prefs.getFloat("lowAlertPercentage", 15f).toInt()

                        if (percent >= 0) {
                            updateNotification(percent, isCharging, target)

                            if (isCharging) {
                                if (enabled && percent >= target) {
                                    try {
                                        val serviceIntent = Intent(context, AlarmService::class.java)
                                        ContextCompat.startForegroundService(context, serviceIntent)
                                    } catch (_: Exception) {}
                                }
                            } else {
                                if (lowEnabled && percent <= lowTarget) {
                                    try {
                                        val serviceIntent = Intent(context, AlarmService::class.java)
                                        ContextCompat.startForegroundService(context, serviceIntent)
                                    } catch (_: Exception) {}
                                }
                            }
                        }
                    }
                }
            }
        }
        registerReceiver(batteryReceiver, filter)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Charge Monitor"
            val importance = NotificationManager.IMPORTANCE_MIN
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = "Channel for monitoring charging state"
                setSound(null, null)
                enableVibration(false)
            }
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.createNotificationChannel(channel)
        }
    }
}
