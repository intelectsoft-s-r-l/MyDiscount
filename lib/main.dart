import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localization/localizations.dart';
import 'widgets/bottom_navigation_bar_widget.dart';
import 'models/news_model.dart';
import 'models/user_model.dart';
import 'pages/detail_news_page.dart';
import 'pages/about_app.dart';
import 'pages/app_inf_page.dart';
import 'pages/info_page.dart';
import 'pages/profile_page.dart';
import 'pages/technic_details_page.dart';
import 'pages/transactions_page.dart';
import 'pages/user_page.dart';
import 'pages/login_screen2.dart';
import 'pages/settings_page.dart';

import 'services/local_notification_service.dart';
import 'services/auth_service.dart';
import 'services/fcm_service.dart';
import 'services/remote_config_service.dart';

FirebaseCloudMessageService fcmService = FirebaseCloudMessageService();
LocalNotificationsService localNotificationsService =
    LocalNotificationsService();
User user = User();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  try {
    await Hive.initFlutter();

    Hive.registerAdapter<News>(NewsAdapter());
    
    await Hive.openBox<News>('news');
  } catch (e) {}
  getServiceNameFromRemoteConfig();

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
 
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  fcmService.fcmConfigure();
  localNotificationsService.getFlutterLocalNotificationPlugin();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runZoned(
      () {
        runApp(MyApp());
      },
      onError: FirebaseCrashlytics.instance.recordError,
    );

    fcmService.getfcmToken();
  });
}

getAuthState() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('user')&&prefs.containsKey('profile')) authController.sink.add(true);
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppLocalizations(_locale).getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
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
        
        if (locale == null) {
          debugPrint("*language locale is null!!!");
          return supportedLocales.first;
        }
        try {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                locale.languageCode != null) {
             

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
        '/detailpage': (context) => DetailNewsPage(),
        '/profilepage': (context) => ProfilePage(),
        '/companypage': (context) => CompanyListPage(),
        '/transactionlist': (context) => TransactionsPage(),
        '/infopage': (context) => InformationPage(),
        '/politicaconf': (context) => AppInfoPage(),
        '/technicdetail': (context) => TechnicDetailPage(),
        '/about': (context) => AboutAppPage(),
        '/settings': (context) => SettingsPage(),
      },
      home: StreamBuilder(
        initialData: false,
        stream: authController.stream,
        builder: (context, snapshot) =>
            snapshot.data ? BottomNavigationBarWidget() : LoginScreen2(),
      ),
    );
  }
}
