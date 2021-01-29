import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import '../services/shared_preferences_service.dart';
import '../services/local_notification_service.dart';
  SharedPref _prefs = SharedPref();
  final _localNotificationsService = LocalNotificationsService();
Future <dynamic>backgroundMessage(Map<String,dynamic> notification)async{
 _localNotificationsService.showNotification(notification);
  }

class FirebaseCloudMessageService with ChangeNotifier {
  FirebaseMessaging _fcm = FirebaseMessaging();

  bool _isActivate = false;

  bool get isActivate => _isActivate;

  set isActivate(bool value) {
    _isActivate = value;
    _saveFCMState();
    notifyListeners();
  }

  FirebaseCloudMessageService() {
    getFCMState();
    notifyListeners();
  }
  _saveFCMState() async {
    _deactivateNotification();
    _prefs.saveFCMState(_isActivate);
  }

  _deactivateNotification() async {
    if (!_isActivate) {
      final deletedInstanceId = await _fcm.deleteInstanceID();
      print('deletedInstanceId: $deletedInstanceId');
      //_fcm.setAutoInitEnabled(false);
    } else {
      _fcm.setAutoInitEnabled(true);
     // _fcm.requestNotificationPermissions();
      getfcmToken();
    }
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
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {});
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
      onBackgroundMessage: backgroundMessage
    );
  }

 

  Future<String> getfcmToken() async {
    final data = await _prefs.instance;
    if (data.containsKey('fcmState')) if (await _prefs.readFCMState()) {
      String token = await _fcm.getToken();
      _fcm.onTokenRefresh.listen((event) {
        event = token;
      });
      debugPrint(token);
      return token;
    } else {
      return '';
    }
    return '';
  }
}
