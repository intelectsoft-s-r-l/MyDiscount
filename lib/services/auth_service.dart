import 'dart:async';
import 'dart:convert';

import 'package:MyDiscount/domain/entities/profile_model.dart';
import 'package:MyDiscount/domain/entities/user_model.dart';
import 'package:MyDiscount/services/user_credentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../services/fcm_service.dart';

@injectable
class AuthService extends UserCredentials {
  final GoogleSignIn googleSignIn;
  final FacebookLogin _facebookLogin;
  final FirebaseCloudMessageService fcmService;

  final String _expireDate = DateTime.now().add(const Duration(hours: 3)).toString();

  AuthService(this.googleSignIn, this._facebookLogin, this.fcmService);

  Future<User> authWithFacebook() async {
    try {
      final FacebookLoginResult result = await _facebookLogin?.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken _accessToken = result.accessToken;
          final Map<String, dynamic> profile = await getFacebookProfile(_accessToken?.token);
          final String fcmToken = await fcmService.getfcmToken();
          saveUserRegistrationDatatoMap(User(
            id: _accessToken.userId,
            accessToken: _accessToken.token,
            expireDate: _expireDate,
          ));
          final splitedDisplayName = splitTheStrings(profile['name'] as String);
          saveProfileRegistrationDataToMap(Profile(
            firstName: splitedDisplayName[0] ?? '',
            lastName: splitedDisplayName[1] ?? '',
            email: profile['email'] as String,
            photoUrl: profile['picture']['data']['url'] as String,
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
    final _graphResponse = await http.get('https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=$token');
    return json.decode(_graphResponse.body) as Map<String, dynamic>;
  }

  Future<void> logwithG() async {
    try {
      final GoogleSignInAccount account = await googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication auth = await account?.authentication;

        final fcmToken = await fcmService.getfcmToken();

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
            firstName: splitedDisplayName[0] ?? '',
            lastName: splitedDisplayName[1] ?? '',
            email: account.email,
            photoUrl: account.photoUrl ?? '',
            registerMode: 1,
            pushToken: fcmToken,
          ),
        );

        return User(
          id: account.id,
          accessToken: auth.accessToken,
          expireDate: _expireDate,
        );
      }
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
  }

  Future<void> signInWithApple() async {
    try {
      final appleCredentials = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);

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
      throw const SignInWithAppleCredentialsException(message: 'Remove from user');
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);

      throw Exception(e);
    }
  }
}
