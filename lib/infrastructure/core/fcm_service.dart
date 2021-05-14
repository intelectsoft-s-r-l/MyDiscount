import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../infrastructure/core/local_notification_service.dart';

import '../settings/settings_Impl.dart';

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
