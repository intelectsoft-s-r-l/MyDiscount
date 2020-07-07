import 'dart:convert';

import 'package:MyDiscount/Screens/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../models/SharedPref.dart';

class GAuth extends StatefulWidget {
  @override
  _GAuthState createState() => _GAuthState();
}

class _GAuthState extends State<GAuth> {
  final SharedPref prefs = SharedPref();

  @override
  Widget build(BuildContext context) {
    void logwithG() async {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      try {
        googleSignIn.signIn().then(
          (final GoogleSignInAccount account) async {
            final GoogleSignInAuthentication auth =
                await account.authentication;
            final _credentials = {
              "DisplayName": account.displayName,
              "Email": account.email,
              "ID": account.id,
              "PhotoUrl": auth.accessToken,
              "RegisterMode": 1,
              "access_token": account.photoUrl,
            };
            final String _data = json.encode(_credentials);
            prefs.credentials(_data);
            if (auth != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyBottomNavigationBar(),
                ),
              );
            }
          },
        );
      } catch (e) {
        throw Exception(e);
      }
    }

    return Container(
      width: 200,
      child: FlatButton(
        color: Color.fromRGBO(52, 122, 246, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          logwithG();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/icons/google.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              AppLocalizations.of(context).translate('text12'),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
