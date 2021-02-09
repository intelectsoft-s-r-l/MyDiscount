import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/credentials.dart';
import '../../core/formater.dart';
import '../../services/shared_preferences_service.dart';

@module
abstract class ServiceInjectableModule {
  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();
  @lazySingleton
  FacebookLogin get facebookLogin => FacebookLogin();
  @lazySingleton
  FirebaseMessaging get fcm => FirebaseMessaging();
  @lazySingleton
  FlutterLocalNotificationsPlugin get flutterLocalNotification =>
      FlutterLocalNotificationsPlugin();
  @lazySingleton
  SharedPref get prefs => SharedPref();
  @lazySingleton
  DataConnectionChecker get connectionChecker => DataConnectionChecker();
  @lazySingleton
  DeviceInfoPlugin get deviceinfo => DeviceInfoPlugin();
  @lazySingleton
  Formater get formater => Formater();
  @lazySingleton
  Credentials get credentials => Credentials();
}
