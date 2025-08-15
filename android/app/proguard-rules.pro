# Keep connectivity_plus classes
-keep class io.flutter.plugins.connectivity.** { *; }
-keep class dev.fluttercommunity.plus.connectivity.** { *; }

# Keep network state related classes
-keep class android.net.** { *; }
-keep class android.telephony.** { *; }

# Keep Flutter plugins
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep local notifications
-keep class com.dexterous.** { *; }

# Prevent obfuscation of native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep connectivity broadcast receivers
-keep class * extends android.content.BroadcastReceiver {
    public <init>(android.content.Context, android.util.AttributeSet);
}

# Keep network callback classes
-keep class * extends android.net.ConnectivityManager$NetworkCallback {
    *;
}
