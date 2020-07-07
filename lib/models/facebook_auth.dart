import 'dart:convert';
import 'package:MyDiscount/Screens/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/SharedPref.dart';

class FbAuth extends StatefulWidget {
  @override
  _FbAuthState createState() => _FbAuthState();
}

class _FbAuthState extends State<FbAuth> {
  SharedPref prefs = SharedPref();

  @override
  Widget build(BuildContext context) {
    final FacebookLogin _facebookLogin = FacebookLogin();

    Future<void> authFb() async {
      final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken _accessToken = result.accessToken;
          final _graphResponse = await http.get(
              'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=${_accessToken.token}');
          final profile = json.decode(_graphResponse.body);
          final _credentials = {
            "DisplayName": profile['name'],
            "Email": profile['email'],
            "ID": _accessToken.userId,
            "PhotoUrl": profile['picture']['data']['url'],
            "RegisterMode": 1,
            "access_token": _accessToken.token,
          };
          final String _data = json.encode(_credentials);
          prefs.credentials(_data);
          if (_accessToken != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MyBottomNavigationBar(),
              ),
            );
          } else {
            throw Exception();
          }
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          break;
      }
    }

    return Container(
      width: 200,
      child: FlatButton(
        color: Color.fromRGBO(65, 90, 147, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          authFb();
        },
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/icons/facebook.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              AppLocalizations.of(context).translate('text11'),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
