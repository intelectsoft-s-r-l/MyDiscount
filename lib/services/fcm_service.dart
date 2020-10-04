import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FirebaseMessaging _fcm = FirebaseMessaging();
FCMService fcmService = FCMService();

Future<dynamic> myBackgroundMessageHandler(
    Map<String, dynamic> notification) async {
  fcmService._showPublicNotification(notification);
}

class FCMService {
  var _notificationAppLaunchDetails;

  StreamController didReceiveLocalNotificationSubject =
      StreamController.broadcast();

  StreamController selectNotificationSubject = StreamController.broadcast();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  get notificationAppLaunchDetails => _notificationAppLaunchDetails;

  void getFlutterLocalNotificationPlugin() async {
    _notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSetingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_stat_qq3');

    var initializationSetingsIos = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      /*   onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
            body: body,
            title: title,
            id: id,
          ));
        }*/
    );

    var initializationSettings = InitializationSettings(
        initializationSetingsAndroid, initializationSetingsIos);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (notification) async {
        selectNotificationSubject.add(notification);
      },
    );
  }

  Future<void> _showPublicNotification(notification) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'chanel_name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.Max,
        enableLights: true,
        ledColor: Color(0x0000FF),
        ledOffMs: 2000,
        ledOnMs: 2000,
        color: Color(0x00C569),
        enableVibration: true,
        vibrationPattern: vibrationPattern,
        visibility: NotificationVisibility.Public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        int.parse('${notification['data']['id']}'),
        '${notification['data']['title']}',
        '${notification['data']['body']}',
        platformChannelSpecifics,
        payload: 'item x');
    print('is showpublicnotification:${notification['data']}');
  }

  Future<void> _showNotification(notification) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.Max,
      icon: '@mipmap/ic_stat_qq3',
      enableLights: true,
      ledColor: Color(0x0000FF),
      ledOffMs: 2000,
      ledOnMs: 2000,
      color: Color(0x00C569),
      enableVibration: true,
      vibrationPattern: vibrationPattern,
    );
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
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

  Future<String> getfcmToken() async {
    String token = await _fcm.getToken();
    _fcm.onTokenRefresh.listen((event) {
      event = token;
    });
    print(token);
    return token;
  }

  void deleteNotification() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  void dispose() {
    selectNotificationSubject.close();
    didReceiveLocalNotificationSubject.close();
  }

  void fcmConfigure() {
    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> notification) async {
        _showNotification(notification);
      },
      onResume: (Map<String, dynamic> notification) async {
        _showNotification(notification);
      },
      onLaunch: (Map<String, dynamic> notification) async {
        _showNotification(notification);
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    );
  }

  /*  Future<void> _showBigTextNotification(notification) async {
    _showNotifications(notification);
    var bigTextStyleInformation = BigTextStyleInformation(
        '<i>${notification['data']['body']}</i>',
        htmlFormatBigText: true,
        contentTitle: ' <b>${notification['data']['title']}</b> ',
        htmlFormatContentTitle: true,
        summaryText: ' <i>${notification['data']['sumary']}</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        styleInformation: bigTextStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0,
        '${notification['data']['title']}',
        '${notification['data']['body']}',
        platformChannelSpecifics);
  } */
}

/* Map<dynamic, ReceivedNotification> _receivedNotification = {};

ReceivedNotification _showNotifications(Map<String, dynamic> notification) {
  final dynamic _notifications = notification['data'] ?? notification;
  final int id = int.parse(_notifications['id']).toInt();
  String title = _notifications['title'];
  String body = _notifications['body'];
  final ReceivedNotification receivedNotification =
      _receivedNotification.putIfAbsent(
          id, () => ReceivedNotification(id: id, title: title, body: body));
  return receivedNotification;
} */

/* class ReceivedNotification {
  final int id;
  String title;
  String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    this.payload,
  });
} */
