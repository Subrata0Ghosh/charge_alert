package com.example.charge_alert

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

            // Query current battery state
            val bm = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            val level = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

            // ACTION_BATTERY_CHANGED sticky intent to detect if currently charging
            val batteryStatus = context.registerReceiver(null, android.content.IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
            val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL

            if (isCharging) {
                // Start monitor always when charging after boot
                val monitorIntent = Intent(context, MonitorService::class.java)
                ContextCompat.startForegroundService(context, monitorIntent)
                // If threshold already reached, start alarm immediately
                if (enabled && level >= target) {
                    val serviceIntent = Intent(context, AlarmService::class.java)
                    ContextCompat.startForegroundService(context, serviceIntent)
                }
            }
        }
    }
}
