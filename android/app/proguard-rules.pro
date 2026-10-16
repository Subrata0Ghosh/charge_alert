-keep class * extends androidx.fragment.app.Fragment{}
-keep class androidx.lifecycle.DefaultLifecycleObserver
-keep class * extends com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

# ChargeAlert native activities and services
-keep class com.technorchid.charge_alert.** { *; }

# Audioplayers
-keep class xyz.luan.audioplayers.** { *; }
-dontwarn xyz.luan.audioplayers.**