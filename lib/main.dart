import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

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
import 'services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureInjection(Environment.dev);

  await Firebase.initializeApp();

  try {
    await Hive.initFlutter();
    Hive.registerAdapter<User>(UserAdapter());
    Hive.registerAdapter<Profile>(ProfileAdapter());
    Hive.registerAdapter<News>(NewsAdapter());
    Hive.registerAdapter<Company>(CompanyAdapter());

    await Hive.openBox<User>('user');
    await Hive.openBox<Profile>('profile');
    await Hive.openBox<News>('news');
    await Hive.openBox<Company>('company');
  } catch (e) {
    rethrow;
  }

 await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
 await FirebaseCrashlytics.instance.deleteUnsentReports();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
/* 
  getIt<FirebaseCloudMessageService>().fcmConfigure();
  getIt<LocalNotificationsService>().getFlutterLocalNotificationPlugin(); */

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runZonedGuarded(() {
      runApp(MyApp());
    }, (obj, stack) {
      FirebaseCrashlytics.instance.recordError(obj, stack);
    });

    /*  getIt<FirebaseCloudMessageService>().getfcmToken(); */
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
    initializeHiveDB();
    getIt<RemoteConfigService>().getServiceNameFromRemoteConfig();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void initializeHiveDB() async {}

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
          '/login': (context) => LoginScreen2(),
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
          if (state is AuthInitial) {}
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
    final _InitAppState state =
        context.findAncestorStateOfType<_InitAppState>();
    state.setLocale(newLocale);
  }

  @override
  _InitAppState createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> with WidgetsBindingObserver {
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
          '/login': (context) => LoginScreen2(),
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
        },
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                textStyle: TextStyle(color: Colors.green),
                side: BorderSide(color: Colors.green),
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
