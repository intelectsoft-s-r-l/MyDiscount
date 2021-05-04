import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../infrastructure/core/local_notification_service.dart';
import '../../infrastructure/core/shared_preferences_service.dart';

@injectable
class FirebaseCloudMessageService with ChangeNotifier {
  final FirebaseMessaging _fcm;
  final LocalNotificationsService? _localNotificationsService;

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
    _deactivateNotification();
    _prefs.saveFCMState(_isActivate);
  }

  void _deactivateNotification() async {
    if (!_isActivate) {
     await _fcm.deleteToken();
    } else {
      await _fcm.setAutoInitEnabled(true);

      await getfcmToken();
    }
  }

  Future<bool?> getFCMState() async {
    final data = await _prefs.instance;
    if (data.containsKey('fcmState')) _isActivate = await _prefs.readFCMState();
    notifyListeners();
    return _isActivate;
  }

  void fcmConfigure() {
    _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((event) {
      print(event.data);
      _localNotificationsService!.showNotification(event.data);
    });
  }

  Future<String?> getfcmToken() async {
    final data = await _prefs.instance;
    if (data.containsKey('fcmState')) {
      if (await _prefs.readFCMState()) {
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
    return '';
  }
}