package com.edi.md.android.guid_gen

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
//import io.flutter.plugins.pathprovider.PathProviderPlugin

class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }
    
   /*  override fun registerWith(registry: PluginRegistry?) {
        if (registry != null) {
            FlutterLocalNotificationPluginRegistrant.registerWith(registry)
        } */

    override fun registerWith(registry: PluginRegistry?) {
         //io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.flutter.io/firebase_messaging_background"));
         //com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.registerWith(registry?.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
        // PathProviderPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"))

    }
}