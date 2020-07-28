import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'Screens/companies_screen.dart';
import 'Screens/info_screen.dart';
import 'Screens/login_screen.dart';
import 'services/internet_connection_service.dart';
import './Screens/qr_screen.dart';
import './widgets/localizations.dart';
import './services/auth_service.dart';
import './services/qr_service.dart';
import './services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final RemoteConfig remoteConfig = RemoteConfig();
    remoteConfig.fetch();
    remoteConfig.activateFetched();
  } on FetchThrottledException catch (e) {
    throw Exception(e);
  } catch (e) {
    throw Exception(e);
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => InternetConnection(),
        ),
        ChangeNotifierProvider(
          create: (context) => QrService(),
        ),
        ChangeNotifierProvider(
          create: (context) => RemoteConfigService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
          Locale('ro', 'MD'),
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
          var retLocale = supportedLocales.first;
          print('$locale 2');

          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.countryCode == /*  locale.languageCode|| */ locale
                .countryCode) {
              print(supportedLocale);
              return supportedLocale;
            }
          }

          return retLocale;
        },
        home: FirstScreen(),
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  static QrService _qrService = QrService();
  // bool isLogin;
  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AuthService>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'MyDiscount',
            style: TextStyle(color: Colors.green),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                color: Colors.green,
                icon: const Icon(MdiIcons.locationExit),
                onPressed: () {
                  data.signOut();
                  setState(() {
                    // isLogin = false;
                  });
                },
              ),
            ),
          ],
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: MediaQuery.of(context).size * 0.11,
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(240, 242, 241, 1)),
              child: Container(
                alignment: Alignment.center,
                //height: 110,
                padding: EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: const Radius.circular(50),
                    bottomRight: const Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TabBar(
                      //dragStartBehavior: DragStartBehavior.start,
                      isScrollable: true,
                      //indicatorWeight: 0,
                      labelPadding: const EdgeInsets.all(3),
                      unselectedLabelColor: Colors.green,
                      labelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        border: Border.fromBorderSide(BorderSide(
                            width: 5.1,
                            style: BorderStyle.solid,
                            color: Colors.white)),
                      ),
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(
                          icon: ImageIcon(
                            AssetImage('assets/icons/qrlogo.png'),
                            size: 120,
                          ),
                        ),
                        const Tab(
                          icon: ImageIcon(
                            AssetImage('assets/icons/qr.png'),
                            size: 90,
                          ),
                        ),
                        Tab(
                          icon: ImageIcon(
                            AssetImage('assets/icons/news1.png'),
                            size: 120,
                          ),
                        ),
                      ],
                    ),
<<<<<<< HEAD
                    const Tab(
                      child: Text('QR'),
                      icon: Icon(
                        MyFlutterApp.images,
                        size: 20,
                      ),
                      //const FaIcon(FontAwesomeIcons.qrcode),
                    ),
                    Tab(
                      icon: const FaIcon(FontAwesomeIcons.newspaper),
                      child: Column(
=======
                    Container(
                      width: 300,
                      child: Row(
>>>>>>> 83f0b35e95271b1bd062a6c1c5a16b9faf53445b
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('companies'),
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          SizedBox(
                            width: 65,
                          ),
                          SizedBox(),
                          Container(
                            child: Text(
                              'QR',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          SizedBox(
                            width: 65,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: Text(
                              AppLocalizations.of(context).translate('text10'),
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: ClampingScrollPhysics(),
          controller: _tabController,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(240, 242, 241, 1),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Companies(),
            ),
            Container(
              child: FutureBuilder(
                future: _qrService.tryAutoLogin(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data == true ? QrScreen() : LoginPage();
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            InfoScreen(),
          ],
        ),
      ),
    );
  }
}
