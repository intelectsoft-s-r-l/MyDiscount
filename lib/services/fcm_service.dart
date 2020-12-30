import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_service.dart';

class FirebaseCloudMessageService {
  FirebaseMessaging _fcm = FirebaseMessaging();
  LocalNotificationsService _localNotificationsService =
      LocalNotificationsService();

  void fcmConfigure() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: false, alert: false, badge: false));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> notification) async {
        _localNotificationsService.showNotification(notification);
      },
      onResume: (Map<String, dynamic> notification) async {
        _localNotificationsService.showNotification(notification);
      },
      onLaunch: (Map<String, dynamic> notification) async {
        _localNotificationsService.showNotification(notification);
      },
    );
  }

  Future<String> getfcmToken() async {
    String token = await _fcm.getToken();
    _fcm.onTokenRefresh.listen((event) {
      event = token;
    });
    print(token);
    return token;
  }
}
