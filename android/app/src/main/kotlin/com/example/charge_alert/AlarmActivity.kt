package com.example.charge_alert

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.app.Activity
import android.view.WindowManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.IntentFilter

class AlarmActivity : Activity() {
    private var stopReceiver: BroadcastReceiver? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Show over lock screen and turn screen on for true alarm-like behavior
        @Suppress("DEPRECATION")
        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
        )
        window.decorView.systemUiVisibility = (
            View.SYSTEM_UI_FLAG_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
        )
        setContentView(R.layout.activity_alarm)

        val stopBtn = findViewById<Button>(R.id.stopButton)
        stopBtn.setOnClickListener {
            val intent = Intent(this, AlarmService::class.java)
            intent.action = "STOP_ALARM"
            startService(intent)
            // Finish and remove from recent to avoid lingering black screen
            finishAndRemoveTask()
        }

        // Close screen if alarm stops externally (e.g., unplug)
        stopReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == "com.example.charge_alert.ALARM_STOPPED") {
                    finishAndRemoveTask()
                }
            }
        }
        registerReceiver(stopReceiver, IntentFilter("com.example.charge_alert.ALARM_STOPPED"))
    }

    override fun onDestroy() {
        try { if (stopReceiver != null) unregisterReceiver(stopReceiver) } catch (_: Exception) {}
        super.onDestroy()
    }
}

