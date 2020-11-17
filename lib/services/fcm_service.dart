import 'dart:async';

import 'dart:io';
import 'dart:typed_data';

import 'package:MyDiscount/models/received_notification.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

FirebaseMessaging _fcm = FirebaseMessaging();
FCMService fcmService = FCMService();

Future<dynamic> myBackgroundMessageHandler(
    Map<String, dynamic> notification) async {
  fcmService._showPublicNotification(notification);
}

class FCMService {
  /*  StreamController didReceiveLocalNotificationSubject =
      StreamController.broadcast(); */

  StreamController selectNotificationSubject = StreamController.broadcast();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void getFlutterLocalNotificationPlugin() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_stat_qq3');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      /*  onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
            body: body,
            title: title,
            id: id,
          ));} */
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
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

  Future<void> _showPublicNotification(notification) async {
    var vibrationPattern = Int64List(4);
    /*  vibrationPattern[0] = 0; */
    vibrationPattern[1] = 1000;
    /*  vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000; */

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'chanel_name', 'your channel description',
        importance: Importance.max,
        priority: Priority.max,
        enableLights: true,
        ledColor: Color(0x0000FF),
        ledOffMs: 2000,
        ledOnMs: 2000,
        color: Color(0x00FF00),
        enableVibration: true,
        vibrationPattern: vibrationPattern,
        visibility: NotificationVisibility.public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        int.parse('${notification['notification']['id']}'),
        '${notification['notification']['title']}',
        '${notification['notification']['body']}',
        platformChannelSpecifics,
        payload: 'item x');
    print('is showpublicnotification:${notification['data']}');
  }

  Future<void> _showNotification(notification) async {
    var vibrationPattern = Int64List(4);
    //vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    /* vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;*/

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

  void dispose() {
    fcmService.dispose();
  }

  Future<String> getfcmToken() async {
    String token = await _fcm.getToken();
    _fcm.onTokenRefresh.listen((event) {
      event = token;
    });
    print(token);
    return token;
  }

  void fcmConfigure() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: false, alert: false, badge: false));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> notification) async {
        final _notifications = notification['data'] ?? notification;
        final int id = int.parse(_notifications['id']).toInt();
        String title = _notifications['title'];
        String body = _notifications['body'];
        final ReceivedNotification receivedNotification =
            _receivedNotification.putIfAbsent(id,
                () => ReceivedNotification(id: id, title: title, body: body));
        workwithDB(receivedNotification);
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
}

Map<dynamic, ReceivedNotification> _receivedNotification = {};

//SharedPref prefs = SharedPref();
/*  getMessages()async{
   
   var data =await FbMessageDb.db
            .create(ReceivedNotification.fromJson());
        print(data);
 } */
/* ReceivedNotification _showNotifications(Map<String, dynamic> notification) {
  final Map<String, dynamic> _notifications =
      notification['data'] ?? notification;
  final int id = int.parse(_notifications['id']).toInt();
  String title = _notifications['title'];
  String body = _notifications['body'];
  final ReceivedNotification receivedNotification =
      _receivedNotification.putIfAbsent(
          id, () => ReceivedNotification(id: id, title: title, body: body));
  workwithDB(receivedNotification);
  print(receivedNotification);
  return receivedNotification;
}
*/
workwithDB(ReceivedNotification receivedNotification) async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  /*  Hive
    ..init(documentsDirectory.path)
    ..registerAdapter<ReceivedNotification>(ReceivedNotificationAdapter()); */
  var box = await Hive.openBox<ReceivedNotification>('testBox');
  //var notifications = receivedNotification;

  //box.add(receivedNotification);
  box.deleteFromDisk();
  // print(data);
}

/* Future<List<Map<String, dynamic>>> reedFromDB() async {
  var box = await Hive.openBox('testBox');
  List<Map<String, dynamic>> data =
      await box.watch().map((map) => map.value /* as Map<String, dynamic> */).toList();
  print('hivedata$data');
  return data;
} */

/* class ReceivedNotification {
  int id;
  String title;
  String body;
  /* String payload; */

  ReceivedNotification(
    /*  @required */ this.id,
    /* @required */ this.title,
    /* @required */ this.body,
    /*  this.payload, */
  );
} */
