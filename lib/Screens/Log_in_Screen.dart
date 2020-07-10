import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../models/facebook_auth.dart';
import '../models/google_auth.dart';
import 'app_localizations.dart';

class LoginPage extends StatefulWidget {
  @override
  _StateLoginPage createState() => _StateLoginPage();
}

class _StateLoginPage extends State<LoginPage> {
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(42, 86, 198, 1),
          title: Text(
            'MyDiscount',
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GAuth(),
                SizedBox(height: 20),
                FbAuth(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
