package com.technorchid.charge_alert

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.media.AudioAttributes
import android.os.Build
import android.os.IBinder
import android.content.pm.ServiceInfo
import androidx.core.app.NotificationCompat

class AlarmService : Service() {
    companion object {
        @Volatile
        var isRunning: Boolean = false
        @Volatile
        var isTheftActive: Boolean = false
    }

    private var player: MediaPlayer? = null
    private val CHANNEL_ID = "charge_alert_channel"
    private val NOTIF_ID = 1001

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val prefs = getSharedPreferences("ChargeAlertPrefs", Context.MODE_PRIVATE)
        val explicitTheft = intent?.getBooleanExtra("isTheftAlarm", false) == true
        val isTheft = if (explicitTheft || isTheftActive) {
            true
        } else if (prefs.getBoolean("guardianArmed", false)) {
            // Only consider theft if device is unplugged from power
            val ifilter = android.content.IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            val bIntent = registerReceiver(null, ifilter)
            val plugged = bIntent?.getIntExtra(android.os.BatteryManager.EXTRA_PLUGGED, 0) ?: 0
            plugged == 0
        } else {
            false
        }
        if (isTheft) {
            isTheftActive = true
        }

        // Handle stop action
        if (intent?.action == "STOP_ALARM") {
            val isAuthorized = intent.getBooleanExtra("authorized_theft_stop", false)
            if (isTheftActive && !isAuthorized) {
                // Security: Do not allow unauthorized dismissal during an active theft emergency!
                return START_STICKY
            }
            isTheftActive = false
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    stopForeground(STOP_FOREGROUND_REMOVE)
                } else {
                    @Suppress("DEPRECATION")
                    stopForeground(true)
                }
            } catch (_: Exception) {}
            stopSelf()
            return START_NOT_STICKY
        }

        // Build target intent: during theft alarm, route directly to MainActivity with PIN lockout screen.
        // For normal charging alarms, route to AlarmActivity.
        val targetIntent = if (isTheft) {
            Intent(this, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                putExtra("isTheftAlarm", true)
            }
        } else {
            Intent(this, AlarmActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            }
        }

        val fullScreenPendingIntent = PendingIntent.getActivity(
            this,
            0,
            targetIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
        )

        val notifBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(if (isTheft) "🚨 THEFT ALARM TRIGGERED!" else "ChargeAlert")
            .setContentText(
                if (isTheft) "Charger was disconnected! Tap to disarm with PIN."
                else "Charging alarm is ringing! Tap to stop."
            )
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setFullScreenIntent(fullScreenPendingIntent, true)
            .setContentIntent(fullScreenPendingIntent)
            .setOngoing(true)
            .setAutoCancel(false)

        // Only add "Stop" action button for normal charging alerts.
        // During emergency theft alarm, NO stop button is shown so the alarm cannot be bypassed without PIN!
        if (!isTheft) {
            val stopIntent = Intent(this, AlarmService::class.java).apply { action = "STOP_ALARM" }
            val stopPending = PendingIntent.getService(
                this,
                1,
                stopIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
            )
            notifBuilder.addAction(R.mipmap.ic_launcher, "Stop", stopPending)
        }

        val notification: Notification = notifBuilder.build()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(NOTIF_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
        } else {
            startForeground(NOTIF_ID, notification)
        }

        isRunning = true
        val started = Intent("com.technorchid.charge_alert.ALARM_STARTED")
        started.setPackage(packageName)
        sendBroadcast(started)

        // For emergency theft alarm, always loop siren continuously until disarmed with PIN
        val isContinuous = isTheft || prefs.getBoolean("continuousAlarm", false)

        // Start playing the alarm sound
        try {
            if (player == null) {
                player = MediaPlayer()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    player?.setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build()
                    )
                }
                val afd = resources.openRawResourceFd(R.raw.notification)
                player?.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                afd.close()
                player?.isLooping = isContinuous
                player?.setOnCompletionListener {
                    if (!isContinuous) {
                        stopSelf()
                    }
                }
                player?.prepare()
                player?.start()
            } else if (!(player?.isPlaying ?: false)) {
                player?.isLooping = isContinuous
                player?.start()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return START_STICKY
    }

    override fun onDestroy() {
        isRunning = false
        isTheftActive = false
        super.onDestroy()
        try {
            player?.stop()
            player?.release()
            player = null
        } catch (e: Exception) {
            e.printStackTrace()
        }
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                stopForeground(STOP_FOREGROUND_REMOVE)
            } else {
                @Suppress("DEPRECATION")
                stopForeground(true)
            }
        } catch (_: Exception) {}

        // Notify UI components that alarm stopped
        val stopped = Intent("com.technorchid.charge_alert.ALARM_STOPPED")
        stopped.setPackage(packageName)
        sendBroadcast(stopped)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "ChargeAlert Channel"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = "Channel for charge alert foreground service"
                // Mute notification sound so it doesn't clash with MediaPlayer alarm tone
                setSound(null, null)
                enableVibration(true)
            }
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.createNotificationChannel(channel)
        }
    }
}
