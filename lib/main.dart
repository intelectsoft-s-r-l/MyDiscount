import 'dart:async';
import 'dart:ui';

import 'package:MyDiscount/Screens/first_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import './services/remote_config_service.dart';
import './services/fcm_service.dart';

import './widgets/localizations.dart';

FCMService fcmService = FCMService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Crashlytics.instance.enableInDevMode = true;
  getServiceName();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  fcmService.fcmConfigure();
  fcmService.getFlutterLocalNotificationPlugin();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runZoned(() {
      runApp(MyApp());
    }, onError: Crashlytics.instance.recordError);

    fcmService.getfcmToken();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('md', 'MD'),
        Locale('ro', 'RO'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        final retLocale = supportedLocales?.first;
        print('$locale 2');
        if (locale == null) {
          debugPrint("*language locale is null!!!");
          return supportedLocales.first;
        }
        try {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                locale.languageCode != null) {
              print(supportedLocale);
              return supportedLocale;
            }
          }
        } catch (e) {
          throw Exception();
        }

        return retLocale;
      },
      home: FirstScreen(),
    );
  }
}
