import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './Screens/Log_in_Screen.dart';
import './Screens/Home_screen.dart';
import './Screens/companii.dart';
import './Screens/info_screen.dart';
import 'Screens/app_localizations.dart';
import 'models/auth_to_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final RemoteConfig remoteConfig = RemoteConfig();
    remoteConfig.fetch();
    remoteConfig.activateFetched();
  } on FetchThrottledException catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final AuthServ serv = AuthServ();

    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ro', 'RO'),
        Locale('ru', 'RU'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        var retLocale = supportedLocales.first;
        print(locale);

        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            print(supportedLocale);
            return supportedLocale;
          }
        }

        return retLocale;
      },
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: serv.tryAutoLogin(),
        builder: (context, snapshot) => snapshot.hasData && snapshot.data
            ? MyBottomNavigationBar()
            : LoginPage(),
      ),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;
  void _onitemtaped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ro', 'RO'),
        Locale('ru', 'RU'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        var retLocale = supportedLocales.first;
        print(locale);

        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            print(supportedLocale);
            return supportedLocale;
          }
        }

        return retLocale;
      },
      home: Scaffold(
        body: [HomeScreen(), Companies(), Info()].elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromRGBO(42, 86, 198, 1),
          currentIndex: _selectedIndex,
          onTap: _onitemtaped,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                title: Text(
                  'Qr',
                ),
                icon: const Icon(MdiIcons.qrcode)),
            BottomNavigationBarItem(
              title: Text(
                AppLocalizations.of(context).translate('companies'),
              ),
              icon: const Icon(
                Icons.person_pin,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(
                AppLocalizations.of(context).translate('text10'),
              ),
              icon: const Icon(
                Icons.info_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
