import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_discount/aplication/auth/auth_bloc.dart';
import 'package:my_discount/aplication/auth/sign_in/sign_form_bloc.dart';
import 'package:my_discount/aplication/profile_bloc/profile_form_bloc.dart';
import 'package:my_discount/aplication/settings/settings_bloc.dart';
import 'package:my_discount/infrastructure/core/localization/localizations.dart';
import 'package:my_discount/presentation/pages/about_app_page.dart';
import 'package:my_discount/presentation/pages/add_card_company_list.dart';
import 'package:my_discount/presentation/pages/add_card_page.dart';
import 'package:my_discount/presentation/pages/app_inf_page.dart';
import 'package:my_discount/presentation/pages/card_list_page.dart';
import 'package:my_discount/presentation/pages/company_list_page.dart';
import 'package:my_discount/presentation/pages/detail_news_page.dart';
import 'package:my_discount/presentation/pages/info_page.dart';
import 'package:my_discount/presentation/pages/login_page.dart';
import 'package:my_discount/presentation/pages/profile_page.dart';
import 'package:my_discount/presentation/pages/settings_page.dart';
import 'package:my_discount/presentation/pages/technic_details_page.dart';
import 'package:my_discount/presentation/pages/transactions_page.dart';
import 'package:my_discount/presentation/widgets/bottom_navigator/bottom_navigation_bar_widget.dart';
import 'package:my_discount/presentation/widgets/circular_progress_indicator_widget.dart';


import '../../injectable.dart';

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
   

    super.initState();
    /*  WidgetsBinding.instance!.addObserver(this); */
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
    // WidgetsBinding.instance!.removeObserver(this);
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
        BlocProvider(
          create: (context) => getIt<ProfileFormBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<SettingsBloc>(),
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
  @override
  _InitAppState createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarWidget();
  }
}
