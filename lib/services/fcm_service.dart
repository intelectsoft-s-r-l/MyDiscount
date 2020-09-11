import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FirebaseMessaging _fcm = FirebaseMessaging();
FCMService fcmService = FCMService();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  
  /* if (message.containsKey('data')) {
    final dynamic data = message['data'];
    print('this is data:$data');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        icon: '@mipmap/ic_notifications_icon',
        enableLights: true,
        enableVibration: true);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await fcmService.flutterLocalNotificationsPlugin.show(int.parse(data['id']),
        "${data['title']}", '${data['body']}', platformChannelSpecifics);
    //fcmService._showNotification(message);
  } */
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
        AndroidInitializationSettings('@mipmap/ic_notifications_icon');

    var initializationSetingsIos = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });

    var initializationSettings = InitializationSettings(
        initializationSetingsAndroid, initializationSetingsIos);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (message) async {
        selectNotificationSubject.add(message);
      },
    );
  }

  Future<void> _showNotification(messages) async {
    _messageFromCloud(messages);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        icon: '@mipmap/ic_notifications_icon',
        enableLights: true,
        enableVibration: true);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        int.parse('${messages['data']['id']}'),
        '${messages['data']['title']}',
        '${messages['data']['body']}',
        platformChannelSpecifics,
        payload: '${messages['body']}');
    print('is shownotification:${messages['data']}');
  }

  Future<String> getfcmToken() async {
    var token = await _fcm.getToken();
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
      onMessage: (Map<String, dynamic> messages) async {
        print('$messages');
        _showNotification(messages);
      },
      /*   onResume: (Map<String, dynamic> messages) async {
        print('$messages');
        _showNotification(messages);
      },*/
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    );
  }
}

Map<String, Message> _messages = <String, Message>{};
Message _messageFromCloud(Map<String, dynamic> messages) {
  final dynamic notification = messages['data'] ?? messages;
  final dynamic body = notification['body'];
  final Message message = _messages.putIfAbsent(body, () => Message(body: body))
    ..title = notification['title'];

  return message;
}

class Message {
  final String body;
  String _title;
  Message({this.body});
  StreamController<Message> _messageController =
      StreamController<Message>.broadcast();
  Stream<Message> get onChangedMessage => _messageController.stream;

  String get title => _title;
  set title(String value) {
    _title = value;
    _messageController.add(this);
  }
}
