import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../infrastructure/core/local_notification_service.dart';

import '../settings/settings_Impl.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FlutterLocalNotificationsPlugin().show(
      int.parse(message.data['id']),
      message.data['title'],
      message.data['body'],
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@mipmap/ic_notifications_icon',
        enableLights: true,
        ledColor: Color(0xFF0000FF),
        ledOffMs: 2000,
        ledOnMs: 2000,
        color: Color(0xFF00C569),
        enableVibration: true,
        // vibrationPattern: vibrationPattern,
      )));
  debugPrint('Handling a background message: ${message.messageId}');
}

@injectable
class FirebaseCloudMessageService {
  final FirebaseMessaging _fcm;
  final LocalNotificationsService? _localNotificationsService;

  final AppSettings _settings;

  FirebaseCloudMessageService(
      this._fcm, this._localNotificationsService, this._settings);

  void fcmConfigure() {
    _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((event) {
      print(event.data);
      _localNotificationsService!.showNotification(event.data);
    });
  }

  Future<String?> getfcmToken() async {
    await _fcm.setAutoInitEnabled(false);
    if (_settings.getSettings().notificationEnabled) {
      String? token;
      await _fcm.setAutoInitEnabled(true);
      token = await _fcm.getToken();
      _fcm.onTokenRefresh.listen((event) {
        token = event;
      });
      return token;
    } else {
      if (_fcm.isAutoInitEnabled) {
        await _fcm.deleteToken();
      }
      return '';
    }
  }
}
