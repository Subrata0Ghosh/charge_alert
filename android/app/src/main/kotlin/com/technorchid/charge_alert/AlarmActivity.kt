package com.technorchid.charge_alert

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.app.Activity
import android.view.WindowManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.IntentFilter

import android.os.Build

class AlarmActivity : Activity() {
    private var stopReceiver: BroadcastReceiver? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Show over lock screen and turn screen on for true alarm-like behavior
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }
        @Suppress("DEPRECATION")
        window.decorView.systemUiVisibility = (
            View.SYSTEM_UI_FLAG_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
        )
        setContentView(R.layout.activity_alarm)

        val stopBtn = findViewById<Button>(R.id.stopButton)
        stopBtn.setOnClickListener {
            val intent = Intent(this, AlarmService::class.java).apply { action = "STOP_ALARM" }
            startService(intent)
            finishAndRemoveTask()
        }

        // Close screen if alarm stops externally (e.g., unplug)
        stopReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == "com.technorchid.charge_alert.ALARM_STOPPED") {
                    finishAndRemoveTask()
                }
            }
        }
        val filter = IntentFilter("com.technorchid.charge_alert.ALARM_STOPPED")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(stopReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(stopReceiver, filter)
        }
    }

    override fun onDestroy() {
        try { if (stopReceiver != null) unregisterReceiver(stopReceiver) } catch (_: Exception) {}
        super.onDestroy()
    }
}
