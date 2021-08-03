import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_discount/aplication/bottom_navigation_bar_bloc/bottom_navigator_bar_bloc.dart';

import '../../aplication/auth/auth_bloc.dart';
import '../../aplication/auth/sign_in/sign_form_bloc.dart';
import '../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../aplication/settings/settings_bloc.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../../injectable.dart';
import '../../presentation/pages/about_app_page.dart';
import '../../presentation/pages/add_card_company_list.dart';
import '../../presentation/pages/add_card_page.dart';
import '../../presentation/pages/app_info_page.dart';
import '../../presentation/pages/card_list_page.dart';
import '../../presentation/pages/company_list_page.dart';
import '../../presentation/pages/detail_news_page.dart';
import '../../presentation/pages/info_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/technic_details_page.dart';
import '../../presentation/pages/transactions_page.dart';
import '../../presentation/widgets/bottom_navigator/bottom_navigation_bar_widget.dart';
import '../../presentation/widgets/circular_progress_indicator_widget.dart';

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    context.findAncestorStateOfType<_MyAppState>()!.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  {
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
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
          create: (context) =>
              getIt<ProfileFormBloc>()..add(UpdateProfileData()),
        ),
        BlocProvider(
          create: (context) => getIt<SettingsBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<BottomNavigatorBarBloc>(),
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
          '/login': (context) => const LoginPage(),
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

class InitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarWidget();
  }
}
