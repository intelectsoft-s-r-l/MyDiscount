import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:MyDiscount/domain/entities/received_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocalNotificationsService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotificationsService(this.flutterLocalNotificationsPlugin);

  StreamController didReceiveLocalNotificationSubject = StreamController.broadcast();

  StreamController selectNotificationSubject = StreamController.broadcast();

  void getFlutterLocalNotificationPlugin() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_stat_qq3');

    final initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
            body: body,
            title: title,
            id: id,
          ));
        });

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (notification) async {
        selectNotificationSubject.add(notification);
      },
    );
  }

  Future<void> showNotification(Map<String, dynamic> notification) async {
    final vibrationPattern = Int64List(4);

    vibrationPattern[1] = 1000;

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_notifications_icon',
      enableLights: true,
      ledColor: const Color(0xFF0000FF),
      ledOffMs: 2000,
      ledOnMs: 2000,
      color: const Color(0xFF00C569),
      enableVibration: true,
      vibrationPattern: vibrationPattern,
    );
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );
    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      Platform.isIOS ? int.parse(notification['id'] as String) : int.parse(notification['data']['id'] as String),
      Platform.isIOS ? '${notification['title']}' : '${notification['notification']['title']}',
      Platform.isIOS ? '${notification['body']}' : '${notification['notification']['body']}',
      platformChannelSpecifics,
    );
    debugPrint('is shownotification:$notification');
  }
}
