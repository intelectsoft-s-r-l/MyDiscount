import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import '../services/shared_preferences_service.dart';
import '../services/local_notification_service.dart';

class FirebaseCloudMessageService with ChangeNotifier {
  FirebaseMessaging _fcm = FirebaseMessaging();
  final _localNotificationsService = LocalNotificationsService();
  SharedPref _prefs = SharedPref();

  bool _isActivate = false;

  bool get isActivate => _isActivate;

  set isActivate(bool value) {
    _isActivate = value;
    _saveFCMState();
    notifyListeners();
  }

  FirebaseCloudMessageService() {
    // _saveFCMState();
    getFCMState();
    notifyListeners();
  }
  _saveFCMState() async {
    _prefs.saveFCMState(_isActivate);
  }

  checkIfContainKey() async {}

  getFCMState() async {
    final data = await _prefs.instance;
    if (data.containsKey('fcmState')) _isActivate = await _prefs.readFCMState();

    notifyListeners();
  }

  void fcmConfigure() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: false, alert: false, badge: false));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> notification) async {
        if (await _prefs.readFCMState())
          _localNotificationsService.showNotification(notification);
      },
      onResume: (Map<String, dynamic> notification) async {
        if (await _prefs.readFCMState())
          _localNotificationsService.showNotification(notification);
      },
      onLaunch: (Map<String, dynamic> notification) async {
        if (await _prefs.readFCMState())
          _localNotificationsService.showNotification(notification);
      },
    );
  }

  Future<String> getfcmToken() async {
    final data = await _prefs.instance;
    if (data.containsKey('fcmState')) if (await _prefs.readFCMState()) {
      String token = await _fcm.getToken();
      _fcm.onTokenRefresh.listen((event) {
        event = token;
      });
      print(token);
      return token;
    } else {
      return '';
    }
    return '';
  }
}
