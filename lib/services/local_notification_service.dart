import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/received_notification.dart';

class LocalNotificationsService {
  StreamController didReceiveLocalNotificationSubject =
      StreamController.broadcast();

  StreamController selectNotificationSubject = StreamController.broadcast();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void getFlutterLocalNotificationPlugin() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_stat_qq3');

    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
            body: body,
            title: title,
            id: id,
          ));
        });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
   /* final bool result = await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
    ); */
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (notification) async {
        selectNotificationSubject.add(notification);
      },
    );
  }

  Future<void> showNotification(notification) async {
    var vibrationPattern = Int64List(4);

    vibrationPattern[1] = 1000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_stat_qq3',
      enableLights: true,
      ledColor: Color(0x0000FF),
      ledOffMs: 2000,
      ledOnMs: 2000,
      color: Color(0x00C569),
      enableVibration: true,
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      Platform.isIOS
          ? int.parse(notification['id'])
          : int.parse(notification['data']['id']),
      Platform.isIOS
          ? '${notification['title']}'
          : '${notification['data']['title']}',
      Platform.isIOS
          ? '${notification['body']}'
          : '${notification['data']['body']}',
      platformChannelSpecifics,
    );
    print('is shownotification:$notification');
  }
}
