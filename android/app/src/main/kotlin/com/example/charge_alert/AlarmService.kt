package com.example.charge_alert

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
import androidx.core.app.NotificationCompat

class AlarmService : Service() {
    private var player: MediaPlayer? = null
    private val CHANNEL_ID = "charge_alert_channel"
    private val NOTIF_ID = 1001

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Build fullscreen intent to show AlarmActivity
        val fullScreenIntent = Intent(this, AlarmActivity::class.java)
        fullScreenIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        val fullScreenPendingIntent = PendingIntent.getActivity(
            this,
            0,
            fullScreenIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
        )

        // Stop action
        val stopIntent = Intent(this, AlarmService::class.java)
        stopIntent.action = "STOP_ALARM"
        val stopPending = PendingIntent.getService(
            this,
            1,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
        )

        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("ChargeAlert")
            .setContentText("Charging alarm is active")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setFullScreenIntent(fullScreenPendingIntent, true)
            .addAction(R.mipmap.ic_launcher, "Stop", stopPending)
            .setOngoing(true)
            .build()

        startForeground(NOTIF_ID, notification)

        // Handle stop action
        if (intent?.action == "STOP_ALARM") {
            stopSelf()
            return START_NOT_STICKY
        }

        // Start playing the alarm sound in loop
        try {
            if (player == null) {
                player = MediaPlayer()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    player?.setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                            .build()
                    )
                }
                val afd = resources.openRawResourceFd(R.raw.notification)
                player?.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                afd.close()
                player?.isLooping = true
                player?.prepare()
                player?.start()
            } else if (!(player?.isPlaying ?: false)) {
                player?.start()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            player?.stop()
            player?.release()
            player = null
        } catch (e: Exception) {
            e.printStackTrace()
        }
        try {
            stopForeground(true)
        } catch (_: Exception) {}
        // Notify any UI to close
        val stopped = Intent("com.example.charge_alert.ALARM_STOPPED")
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
            val channel = NotificationChannel(CHANNEL_ID, name, importance)
            channel.description = "Channel for charge alert foreground service"
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.createNotificationChannel(channel)
        }
    }
}
