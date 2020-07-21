import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'Screens/companies_screen.dart';
import 'Screens/info_screen.dart';
import 'services/internet_connection_service.dart';
import 'services/shared_preferences_service.dart';
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
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

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
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ro', 'RO'),
          Locale('ru', 'RU'),
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
            if (supportedLocale.languageCode == locale.languageCode) {
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
  InternetConnection internetConnection = InternetConnection();
  //Timer _timer;

  int countTID = 0;
  bool chengeImage = true;
  bool isLogin = false;
  bool serviceConection = true;
  int _counter = 3;
  Timer _timer;
  int index = 1;
  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    );

    getAuthorization();

    super.initState();
  }

  changeImages() {
    setState(() {
      chengeImage = false;
    });
  }

  void startTimer() {
    countTID++;
    print(countTID);
    _counter = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      if (_counter > 0) {
        _counter--;
        print(_counter);
      } else if (_counter == 0) {
        if (countTID < 3) {
          getAuthorization();
          _timer.cancel();
        } else {
          changeImages();
          _timer.cancel();
        }
      } else {
        _timer.cancel();
      }
    });
    print(_timer);
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  getAuthorization() async {
    DataConnectionStatus status = await internetConnection.internetConection();
    var data = await _qrService.tryAutoLogin();
    _counter = 10;
    switch (status) {
      case DataConnectionStatus.connected:
        try {
          var service = await _qrService.attemptSignIn();
          if (countTID == 3) {
            setState(() {
              chengeImage = false;
              serviceConection = true;
              if (_timer.isActive) {
                _timer.cancel();
              }
            });
          } else {
            startTimer();
          }
          if (data == true) {
            setState(() {
              isLogin = true;
            });
            if (service) {
              setState(() {
                serviceConection = true;
              });
            } else {
              changeImages();
              setState(() {
                serviceConection = false;
              });

              if (_timer.isActive) {
                _timer.cancel();
              }
            }
          } else {
            isLogin = false;
            countTID = 0;
          }
        } catch (e) {
          if (_timer.isActive) {
            _timer.cancel();
          }
          print(e);
        }
        break;
      case DataConnectionStatus.disconnected:
        setState(() {
          chengeImage = false;
          serviceConection = false;
          if (_timer.isActive) {
            _timer.cancel();
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AuthService>(context);
    final SharedPref sPref = SharedPref();
    Future<String> _loadSharedPref() async {
      final id = await sPref.readTID();
      return id;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'MyDiscount',
            style: TextStyle(color: Colors.green),
          ),
          actions: <Widget>[
            IconButton(
              color: Colors.green,
              icon: const Icon(MdiIcons.locationExit),
              onPressed: () {
                data.signOut();
                setState(() {
                  isLogin = false;
                });
              },
            ),
          ],
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: MediaQuery.of(context).size * 0.12,
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(240, 242, 241, 1)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(37),
                    bottomRight: Radius.circular(37),
                  ),
                ),
                child: TabBar(
                  unselectedLabelColor: Colors.green,
                  labelColor: Colors.white,
                  indicatorColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.values[0],
                  indicator: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      icon: FaIcon(FontAwesomeIcons.newspaper),
                      child: Text(
                        AppLocalizations.of(context).translate('text10'),
                      ),
                    ),
                    Tab(
                      child: Text('QR'),
                      icon: FaIcon(FontAwesomeIcons.qrcode),
                    ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(context).translate('companies'),
                      ),
                      icon: FaIcon(FontAwesomeIcons.home),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(240, 242, 241, 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InfoScreen(),
                ),
              ),
            ),
            Container(
              child: isLogin
                  ? Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(240, 242, 241, 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  chengeImage
                                      ? Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(10),
                                          child: FutureBuilder<String>(
                                            future: _loadSharedPref(),
                                            builder: (context, snapshot) {
                                              return RepaintBoundary(
                                                child: QrImage(
                                                    data: '${snapshot.data}',
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.3),
                                              );
                                            },
                                          ),
                                        )
                                      : Column(
                                          children: <Widget>[
                                            serviceConection
                                                ? Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.43,
                                                          child: Image.asset(
                                                              'assets/icons/om.png'),
                                                        ),
                                                        SizedBox(height: 10.0),
                                                      ],
                                                    ))
                                                : Container(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Image.asset(
                                                              'assets/icons/no internet.png'),
                                                        ),
                                                        const SizedBox(
                                                            height: 20.0),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'text6'),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'text7'),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                            const SizedBox(height: 10.0),
                                            RaisedButton(
                                              onPressed: () {
                                                setState(() {
                                                  isLogin = true;
                                                  chengeImage = true;
                                                  serviceConection = true;
                                                });
                                                getAuthorization();
                                                countTID = 0;
                                              },
                                              child: serviceConection
                                                  ? Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('text5'),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('text8'),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                              color: Color.fromRGBO(
                                                  42, 86, 198, 1),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            )),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(240, 242, 241, 1),
                      ),
                      child: Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 3,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          data.logwithG().whenComplete(() {
                                            getAuthorization();
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Image.asset(
                                              'assets/icons/google.png'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          data.authWithFacebook().whenComplete(
                                            () {
                                              getAuthorization();
                                            },
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Container(
                                            constraints: BoxConstraints.expand(
                                              width: 20,
                                              height: 20,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            child: Image.asset(
                                              'assets/icons/facebook.png',
                                              color: Color.fromRGBO(
                                                  65, 90, 147, 1),
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            Container(
              //padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Color.fromRGBO(240, 242, 241, 1),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Companies(),
            ),
          ],
        ),
      ),
    );
  }
}
/* */
/* class MyFlutterApp {
  MyFlutterApp._();

  static const _kFontFam = 'MyFlutterApp';
  static const _kFontPkg = null;

  static const IconData images =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
} */
