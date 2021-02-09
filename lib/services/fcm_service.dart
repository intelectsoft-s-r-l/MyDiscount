import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../services/local_notification_service.dart';
import '../services/shared_preferences_service.dart';

@injectable
class FirebaseCloudMessageService with ChangeNotifier {
  final FirebaseMessaging _fcm;
  final LocalNotificationsService _localNotificationsService;
  final SharedPref _prefs;

  bool _isActivate = false;

  bool get isActivate => _isActivate;

  set isActivate(bool value) {
    _isActivate = value;
    _saveFCMState();
    notifyListeners();
  }

  FirebaseCloudMessageService(
      this._fcm, this._localNotificationsService, this._prefs) {
    getFCMState();
    notifyListeners();
  }
  void _saveFCMState() async {
    _prefs.saveFCMState(_isActivate);
  }

  getFCMState() async {
    final data = await _prefs.instance;
    if (data.containsKey('fcmState')) _isActivate = await _prefs.readFCMState();

    notifyListeners();
  }

  void fcmConfigure() {
    _fcm.requestNotificationPermissions(const IosNotificationSettings(
        sound: false, alert: false, badge: false));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {});
    _fcm.configure(
      onMessage: (Map<String, dynamic> notification) async {
        if (await _prefs.readFCMState()) {
          _localNotificationsService.showNotification(notification);
        }
      },
      onResume: (Map<String, dynamic> notification) async {
        if (await _prefs.readFCMState()) {
          _localNotificationsService.showNotification(notification);
        }
      },
      onLaunch: (Map<String, dynamic> notification) async {
        if (await _prefs.readFCMState()) {
          _localNotificationsService.showNotification(notification);
        }
      },
    );
  }

  Future<String> getfcmToken() async {
    final data = await _prefs.instance;
    if (data.containsKey('fcmState')) {
      if (await _prefs.readFCMState()) {
        final String token = await _fcm.getToken();
        _fcm.onTokenRefresh.listen((event) {
          event = token;
        });
        debugPrint(token);
        return token;
      } else {
        return '';
      }
    }
    return '';
  }
}
