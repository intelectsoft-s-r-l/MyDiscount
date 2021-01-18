import 'dart:async';
import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../core/decode.dart';
import '../models/profile_model.dart';
import '../models/user_credentials.dart';
import '../models/user_model.dart';
import '../services/fcm_service.dart';

StreamController<bool> authController = StreamController.broadcast();

class AuthService extends UserCredentials {
  Decoder decoder = Decoder();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'email',
  ]);
  FacebookLogin _facebookLogin = FacebookLogin();

  FirebaseCloudMessageService fcmService = FirebaseCloudMessageService();

  String _expireDate = DateTime.now().add(Duration(hours: 3)).toString();

  Future<User> authWithFacebook() async {
    try {
      final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
      print('facebook result:${result.toString()}');
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          FacebookAccessToken _accessToken = result.accessToken;
          final Map<String, dynamic> profile =
              await getFacebookProfile(_accessToken.token);
          final String fcmToken = await fcmService.getfcmToken();
          saveUserRegistrationDatatoMap(User(
            id: _accessToken.userId,
            accessToken: _accessToken.token,
            expireDate: _expireDate,
          ));
          final splitedDisplayName = splitTheStrings(profile['name']);
          saveProfileRegistrationDataToMap(Profile(
            firstName: splitedDisplayName[0],
            lastName: splitedDisplayName[1],
            email: profile['email'],
            photoUrl: profile['picture']['data']['url'],
            registerMode: 2,
            pushToken: fcmToken,
          ));
          return User(
            id: _accessToken.userId,
            accessToken: _accessToken.token,
            expireDate: _expireDate,
          );
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          break;
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);

      throw Exception(e);
    }
    return User(id: null, accessToken: null, expireDate: null);
  }

  Future<Map<String, dynamic>> getFacebookProfile(String token) async {
    final _graphResponse = await http.get(
        'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=$token');
    return json.decode(_graphResponse.body);
  }

  Future<void> logwithG() async {
    try {
      final GoogleSignInAccount account = await googleSignIn.signIn();

      final GoogleSignInAuthentication auth = await account.authentication;

      final fcmToken = await fcmService.getfcmToken();

      if (googleSignIn.currentUser.id != null) {
        saveUserRegistrationDatatoMap(
          User(
            id: account.id,
            accessToken: auth.accessToken,
            expireDate: _expireDate,
          ),
        );
        final splitedDisplayName = splitTheStrings(account.displayName);
        saveProfileRegistrationDataToMap(
          Profile(
            firstName: splitedDisplayName[0],
            lastName: splitedDisplayName[1],
            email: account.email,
            photoUrl: account.photoUrl ?? '',
            registerMode: 1,
            pushToken: fcmToken,
          ),
        );
      }
      return User(
        id: account.id,
        accessToken: auth.accessToken,
        expireDate: _expireDate,
      );
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      FirebaseCrashlytics.instance.setCustomKey('log with google', s);
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    _facebookLogin.logOut();
    googleSignIn.signOut();
    prefs.remove('Tid');
    prefs.remove('user');
    //authController.add(false);
    //Navigator.of(context).pushReplacementNamed('/loginscreen');
  }

  Future<void> signInWithApple() async {
    try {
      var appleCredentials = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ]);

      final fcmToken = await fcmService.getfcmToken();

      saveUserRegistrationDatatoMap(User(
        id: appleCredentials.userIdentifier,
        accessToken: appleCredentials.identityToken,
        expireDate: _expireDate,
      ));

      saveProfileRegistrationDataToMap(
        Profile(
          firstName: appleCredentials.familyName ?? '',
          lastName: appleCredentials.givenName ?? '',
          email: appleCredentials.email,
          registerMode: 3,
          pushToken: fcmToken,
        ),
      );
      return User(
        id: appleCredentials.userIdentifier,
        accessToken: appleCredentials.identityToken,
        expireDate: _expireDate,
      );
    } on SignInWithAppleAuthorizationException {
      throw SignInWithAppleCredentialsException(message: 'Remove from user');
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);

      throw Exception(e);
    }
  }
}
