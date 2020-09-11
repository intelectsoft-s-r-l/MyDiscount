package com.edi.md.android.guid_gen

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.engine.FlutterEngine;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin

class MainActivity : FlutterActivity(), PluginRegistry.PluginRegistrantCallback {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
      
        
    }
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
GeneratedPluginRegistrant.registerWith(flutterEngine); }

    override fun registerWith(registry: PluginRegistry?) {
        if (!registry!!.hasPlugin("io.flutter.plugins.firebasemessaging")) {
            FirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        }
        if (!registry!!.hasPlugin("dexterous.com/flutter/local_notifications")) {
           FlutterLocalNotificationsPlugin.registerWith(registry!!.registrarFor("dexterous.com/flutter/local_notifications"));
        }
    }

}
