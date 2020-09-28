import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../services/fcm_service.dart';
import '../main.dart';
import '../services/shared_preferences_service.dart';

class AuthService extends ChangeNotifier {
  FacebookLogin _facebookLogin = FacebookLogin();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  SharedPref prefs = SharedPref();
  FCMService fcmService = FCMService();
  Future<bool> authWithFacebook() async {
    try {
      final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          FacebookAccessToken _accessToken = result.accessToken;
          final _graphResponse = await http.get(
              'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=${_accessToken.token}');
          final profile = json.decode(_graphResponse.body);
          final fcmToken = await fcmService.getfcmToken();
          final _credentials = {
            "DisplayName": profile['name'],
            "Email": profile['email'],
            "ID": _accessToken.userId,
            "PhotoUrl": profile['picture']['data']['url'],
            "PushToken": fcmToken,
            "RegisterMode": 2,
            "access_token": _accessToken.token,
          };
          print(_credentials);
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
          final fcmToken = await fcmService.getfcmToken();
          final _credentials = {
            "DisplayName": account.displayName,
            "Email": account.email,
            "ID": account.id,
            "PhotoUrl": account.photoUrl,
            "PushToken": fcmToken,
            "RegisterMode": 1,
            "access_token": auth.accessToken,
          };
          final String _data = json.encode(_credentials);
          prefs.credentials(_data);
          print(_credentials);
        },
      ).whenComplete(() => main());
      return true;
    } catch (e) {
      return false;
    }
  }

  void signOut() async {
    final prefs = await SharedPreferences.getInstance();
    _facebookLogin.logOut();
    googleSignIn.signOut();
    prefs.clear();
  }

  signInWithApple() async {
    final fcmToken = await fcmService.getfcmToken();
    AppleIDAuthorizationRequest();
    var appleCredentials = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName
    ]);
    final _credentials = {
      "DisplayName": appleCredentials.givenName,
      "Email": appleCredentials.email,
      "ID": appleCredentials.userIdentifier,
      "PhotoUrl": "",
      "PushToken": fcmToken,
      "RegisterMode": 1,
      "access_token": appleCredentials.identityToken,
    };
    final String _data = json.encode(_credentials);
    prefs.credentials(_data);
    print(_data);
  }
}
