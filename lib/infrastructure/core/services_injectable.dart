import 'package:MyDiscount/services/remote_config_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:IsService/service_client.dart';

import '../../core/constants/credentials.dart';
import '../../core/formater.dart';
import '../../domain/entities/company_model.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/entities/profile_model.dart';
import '../../domain/entities/user_model.dart';
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
  FlutterLocalNotificationsPlugin get flutterLocalNotification => FlutterLocalNotificationsPlugin();
  @lazySingleton
  ServiceClient get client => ServiceClient(credentials.header);
  @lazySingleton
  DataConnectionChecker get connectionChecker => DataConnectionChecker();
  @lazySingleton
  DeviceInfoPlugin get deviceinfo => DeviceInfoPlugin();
  @lazySingleton
  Formater get formater => Formater();
  @lazySingleton
  Credentials get credentials => Credentials();
  @lazySingleton
  SharedPref get network => SharedPref();
  @lazySingleton
  Box<User> get userBox  => Hive.box<User>('user');
  @lazySingleton
  Box<Profile> get profileBox  => Hive.box<Profile>('profile');
  @lazySingleton
  Box<News> get newsBox  => Hive.box<News>('news');
  @lazySingleton
  Box<Company> get companyBox  => Hive.box<Company>('company');
  @lazySingleton
  RemoteConfigService get remoteConfig => RemoteConfigService();
}
