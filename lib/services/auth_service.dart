import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_preferences_service.dart';

class AuthService extends ChangeNotifier {
  FacebookLogin _facebookLogin = FacebookLogin();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  SharedPref prefs = SharedPref();

  Future<bool> authWithFacebook() async {
    try {
      final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          FacebookAccessToken _accessToken = result.accessToken;
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
          return true;
          break;
        case FacebookLoginStatus.cancelledByUser:
          return false;
          break;
        case FacebookLoginStatus.error:
          return false;
          break;
      }
    } catch (e) {
      throw Error();
    }
    return false;
  }

  Future<bool> logwithG() async {
    try {
      googleSignIn.signIn().then(
        (final GoogleSignInAccount account) async {
          final GoogleSignInAuthentication auth = await account.authentication;
          final _credentials = {
            "DisplayName": account.displayName,
            "Email": account.email,
            "ID": account.id,
            "PhotoUrl": account.photoUrl,
            "RegisterMode": 1,
            "access_token": auth.accessToken,
          };
          final String _data = json.encode(_credentials);
          prefs.credentials(_data);
        },
      );
      return true;
    } catch (e) {
      return false;
      //throw Exception(e);
    }
  }

  void signOut() async {
    final prefs = await SharedPreferences.getInstance();
    _facebookLogin.logOut();
    googleSignIn.signOut();
    prefs.clear();
  }
}
