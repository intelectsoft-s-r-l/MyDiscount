import 'dart:async';
import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../services/fcm_service.dart';
import '../widgets/user_credentials.dart';

StreamController<bool> authController = StreamController.broadcast();

class AuthService extends UserCredentials {
  FacebookLogin _facebookLogin = FacebookLogin();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  FCMService fcmService = FCMService();

  Future<void> authWithFacebook() async {
    try {
      final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          FacebookAccessToken _accessToken = result.accessToken;
          final profile = await getFacebookProfile(_accessToken.token);
          final fcmToken = await fcmService.getfcmToken();
          userCredentialstoMap(
            displayName: profile['name'],
            email: profile['email'],
            id: _accessToken.userId,
            photoUrl: profile['picture']['data']['url'],
            pushToken: fcmToken,
            registerMode: 2,
            accessToken: _accessToken.token,
            //authorizationCode: null,
          );
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          break;
      }
    } catch (e, s) {
      //FirebaseCrashlytics.instance.recordError(e, s);
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getFacebookProfile(String token) async {
    final _graphResponse = await http.get(
        'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=$token');
    return json.decode(_graphResponse.body);
  }

/* if ( */
  Future<void> logwithG(context) async {
    try {
      final account = await googleSignIn.signIn();
      if (account == null) {
        throw Exception();
      } else {
        final auth = await account.authentication;

        final fcmToken = await fcmService.getfcmToken();
        if (googleSignIn.currentUser != null) {
          userCredentialstoMap(
              displayName: account.displayName,
              email: account.email,
              id: account.id,
              photoUrl: account.photoUrl,
              pushToken: fcmToken,
              registerMode: 1,
              accessToken: auth.accessToken);
        }
      }
    } catch (e, s) {
     //FirebaseCrashlytics.instance.recordError(e, s);
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    _facebookLogin.logOut();
    googleSignIn.signOut();
    prefs.clear();
  }

  Future<void> signInWithApple() async {
    try {
      var appleCredentials = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ]);

      final fcmToken = await fcmService.getfcmToken();

      userCredentialstoMap(
        displayName: '${appleCredentials.familyName}' +
            " " +
            '${appleCredentials.givenName}',
        email: appleCredentials.email,
        id: appleCredentials.userIdentifier,
        photoUrl: null,
        pushToken: fcmToken,
        registerMode: 3,
        accessToken: appleCredentials.identityToken,
        // authorizationCode: appleCredentials.authorizationCode,
      );
    } on SignInWithAppleAuthorizationException {
      throw SignInWithAppleCredentialsException(message: 'Remove from user');
    } catch (e, s) {
      //FirebaseCrashlytics.instance.recordError(e, s);
      throw Exception(e);
    }
  }
}
