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
  /*  void _saveFCMState() async {
    _deactivateNotification();
    _settings.setSettings(
        _settings.getSettings().copyWith(notificationEnabled: _isActivate));
  } */

  /* void _deactivateNotification() async {
    
  } */

  Future<void> getFCMState() async {
    if (_settings.getSettings().notificationEnabled) {
      await _fcm.deleteToken();
    } else {
      await _fcm.setAutoInitEnabled(true);

      await getfcmToken();
    }
    //return _settings.getSettings().notificationEnabled;
  }

  void fcmConfigure() {
    _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((event) {
      print(event.data);
      _localNotificationsService!.showNotification(event.data);
    });
  }

  Future<String?> getfcmToken() async {
    if (!_settings.getSettings().notificationEnabled) {
      final token = await _fcm.getToken();
      _fcm.onTokenRefresh.listen((event) {
        event = token as String;
      });
      debugPrint(token);
      return token;
    } else {
      return '';
    }
  }
}
