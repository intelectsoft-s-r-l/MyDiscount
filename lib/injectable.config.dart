// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:data_connection_checker/data_connection_checker.dart' as _i9;
import 'package:device_info/device_info.dart' as _i10;
import 'package:firebase_messaging/firebase_messaging.dart' as _i13;
import 'package:flutter_facebook_login/flutter_facebook_login.dart' as _i12;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as _i14;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i16;
import 'package:hive/hive.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:IsService/service_client.dart' as _i22;

import 'aplication/auth/auth_bloc.dart' as _i24;
import 'aplication/auth/sign_in/sign_form_bloc.dart' as _i32;
import 'aplication/phone_validation_bloc/phone_validation_bloc.dart' as _i28;
import 'aplication/profile_bloc/profile_form_bloc.dart' as _i29;
import 'core/constants/credentials.dart' as _i8;
import 'core/formater.dart' as _i15;
import 'core/internet_connection_service.dart' as _i20;
import 'domain/entities/company_model.dart' as _i7;
import 'domain/entities/news_model.dart' as _i6;
import 'domain/entities/profile_model.dart' as _i5;
import 'domain/entities/user_model.dart' as _i4;
import 'domain/repositories/auth_repository.dart' as _i30;
import 'domain/repositories/is_service_repository.dart' as _i26;
import 'domain/repositories/local_repository.dart' as _i18;
import 'infrastructure/auth_repository_impl.dart' as _i31;
import 'infrastructure/core/services_injectable.dart' as _i33;
import 'infrastructure/is_service_impl.dart' as _i27;
import 'infrastructure/local_repository_impl.dart' as _i19;
import 'services/device_info_service.dart' as _i11;
import 'services/fcm_service.dart' as _i25;
import 'services/local_notification_service.dart' as _i17;
import 'services/remote_config_service.dart' as _i21;
import 'services/shared_preferences_service.dart' as _i23; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get, {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final serviceInjectableModule = _$ServiceInjectableModule();
  gh.factory<_i3.Box<_i4.User>>(() => serviceInjectableModule.userBox);
  gh.factory<_i3.Box<_i5.Profile>>(() => serviceInjectableModule.profileBox);
  gh.factory<_i3.Box<_i6.News>>(() => serviceInjectableModule.newsBox);
  gh.factory<_i3.Box<_i7.Company>>(() => serviceInjectableModule.companyBox);
  gh.factory<_i8.Credentials>(() => serviceInjectableModule.credentials);
  gh.factory<_i9.DataConnectionChecker>(() => serviceInjectableModule.connectionChecker);
  gh.factory<_i10.DeviceInfoPlugin>(() => serviceInjectableModule.deviceinfo);
  gh.factory<_i11.DeviceInfoService>(() => _i11.DeviceInfoService(get<_i10.DeviceInfoPlugin>()));
  gh.factory<_i12.FacebookLogin>(() => serviceInjectableModule.facebookLogin);
  gh.factory<_i13.FirebaseMessaging>(() => serviceInjectableModule.fcm);
  gh.factory<_i14.FlutterLocalNotificationsPlugin>(() => serviceInjectableModule.flutterLocalNotification);
  gh.factory<_i15.Formater>(() => serviceInjectableModule.formater);
  gh.factory<_i16.GoogleSignIn>(() => serviceInjectableModule.googleSignIn);
  gh.factory<_i17.LocalNotificationsService>(() => _i17.LocalNotificationsService(get<_i14.FlutterLocalNotificationsPlugin>()));
  gh.lazySingleton<_i18.LocalRepository>(
      () => _i19.LocalRepositoryImpl(get<_i3.Box<_i4.User>>(), get<_i3.Box<_i5.Profile>>(), get<_i3.Box<_i6.News>>(), get<_i3.Box<_i7.Company>>()));
  gh.lazySingleton<_i20.NetworkConnection>(() => _i20.NetworkConnectionImpl(connectionChecker: get<_i9.DataConnectionChecker>()));
  gh.factory<_i21.RemoteConfigService>(() => serviceInjectableModule.remoteConfig);
  gh.factory<_i22.ServiceClient>(() => serviceInjectableModule.client);
  gh.factory<_i23.SharedPref>(() => serviceInjectableModule.network);
  gh.factory<_i24.AuthBloc>(() => _i24.AuthBloc(get<_i18.LocalRepository>()));
  gh.factory<_i25.FirebaseCloudMessageService>(
      () => _i25.FirebaseCloudMessageService(get<_i13.FirebaseMessaging>(), get<_i17.LocalNotificationsService>(), get<_i23.SharedPref>()));
  gh.lazySingleton<_i26.IsService>(
      () => _i27.IsServiceImpl(get<_i22.ServiceClient>(), get<_i20.NetworkConnection>(), get<_i18.LocalRepository>(), get<_i15.Formater>(), get<_i21.RemoteConfigService>()));
  gh.factory<_i28.PhoneValidationBloc>(() => _i28.PhoneValidationBloc(get<_i26.IsService>(), get<_i18.LocalRepository>()));
  gh.factory<_i29.ProfileFormBloc>(() => _i29.ProfileFormBloc(get<_i18.LocalRepository>(), get<_i26.IsService>()));
  gh.lazySingleton<_i30.AuthRepository>(() => _i31.AuthRepositoryImpl(get<_i16.GoogleSignIn>(), get<_i12.FacebookLogin>(), get<_i26.IsService>(), get<_i18.LocalRepository>()));
  gh.factory<_i32.SignFormBloc>(() => _i32.SignFormBloc(get<_i30.AuthRepository>(), get<_i20.NetworkConnection>()));
  return get;
}

class _$ServiceInjectableModule extends _i33.ServiceInjectableModule {}
