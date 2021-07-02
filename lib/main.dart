import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'domain/entities/company_model.dart';
import 'domain/entities/news_model.dart';
import 'domain/entities/profile_model.dart';
import 'domain/entities/user_model.dart';
import 'domain/settings/settings.dart';
import 'infrastructure/core/fcm_service.dart';
import 'infrastructure/core/local_notification_service.dart';
import 'injectable.dart';
import 'presentation/app/my_app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await FlutterLocalNotificationsPlugin().show(
      int.parse(message.data['id']),
      message.data['title'],
      message.data['body'],
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@mipmap/ic_notifications_icon',
        enableLights: true,
        ledColor: Color(0xFF0000FF),
        ledOffMs: 2000,
        ledOnMs: 2000,
        color: Color(0xFF00C569),
        enableVibration: true,
        // vibrationPattern: vibrationPattern,
      )));
  debugPrint('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureInjection(Environment.prod);

  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive
    ..registerAdapter<User>(UserAdapter())
    ..registerAdapter<Settings>(SettingsAdapter())
    ..registerAdapter<Profile>(ProfileAdapter())
    ..registerAdapter<News>(NewsAdapter())
    ..registerAdapter<Company>(CompanyAdapter());
  final storage = const FlutterSecureStorage();
  const key = 'hiveKey';
  final List<int> hiveKey;
  if (await storage.containsKey(key: key)) {
    hiveKey = base64Decode(await storage.read(key: key) as String).toList();
  } else {
    final value = Hive.generateSecureKey();
    await storage.write(key: key, value: base64Encode(value));
    hiveKey = base64Decode(await storage.read(key: key) as String).toList();
  }
  await initDB(hiveKey);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  await FirebaseCrashlytics.instance.deleteUnsentReports();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  getIt<FirebaseCloudMessageService>().fcmConfigure();
  getIt<LocalNotificationsService>().getFlutterLocalNotificationPlugin();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await getIt<FirebaseCloudMessageService>().getfcmToken();

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

Future<void> initDB(List<int> hiveKey) async {
  try {
    await Hive.openBox<User>('user', encryptionCipher: HiveAesCipher(hiveKey));
    await Hive.openBox<Settings>('settings');
    await Hive.openBox<Profile>('profile',
        encryptionCipher: HiveAesCipher(hiveKey));
    await Hive.openBox<News>('news');
    await Hive.openBox<Company>('company');
    await Hive.openBox<String>('locale');
  } catch (e, s) {
    print(e);
    await FirebaseCrashlytics.instance.log(s.toString());
    await Hive.deleteBoxFromDisk('user');
    await Hive.deleteBoxFromDisk('profile');
    await initDB(hiveKey);
  }
}
