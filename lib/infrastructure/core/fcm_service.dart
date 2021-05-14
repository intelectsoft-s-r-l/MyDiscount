import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:my_discount/infrastructure/settings/settings_Impl.dart';

import '../../infrastructure/core/local_notification_service.dart';

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
    print(
        'notificationIsEnabled:${_settings.getSettings().notificationEnabled}');
    if (_settings.getSettings().notificationEnabled) {
      String? token;
      await _fcm.setAutoInitEnabled(true);
      token = await _fcm.getToken();
      _fcm.onTokenRefresh.listen((event) {
        token = event;
      });
      debugPrint(token);
      return token;
    } else {
      await _fcm.deleteToken();
      return '';
    }
  }
}
