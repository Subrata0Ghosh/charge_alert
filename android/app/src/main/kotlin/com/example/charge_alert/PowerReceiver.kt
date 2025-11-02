package com.example.charge_alert

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.BatteryManager
import androidx.core.content.ContextCompat

class PowerReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_POWER_CONNECTED -> {
                // Always start the monitor service when power connects
                val monitorIntent = Intent(context, MonitorService::class.java)
                ContextCompat.startForegroundService(context, monitorIntent)

                // Also immediately check current level and start alarm if already at/above target
                val prefs = context.getSharedPreferences("ChargeAlertPrefs", Context.MODE_PRIVATE)
                val enabled = prefs.getBoolean("alarmEnabled", true)
                val target = prefs.getFloat("alertPercentage", 80f).toInt()

                val bm = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                val level = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

                if (enabled && level >= target) {
                    val serviceIntent = Intent(context, AlarmService::class.java)
                    ContextCompat.startForegroundService(context, serviceIntent)
                }
            }
            Intent.ACTION_POWER_DISCONNECTED -> {
                // Stop active alarm, and only stop monitoring if low-battery alert is disabled
                try {
                    val stopAlarm = Intent(context, AlarmService::class.java).apply { action = "STOP_ALARM" }
                    ContextCompat.startForegroundService(context, stopAlarm)
                } catch (_: Exception) {}
                val prefs = context.getSharedPreferences("ChargeAlertPrefs", Context.MODE_PRIVATE)
                val lowEnabled = prefs.getBoolean("lowAlarmEnabled", false)
                if (!lowEnabled) {
                    context.stopService(Intent(context, MonitorService::class.java))
                } else {
                    // Ensure monitor keeps running for low-battery tracking
                    val monitorIntent = Intent(context, MonitorService::class.java)
                    ContextCompat.startForegroundService(context, monitorIntent)
                }
            }
        }
    }
}

