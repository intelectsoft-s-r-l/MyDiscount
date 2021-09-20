import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'domain/entities/company_model.dart';
import 'domain/entities/news_model.dart';
import 'domain/entities/profile_model.dart';
import 'domain/entities/user_model.dart';
import 'domain/settings/settings.dart';
import 'infrastructure/core/fcm_service.dart';
import 'infrastructure/core/local_notification_service.dart';
import 'initialization.dart' as initialization;
import 'injectable.dart';
import 'presentation/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureInjection(Environment.prod);

  await Firebase.initializeApp();
  try {
    await Hive.initFlutter();
    Hive
      ..registerAdapter<User>(UserAdapter())
      ..registerAdapter<Settings>(SettingsAdapter())
      ..registerAdapter<Profile>(ProfileAdapter())
      ..registerAdapter<News>(NewsAdapter())
      ..registerAdapter<Company>(CompanyAdapter());
    final storage =await SharedPreferences.getInstance();
    const key = 'hiveKey';
    final List<int> hiveKey;
    if (storage.containsKey(key)) {
      hiveKey = base64Decode(storage.getString(key) as String).toList();
    } else {
      final value = Hive.generateSecureKey();
      await storage.setString(key, base64Encode(value));
      hiveKey = base64Decode(storage.getString(key) as String).toList();
    }
    await initialization.initDB(storage, hiveKey);
  } catch (exception, stack) {
    await FirebaseCrashlytics.instance.recordError(exception, stack);
  }
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    await FirebaseCrashlytics.instance.deleteUnsentReports();
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  getIt<FirebaseCloudMessageService>().fcmConfigure();
  getIt<LocalNotificationsService>().getFlutterLocalNotificationPlugin();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runZonedGuarded(() {
      runApp(MyApp());
    }, (obj, stack) {
      FirebaseCrashlytics.instance.recordError(obj, stack);
    });
  });
}
