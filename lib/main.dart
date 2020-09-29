
import 'dart:async';
import 'dart:ui';

import 'package:MyDiscount/services/remote_config_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import './Screens/companies_screen.dart';
import './Screens/info_screen.dart';
import './Screens/login_screen.dart';
import './Screens/qr_screen.dart';
import './services/fcm_service.dart';
import './services/internet_connection_service.dart';
import './services/auth_service.dart';
import './services/qr_service.dart';
import './widgets/localizations.dart';
import 'widgets/crdentials.dart';

FCMService fcmService = FCMService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Crashlytics.instance.enableInDevMode = true;
  getServiceName();
  //FlutterError.onError = Crashlytics.instance.recordFlutterError;
   fcmService.fcmConfigure();
   fcmService.getFlutterLocalNotificationPlugin();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    /* runZoned(() { */
      runApp(MyApp());
   /*  }, onError: Crashlytics.instance.recordError); */

    fcmService.getfcmToken();
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
      ],
      child: MaterialApp(
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
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  StreamController<int> _indexController = StreamController.broadcast();
  PageController _pageController;
  int selectedIndex = 0;
  Credentials credentials = Credentials();

  static QrService _qrService = QrService();

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 1,
    );
    selectedIndex = _pageController.initialPage;
    super.initState();
  }

  @override
  void dispose() {
    _indexController.close();
    fcmService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AuthService>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 242, 241, 1),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            height: size.height * .25,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                /* Positioned(
                  top: 30, //size.height * .06,
                  left: -10, //size.width * .33,
                  child: FutureBuilder(
                      future: getImageUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          return Container(
                            alignment: Alignment.center,
                            width: size.width * .33,
                            child: /* CircleAvatar(
                              child: */ Text/* Image.network */(
                                '${snapshot.data['DisplayName']}',
                               /*  scale: 1.0, fit: BoxFit.contain,*/
                              ),
                           /*  ), */
                          );
                        } else {
                          return Container();
                        }
                      }),
                ), */
                Positioned(
                  top: size.height * .06,
                  left: size.width * .33,
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width * .33,
                    child: Text(
                      "MyDiscount",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * .045,
                  right: 10,
                  child: IconButton(
                      color: Colors.green,
                      icon: Icon(MdiIcons.locationExit),
                      onPressed: () {
                        data.signOut();
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 50),
                            curve: Curves.ease);
                        setState(() {});
                      }),
                ),
                Positioned(
                  bottom: size.height * .05,
                  child: StreamBuilder<int>(
                      stream: _indexController.stream,
                      initialData: 1,
                      builder: (context, snapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (selectedIndex != 0) {
                                  _pageController.jumpToPage(
                                    0,
                                  );
                                  _indexController.add(0);
                                }
                              },
                              child: Container(
                                width: size.width * 0.33,
                                child: CircleAvatar(
                                  minRadius: 26.5,
                                  backgroundColor:
                                      _pageController.initialPage - 1 ==
                                              snapshot.data
                                          ? Colors.green
                                          : Colors.white,
                                  child: ImageIcon(
                                    const AssetImage('assets/icons/qrlogo.png'),
                                    size: 53,
                                    color: _pageController.initialPage - 1 ==
                                            snapshot.data
                                        ? Colors.white
                                        : Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _pageController.jumpToPage(
                                  1,
                                );
                                _indexController.add(1);
                              },
                              child: Container(
                                width: size.width * 0.33,
                                child: CircleAvatar(
                                  minRadius: 26.5,
                                  backgroundColor:
                                      _pageController.initialPage ==
                                              snapshot.data
                                          ? Colors.green
                                          : Colors.white,
                                  child: ImageIcon(
                                    const AssetImage('assets/icons/qq3.png'),
                                    size: 53,
                                    color: _pageController.initialPage ==
                                            snapshot.data
                                        ? Colors.white
                                        : Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _pageController.jumpToPage(
                                  2,
                                );
                                _indexController.add(2);
                              },
                              child: Container(
                                width: size.width * 0.33,
                                child: CircleAvatar(
                                  minRadius: 26.5,
                                  backgroundColor:
                                      _pageController.initialPage + 1 ==
                                              snapshot.data
                                          ? Colors.green
                                          : Colors.white,
                                  child: ImageIcon(
                                    const AssetImage('assets/icons/news1.png'),
                                    size: 53,
                                    color: _pageController.initialPage + 1 ==
                                            snapshot.data
                                        ? Colors.white
                                        : Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                Positioned(
                  bottom: size.height * .020,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.center,
                        width: size.width * 0.33,
                        child: Text(
                          AppLocalizations.of(context).translate('companies'),
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: size.width * 0.33,
                        child: Text(
                          'QR',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: size.width * 0.33,
                        child: Text(
                          AppLocalizations.of(context).translate('text10'),
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: PageView(
                dragStartBehavior: DragStartBehavior.down,
                pageSnapping: true,
                onPageChanged: (value) async {
                  _indexController.add(selectedIndex = value);
                },
                allowImplicitScrolling: false,
                controller: _pageController,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 242, 241, 1),
                    ),
                    width: size.width * 0.9,
                    height: size.height * 0.6,
                    child: Companies(),
                  ),
                  Container(
                    child: FutureBuilder(
                      future: _qrService.tryAutoLogin(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data == true
                              ? QrScreen()
                              : LoginPage();
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
          ),
        ],
      ),
    );
  }
}
