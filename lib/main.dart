import 'dart:async';
import 'dart:ui';

import 'package:MyDiscount/injectable.dart';
import 'package:MyDiscount/widgets/circular_progress_indicator_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';

import 'core/localization/localizations.dart';
import 'domain/entities/company_model.dart';
import 'domain/entities/news_model.dart';
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
import 'providers/auth_provider.dart';
import 'services/local_notification_service.dart';
import 'services/fcm_service.dart';
import 'services/remote_config_service.dart';
import 'widgets/bottom_navigation_bar_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureInjection(Environment.dev);

  await Firebase.initializeApp();

  try {
    await Hive.initFlutter();

    Hive.registerAdapter<News>(NewsAdapter());
    Hive.registerAdapter<Company>(CompanyAdapter());

    await Hive.openBox<News>('news');
    await Hive.openBox<Company>('company');
  } catch (e) {
    rethrow;
  }
  getServiceNameFromRemoteConfig();

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  FirebaseCrashlytics.instance.deleteUnsentReports();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  getIt<FirebaseCloudMessageService>().fcmConfigure();
  getIt<LocalNotificationsService>().getFlutterLocalNotificationPlugin();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
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

    getIt<FirebaseCloudMessageService>().getfcmToken();
  });
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<AuthorizationProvider>(),
      child: MaterialApp(
        locale: _locale,
        debugShowCheckedModeBanner: false,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
          Locale('md', 'MD'),
          Locale('ro', 'RO'),
        ],
        localizationsDelegates: const [
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
          '/detailpage': (context) => const DetailNewsPage(),
          '/profilepage': (context) => const ProfilePage(),
          '/companypage': (context) => const CompanyListPage(),
          '/transactionlist': (context) => const TransactionsPage(),
          '/infopage': (context) => const InformationPage(),
          '/politicaconf': (context) => const AppInfoPage(),
          '/technicdetail': (context) => const TechnicDetailPage(),
          '/about': (context) => const AboutAppPage(),
          '/settings': (context) => const SettingsPage(),
        },
        home: Consumer(
          builder: (context, AuthorizationProvider auth, _) => auth.isAuth
              ? BottomNavigationBarWidget()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen2(),
                ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularProgresIndicatorWidget(),
    );
  }
}
