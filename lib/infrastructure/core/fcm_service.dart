import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:my_discount/infrastructure/settings/settings_Impl.dart';

import '../../infrastructure/core/local_notification_service.dart';


@injectable
class FirebaseCloudMessageService with ChangeNotifier {
  final FirebaseMessaging _fcm;
  final LocalNotificationsService? _localNotificationsService;

  final AppSettings _settings;

  bool _isActivate = false;

  bool get isActivate => _isActivate;

  set isActivate(bool value) {
    _isActivate = value;
    _saveFCMState();
    notifyListeners();
  }

  FirebaseCloudMessageService(
      this._fcm, this._localNotificationsService, this._settings) {
    getFCMState();
    notifyListeners();
  }
  void _saveFCMState() async {
    _deactivateNotification();
    _settings.setSettings(_settings.getSettings().copyWith(notificationEnabled: _isActivate));
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
    //final data = await _prefs.instance;
    /* if (data.containsKey('fcmState')) */ _isActivate = _settings.getSettings().notificationEnabled;
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
   // final data = await _prefs.instance;
    /* if (data.containsKey('fcmState')) { */
      if (_settings.getSettings().notificationEnabled) {
        final token = await _fcm.getToken();
        _fcm.onTokenRefresh.listen((event) {
          event = token as String;
        });
        debugPrint(token);
        return token;
      } else {
        return '';
      }
   /*  }
    return '';*/
  }
}
