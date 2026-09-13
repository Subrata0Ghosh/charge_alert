package com.technorchid.charge_alert

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import android.os.BatteryManager

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            val prefs = context.getSharedPreferences("ChargeAlertPrefs", Context.MODE_PRIVATE)
            val enabled = prefs.getBoolean("alarmEnabled", true)
            val target = prefs.getFloat("alertPercentage", 80f).toInt()
            val lowEnabled = prefs.getBoolean("lowAlarmEnabled", false)
            val guardianArmed = prefs.getBoolean("guardianArmed", false)

            // Query current battery state
            val bm = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            val level = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

            // ACTION_BATTERY_CHANGED sticky intent to detect if currently charging
            val batteryStatus = context.registerReceiver(null, android.content.IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
            val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL

            // Start MonitorService if any monitoring feature needs it:
            // - Charging: always start to track target
            // - Low battery alert enabled: need to monitor drain even when not charging
            // - Guardian armed: need to detect unplug events
            if (isCharging || lowEnabled || guardianArmed) {
                try {
                    val monitorIntent = Intent(context, MonitorService::class.java)
                    ContextCompat.startForegroundService(context, monitorIntent)
                } catch (_: Exception) {}

                // If threshold already reached while charging, start alarm immediately
                if (isCharging && enabled && level >= target) {
                    try {
                        val serviceIntent = Intent(context, AlarmService::class.java)
                        ContextCompat.startForegroundService(context, serviceIntent)
                    } catch (_: Exception) {}
                }
            }
        }
    }
}
