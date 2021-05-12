// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:device_info/device_info.dart' as _i9;
import 'package:firebase_messaging/firebase_messaging.dart' as _i11;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i14;
import 'package:hive/hive.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i15;
import 'package:is_service/service_client.dart' as _i22;

import 'aplication/auth/auth_bloc.dart' as _i24;
import 'aplication/auth/sign_in/sign_form_bloc.dart' as _i35;
import 'aplication/card_bloc/add_card_page_bloc.dart' as _i32;
import 'aplication/phone_validation_bloc/phone_validation_bloc.dart' as _i30;
import 'aplication/profile_bloc/profile_form_bloc.dart' as _i31;
import 'aplication/providers/news_settings.dart' as _i20;
import 'core/constants/credentials.dart' as _i8;
import 'core/formater.dart' as _i13;
import 'core/internet_connection_service.dart' as _i19;
import 'domain/data_source/remote_datasource.dart' as _i26;
import 'domain/entities/company_model.dart' as _i7;
import 'domain/entities/news_model.dart' as _i6;
import 'domain/entities/profile_model.dart' as _i5;
import 'domain/entities/user_model.dart' as _i4;
import 'domain/repositories/auth_repository.dart' as _i33;
import 'domain/repositories/is_service_repository.dart' as _i28;
import 'domain/repositories/local_repository.dart' as _i17;
import 'infrastructure/auth_repository_impl.dart' as _i34;
import 'infrastructure/core/device_info_service.dart' as _i10;
import 'infrastructure/core/fcm_service.dart' as _i25;
import 'infrastructure/core/local_notification_service.dart' as _i16;
import 'infrastructure/core/remote_config_service.dart' as _i21;
import 'infrastructure/core/services_injectable.dart' as _i36;
import 'infrastructure/core/shared_preferences_service.dart' as _i23;
import 'infrastructure/is_service_impl.dart' as _i29;
import 'infrastructure/local_repository_impl.dart' as _i18;
import 'infrastructure/remote_datasource_impl.dart/remote_datasource_impl.dart'
    as _i27; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final serviceInjectableModule = _$ServiceInjectableModule();
  gh.lazySingleton<_i3.Box<_i4.User>>(() => serviceInjectableModule.userBox);
  gh.lazySingleton<_i3.Box<_i5.Profile>>(
      () => serviceInjectableModule.profileBox);
  gh.lazySingleton<_i3.Box<_i6.News>>(() => serviceInjectableModule.newsBox);
  gh.lazySingleton<_i3.Box<_i7.Company>>(
      () => serviceInjectableModule.companyBox);
  gh.lazySingleton<_i8.Credentials>(() => serviceInjectableModule.credentials);
  gh.lazySingleton<_i9.DeviceInfoPlugin>(
      () => serviceInjectableModule.deviceinfo);
  gh.factory<_i10.DeviceInfoService>(
      () => _i10.DeviceInfoService(get<_i9.DeviceInfoPlugin>()));
  gh.lazySingleton<_i11.FirebaseMessaging>(() => serviceInjectableModule.fcm);
  gh.lazySingleton<_i12.FlutterLocalNotificationsPlugin>(
      () => serviceInjectableModule.flutterLocalNotification);
  gh.lazySingleton<_i13.Formater>(() => serviceInjectableModule.formater);
  gh.lazySingleton<_i14.GoogleSignIn>(
      () => serviceInjectableModule.googleSignIn);
  gh.lazySingleton<_i15.InternetConnectionChecker>(
      () => serviceInjectableModule.connectionChecker);
  gh.factory<_i16.LocalNotificationsService>(() =>
      _i16.LocalNotificationsService(
          get<_i12.FlutterLocalNotificationsPlugin>()));
  gh.lazySingleton<_i17.LocalRepository>(() => _i18.LocalRepositoryImpl(
      get<_i3.Box<_i4.User>>(),
      get<_i3.Box<_i5.Profile>>(),
      get<_i3.Box<_i6.News>>(),
      get<_i3.Box<_i7.Company>>()));
  gh.lazySingleton<_i19.NetworkConnection>(() => _i19.NetworkConnectionImpl(
      connectionChecker: get<_i15.InternetConnectionChecker>()));
  gh.lazySingleton<_i20.NewsSettings>(() => serviceInjectableModule.settings);
  gh.lazySingleton<_i21.RemoteConfigService>(
      () => serviceInjectableModule.remoteConfig);
  gh.lazySingleton<_i22.ServiceClient>(() => serviceInjectableModule.client);
  gh.lazySingleton<_i23.SharedPref>(() => serviceInjectableModule.network);
  gh.factory<_i24.AuthBloc>(() => _i24.AuthBloc(get<_i17.LocalRepository>()));
  gh.factory<_i25.FirebaseCloudMessageService>(() =>
      _i25.FirebaseCloudMessageService(get<_i11.FirebaseMessaging>(),
          get<_i16.LocalNotificationsService>(), get<_i23.SharedPref>()));
  gh.lazySingleton<_i26.RemoteDataSource>(() => _i27.RemoteDataSourceImpl(
      get<_i22.ServiceClient>(),
      get<_i21.RemoteConfigService>(),
      get<_i19.NetworkConnection>()));
  gh.lazySingleton<_i28.IsService>(() => _i29.IsServiceImpl(
      get<_i17.LocalRepository>(),
      get<_i13.Formater>(),
      get<_i26.RemoteDataSource>(),
      get<_i20.NewsSettings>()));
  gh.factory<_i30.PhoneValidationBloc>(() => _i30.PhoneValidationBloc(
      get<_i28.IsService>(), get<_i17.LocalRepository>()));
  gh.factory<_i31.ProfileFormBloc>(() =>
      _i31.ProfileFormBloc(get<_i17.LocalRepository>(), get<_i28.IsService>()));
  gh.factory<_i32.AddCardPageBloc>(() =>
      _i32.AddCardPageBloc(get<_i28.IsService>(), get<_i17.LocalRepository>()));
  gh.lazySingleton<_i33.AuthRepository>(() => _i34.AuthRepositoryImpl(
      get<_i14.GoogleSignIn>(),
      get<_i28.IsService>(),
      get<_i17.LocalRepository>()));
  gh.factory<_i35.SignFormBloc>(() => _i35.SignFormBloc(
      get<_i33.AuthRepository>(), get<_i19.NetworkConnection>()));
  return get;
}

class _$ServiceInjectableModule extends _i36.ServiceInjectableModule {}
