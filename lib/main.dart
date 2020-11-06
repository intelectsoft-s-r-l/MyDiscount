import 'dart:ui';

import 'package:MyDiscount/pages/bottom_navigation_bar_widget.dart';
import 'package:MyDiscount/pages/qr-page.dart';
import 'package:MyDiscount/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import './Screens/first_screen.dart';
import './services/fcm_service.dart';
import 'pages/login_screen2.dart';
import 'widgets/widgets/localizations.dart';

FCMService fcmService = FCMService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  //FirebaseCrashlytics.instance.sendUnsentReports();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  fcmService.fcmConfigure();
  fcmService.getFlutterLocalNotificationPlugin();
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
     /*  statusBarColor: Colors.white, */ statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    /*  runZoned(() { */
//getAuthState();
    runApp(MyApp());

    // ignore: unused_element

    /*   }, onError: FirebaseCrashlytics.instance.recordError); */

    //fcmService.getfcmToken();
  });
}

getAuthState() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('credentials')) authController.sink.add(true);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //authController.add(true);
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
          } catch (e, s) {
            FirebaseCrashlytics.instance.recordError(e, s);
          }

          return retLocale;
        },
        routes: {
          '/loginscreen': (context) => LoginScreen2(),
          '/app': (context) => BottomNavigationBarWidget(),
          '/qrpage': (context) => QrPage(),
        },
        home: StreamBuilder(
            initialData: false,
            stream: authController.stream,
            builder: (context, snapshot) =>
                snapshot.data ? QrPage() : LoginScreen2()) //FirstScreen(),

        );
  }
}
