import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../domain/entities/user_model.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/is_service_repository.dart';
import '../domain/repositories/local_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  final IsService _isService;
  final LocalRepository _localRepositoryImpl;
  List<MapEntry> mapEntryList = [];

  AuthRepositoryImpl(
    this._googleSignIn,
    this._facebookLogin,
    this._isService,
    this._localRepositoryImpl,
  );

  @override
  Future<User> authenticateWithApple() async {
    try {
      final appleCredentials = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ]);
      final profile = await _isService.getClientInfo(
          id: appleCredentials.userIdentifier, registerMode: 3);

      final displayName = profile == null
          ? '${appleCredentials.givenName ?? ''} ${appleCredentials.familyName ?? ''}'
          : '${profile.firstName} ${profile.lastName}';
      final photo = profile == null ? '' : base64Encode(profile.photo);
      final phone = profile == null ? '' : profile.phone;
      final email = profile == null ? appleCredentials.email : profile.email;

      mapEntryList.add(MapEntry('DisplayName', displayName));
      mapEntryList.add(MapEntry('Email', email));
      mapEntryList.add(MapEntry('ID', appleCredentials.userIdentifier));
      mapEntryList.add(MapEntry('PhotoUrl', photo));
      mapEntryList.add(MapEntry('PushToken', ''));
      mapEntryList.add(const MapEntry('RegisterMode', 3));
      mapEntryList
          .add(MapEntry('access_token', appleCredentials.identityToken));
      mapEntryList.add(MapEntry('phone', phone));

      final map = addCredentialstoMap(list: mapEntryList);

      final localUser = await _isService.updateClientInfo(json: map);
      return localUser;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> authenticateWithFacebook() async {
    try {
      final _result = await _facebookLogin.logIn(['email']);
      switch (_result.status) {
        case FacebookLoginStatus.loggedIn:
          final _token = _result.accessToken;
          final _fbProfile =
              await _localRepositoryImpl.getFacebookProfile(_token.token);
          final profile = await _isService.getClientInfo(
              id: _token.userId, registerMode: 2);

          final displayName = profile == null
              ? _fbProfile['name']
              : '${profile.firstName} ${profile.lastName}';
          final photo = profile == null
              ? _fbProfile['picture']['data']['url']
              : base64Encode(profile.photo);
          final phone = profile == null ? '' : profile.phone;
          final email = profile == null ? _fbProfile['email'] : profile.email;

          mapEntryList.add(MapEntry('DisplayName', displayName));
          mapEntryList.add(MapEntry('Email', email));
          mapEntryList.add(MapEntry('ID', _token.userId));
          mapEntryList.add(MapEntry('PhotoUrl', photo));
          mapEntryList.add(const MapEntry('PushToken', ''));
          mapEntryList.add(const MapEntry('RegisterMode', 2));
          mapEntryList.add(MapEntry('access_token', _token.token));
          mapEntryList.add(MapEntry('phone', phone));

          final map = addCredentialstoMap(list: mapEntryList);

          final localUser = await _isService.updateClientInfo(json: map);

          return localUser;
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          break;
      }
      return null;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> authenticateWithGoogle() async {
    try {
      final _account = await _googleSignIn.signIn();
      if (_account != null) {
        final user = await _account.authentication;
        final profile =
            await _isService.getClientInfo(id: _account.id, registerMode: 1);

        final displayName = profile == null
            ? _account.displayName
            : '${profile.firstName} ${profile.lastName}';
        final photo =
            profile == null ? _account.photoUrl : base64Encode(profile.photo);
        final phone = profile == null ? '' : profile.phone;
        final email = profile == null ? _account.email : profile.email;
        mapEntryList.add(MapEntry('DisplayName', displayName));
        mapEntryList.add(MapEntry('Email', email));
        mapEntryList.add(MapEntry('ID', _account.id));
        mapEntryList.add(MapEntry('PhotoUrl', photo));
        mapEntryList.add(MapEntry('PushToken', ''));
        mapEntryList.add(const MapEntry('RegisterMode', 1));
        mapEntryList.add(MapEntry('access_token', user.idToken));
        mapEntryList.add(MapEntry('phone', phone));
        final map = addCredentialstoMap(list: mapEntryList);

        final localUser = await _isService.updateClientInfo(json: map);
        return localUser;
      }
      return null;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  void logOut() {
    _localRepositoryImpl.deleteLocalUser();
    _googleSignIn.signOut();
    _facebookLogin.logOut();
  }

  @override
  User getAuthUser() {
    final user = _localRepositoryImpl.getLocalUser();
    return user;
  }
}

Map<String, dynamic> addCredentialstoMap({List<MapEntry> list}) {
  final credentialsMap = {};
  list.map((element) {
    credentialsMap.putIfAbsent(element.key, () => element.value);
  });
  return credentialsMap;
}
