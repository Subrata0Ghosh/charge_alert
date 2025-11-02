package com.example.charge_alert

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
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class MonitorService : Service() {
    private val CHANNEL_ID = "charge_monitor_channel"
    private val NOTIF_ID = 1002

    private var batteryReceiver: BroadcastReceiver? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startInForeground()
        registerBatteryReceiver()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP_MONITOR") {
            stopSelf()
            return START_NOT_STICKY
        }
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            if (batteryReceiver != null) unregisterReceiver(batteryReceiver)
        } catch (_: Exception) {}
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun startInForeground() {
        val stopIntent = Intent(this, MonitorService::class.java).apply { action = "STOP_MONITOR" }
        val stopPending = PendingIntent.getService(
            this,
            2,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
        )

        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("ChargeAlert")
            .setContentText("Monitoring battery")
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .addAction(R.mipmap.ic_launcher, "Stop", stopPending)
            .build()

        startForeground(NOTIF_ID, notification)
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
                        // no-op: continue monitoring for high target via BATTERY_CHANGED
                    }
                    Intent.ACTION_POWER_DISCONNECTED -> {
                        // If low alarm is enabled, keep monitoring for low threshold; otherwise stop
                        val prefs = context.getSharedPreferences("ChargeAlertPrefs", Context.MODE_PRIVATE)
                        val lowEnabled = prefs.getBoolean("lowAlarmEnabled", false)
                        if (!lowEnabled) {
                            try {
                                val stopAlarm = Intent(context, AlarmService::class.java).apply { action = "STOP_ALARM" }
                                ContextCompat.startForegroundService(context, stopAlarm)
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
                            if (isCharging) {
                                if (enabled && percent >= target) {
                                    val serviceIntent = Intent(context, AlarmService::class.java)
                                    ContextCompat.startForegroundService(context, serviceIntent)
                                }
                            } else {
                                if (lowEnabled && percent <= lowTarget) {
                                    val serviceIntent = Intent(context, AlarmService::class.java)
                                    ContextCompat.startForegroundService(context, serviceIntent)
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
            val channel = NotificationChannel(CHANNEL_ID, name, importance)
            channel.description = "Channel for monitoring charging state"
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.createNotificationChannel(channel)
        }
    }
}
