// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'services/company_service.dart';
import 'core/constants/credentials.dart';
import 'services/fcm_service.dart';
import 'core/formater.dart';
import 'services/local_notification_service.dart';
import 'services/internet_connection_service.dart';
import 'services/news_service.dart';
import 'services/phone_verification.dart';
import 'services/qr_service.dart';
import 'services/core/services_injectable.dart';
import 'services/shared_preferences_service.dart';
import 'services/transactions_service.dart';
import 'services/user_credentials.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final serviceInjectableModule = _$ServiceInjectableModule();
  gh.lazySingleton<Credentials>(() => serviceInjectableModule.credentials);
  gh.lazySingleton<DataConnectionChecker>(
      () => serviceInjectableModule.connectionChecker);
  gh.lazySingleton<DeviceInfoPlugin>(() => serviceInjectableModule.deviceinfo);
  gh.lazySingleton<FacebookLogin>(() => serviceInjectableModule.facebookLogin);
  gh.lazySingleton<FirebaseMessaging>(() => serviceInjectableModule.fcm);
  gh.lazySingleton<FlutterLocalNotificationsPlugin>(
      () => serviceInjectableModule.flutterLocalNotification);
  gh.lazySingleton<Formater>(() => serviceInjectableModule.formater);
  gh.lazySingleton<GoogleSignIn>(() => serviceInjectableModule.googleSignIn);
  gh.factory<LocalNotificationsService>(
      () => LocalNotificationsService(get<FlutterLocalNotificationsPlugin>()));
  gh.factory<NetworkConnectionImpl>(() =>
      NetworkConnectionImpl(connectionChecker: get<DataConnectionChecker>()));
  gh.lazySingleton<SharedPref>(() => serviceInjectableModule.prefs);
  gh.factory<TransactionService>(() => TransactionService(
        get<Credentials>(),
        get<Formater>(),
        get<NetworkConnectionImpl>(),
      ));
  gh.factory<UserCredentials>(() => UserCredentials());
  gh.factory<CompanyService>(() => CompanyService(
        get<SharedPref>(),
        get<Credentials>(),
        get<Formater>(),
        get<NetworkConnectionImpl>(),
      ));
  gh.factory<FirebaseCloudMessageService>(() => FirebaseCloudMessageService(
        get<FirebaseMessaging>(),
        get<LocalNotificationsService>(),
        get<SharedPref>(),
      ));
  gh.factory<NewsService>(() => NewsService(
        get<SharedPref>(),
        get<Formater>(),
        get<Credentials>(),
        get<NetworkConnectionImpl>(),
      ));
  gh.factory<QrService>(() => QrService(
        get<SharedPref>(),
        get<Credentials>(),
        get<Formater>(),
        get<NetworkConnectionImpl>(),
      ));
  gh.factory<AuthService>(() => AuthService(
        get<GoogleSignIn>(),
        get<FacebookLogin>(),
        get<FirebaseCloudMessageService>(),
      ));
  gh.factory<AuthorizationProvider>(() => AuthorizationProvider(
        get<NetworkConnectionImpl>(),
        get<AuthService>(),
        get<SharedPref>(),
      ));
  gh.factory<PhoneVerification>(
      () => PhoneVerification(get<SharedPref>(), get<QrService>()));
  return get;
}

class _$ServiceInjectableModule extends ServiceInjectableModule {}
