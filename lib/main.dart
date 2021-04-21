import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:my_discount/presentation/pages/add_card_page.dart';
import 'package:my_discount/services/local_notification_service.dart';

import 'aplication/auth/auth_bloc.dart';
import 'aplication/auth/sign_in/sign_form_bloc.dart';
import 'aplication/profile_bloc/profile_form_bloc.dart';
import 'core/localization/localizations.dart';
import 'domain/entities/company_model.dart';
import 'domain/entities/news_model.dart';
import 'domain/entities/profile_model.dart';
import 'domain/entities/user_model.dart';
import 'injectable.dart';
import 'presentation/pages/about_app_page.dart';
import 'presentation/pages/add_card_company_list.dart';
import 'presentation/pages/app_inf_page.dart';
import 'presentation/pages/card_list_page.dart';
import 'presentation/pages/company_list_page.dart';
import 'presentation/pages/detail_news_page.dart';
import 'presentation/pages/info_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/settings_page.dart';
import 'presentation/pages/technic_details_page.dart';
import 'presentation/pages/transactions_page.dart';
import 'presentation/widgets/bottom_navigator/bottom_navigation_bar_widget.dart';
import 'presentation/widgets/circular_progress_indicator_widget.dart';
import 'services/fcm_service.dart';
import 'services/remote_config_service.dart';
import 'services/shared_preferences_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  /* await FlutterLocalNotificationsPlugin().show(int.parse(message.data['id']),
      message.data['title'], message.data['body'],const NotificationDetails() ); */
  debugPrint('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureInjection(Environment.prod);

  await Firebase.initializeApp();

  try {
    await Hive.initFlutter();
    Hive
      ..registerAdapter<User>(UserAdapter())
      ..registerAdapter<Profile>(ProfileAdapter())
      ..registerAdapter<News>(NewsAdapter())
      ..registerAdapter<Company>(CompanyAdapter());

    await Hive.openBox<User>('user');
    await Hive.openBox<Profile>('profile');
    await Hive.openBox<News>('news');
    await Hive.openBox<Company>('company');
  } catch (e) {
    rethrow;
  }

  SharedPref().remove();

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  await FirebaseCrashlytics.instance.deleteUnsentReports();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  getIt<FirebaseCloudMessageService>().fcmConfigure();
  getIt<LocalNotificationsService>().getFlutterLocalNotificationPlugin();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runZonedGuarded(() {
      runApp(MyApp());
    }, (obj, stack) {
      FirebaseCrashlytics.instance.recordError(obj, stack);
    });

    getIt<FirebaseCloudMessageService>().getfcmToken();
  });
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    context.findAncestorStateOfType<_MyAppState>()!.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    getIt<RemoteConfigService>().getServiceNameFromRemoteConfig();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppLocalizations(_locale).getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<SignFormBloc>(
          create: (context) => getIt<SignFormBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
          Locale('ro', 'RO'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => const LoginScreen2(),
          '/first': (context) => InitApp(),
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthorized) {
            Navigator.pushReplacementNamed(context, '/first');
          } else {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: CircularProgresIndicatorWidget(),
      ),
    );
  }
}

class InitApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    context.findAncestorStateOfType<_InitAppState>()!.setLocale(newLocale);
  }

  @override
  _InitAppState createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> with WidgetsBindingObserver {
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppLocalizations(_locale).getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ProfileFormBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
          Locale('ro', 'RO'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routes: {
          '/first': (context) => InitApp(),
          '/login': (context) => const LoginScreen2(),
          '/detailpage': (context) => const DetailNewsPage(),
          '/profilepage': (context) => const ProfilePage(),
          '/companypage': (context) => const CompanyListPage(),
          '/transactionlist': (context) => const TransactionsPage(),
          '/infopage': (context) => const InformationPage(),
          '/politicaconf': (context) => const AppInfoPage(),
          '/technicdetail': (context) => const TechnicDetailPage(),
          '/about': (context) => const AboutAppPage(),
          '/settings': (context) => const SettingsPage(),
          '/cardlist': (context) => const CardListPage(),
          '/addcard': (context) => const AddCardPage(),
          '/addcardcompanylist': (context) => const AddCardCompanyListPage(),
        },
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(color: Colors.green),
                side: const BorderSide(color: Colors.green),
                primary: Colors.white,
                onPrimary: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
        home: BottomNavigationBarWidget(),
      ),
    );
  }
}
/*  encryptionCipher: HiveAesCipher([
          19,
          93,
          01,
          03,
          255,
          08,
          29,
          155,
          32,
          45,
          86,
          120,
          76,
          240,
          58,
          200,
          35,
          42,
          244,
          195,
          71,
          08,
          29,
          155,
          32,
          45,
          86,
          120,
          76,
          240,
          58,
          200
        ]) */
