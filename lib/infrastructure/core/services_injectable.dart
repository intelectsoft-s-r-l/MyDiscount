import 'package:is_service/service_client.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:my_discount/domain/settings/settings.dart';

import '../../core/constants/credentials.dart';
import '../../core/formater.dart';
import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';
import '../../domain/entities/user_model.dart';
import '../../infrastructure/core/remote_config_service.dart';

@module
abstract class ServiceInjectableModule {
  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();
  @lazySingleton
  FirebaseMessaging get fcm => FirebaseMessaging.instance;
  @lazySingleton
  FlutterLocalNotificationsPlugin get flutterLocalNotification =>
      FlutterLocalNotificationsPlugin();
  @lazySingleton
  ServiceClient get client => ServiceClient(credentials.header);
  @lazySingleton
  InternetConnectionChecker get connectionChecker =>
      InternetConnectionChecker();
  @lazySingleton
  DeviceInfoPlugin get deviceinfo => DeviceInfoPlugin();
  @lazySingleton
  Formater get formater => Formater();
  @lazySingleton
  Credentials get credentials => Credentials();
  @lazySingleton
  Box<User> get userBox => Hive.box<User>('user');
  @lazySingleton
  Box<Profile> get profileBox => Hive.box<Profile>('profile');
  @lazySingleton
  Box<News> get newsBox => Hive.box<News>('news');
  @lazySingleton
  Box<Company> get companyBox => Hive.box<Company>('company');
  @lazySingleton
  Box<Settings> get settingsBox => Hive.box<Settings>('settings');
  @lazySingleton
  RemoteConfigService get remoteConfig => RemoteConfigService();
}
