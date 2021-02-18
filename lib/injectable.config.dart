// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:hive/hive.dart' as hive1;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:IsService/service_client.dart';

import 'aplication/auth/auth_bloc.dart';
import 'infrastructure/auth_repository_impl.dart';
import 'domain/entities/company_model.dart';
import 'core/constants/credentials.dart';
import 'services/fcm_service.dart';
import 'core/formater.dart';
import 'infrastructure/is_service_impl.dart';
import 'services/local_notification_service.dart';
import 'infrastructure/local_repository_impl.dart';
import 'services/internet_connection_service.dart';
import 'domain/entities/news_model.dart';
import 'domain/entities/profile_model.dart';
import 'infrastructure/core/services_injectable.dart';
import 'services/shared_preferences_service.dart';
import 'aplication/auth/sign_in/sign_form_bloc.dart';
import 'domain/entities/user_model.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final serviceInjectableModule = _$ServiceInjectableModule();
  gh.lazySingleton<hive1.Box<User>>(() => serviceInjectableModule.userBox);
  gh.lazySingleton<hive1.Box<Profile>>(
      () => serviceInjectableModule.profileBox);
  gh.lazySingleton<hive1.Box<News>>(() => serviceInjectableModule.newsBox);
  gh.lazySingleton<hive1.Box<Company>>(
      () => serviceInjectableModule.companyBox);
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
  gh.lazySingleton<ServiceClient>(() => serviceInjectableModule.client);
  gh.lazySingleton<SharedPref>(() => serviceInjectableModule.network);
  gh.factory<FirebaseCloudMessageService>(() => FirebaseCloudMessageService(
        get<FirebaseMessaging>(),
        get<LocalNotificationsService>(),
        get<SharedPref>(),
      ));
  gh.factory<LocalRepositoryImpl>(() => LocalRepositoryImpl(
        get<hive1.Box<User>>(),
        get<hive1.Box<Profile>>(),
        get<hive1.Box<News>>(),
        get<hive1.Box<Company>>(),
        get<SharedPref>(),
      ));
  gh.factory<AuthBloc>(() => AuthBloc(get<LocalRepositoryImpl>()));
  gh.factory<IsServiceImpl>(() => IsServiceImpl(
        get<ServiceClient>(),
        get<NetworkConnectionImpl>(),
        get<LocalRepositoryImpl>(),
        get<Formater>(),
      ));
  gh.factory<AuthRepositoryImpl>(() => AuthRepositoryImpl(
        get<GoogleSignIn>(),
        get<FacebookLogin>(),
        get<IsServiceImpl>(),
        get<LocalRepositoryImpl>(),
      ));
  gh.factory<SignFormBloc>(() => SignFormBloc(get<AuthRepositoryImpl>()));
  return get;
}

class _$ServiceInjectableModule extends ServiceInjectableModule {}
