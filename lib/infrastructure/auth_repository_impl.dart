import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../domain/core/extension.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/is_service_repository.dart';
import '../domain/repositories/local_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn;

  final IsService _isService;
  final LocalRepository _localRepositoryImpl;
  List<MapEntry> mapEntryList = [];

  AuthRepositoryImpl(
    this._googleSignIn,
    this._isService,
    this._localRepositoryImpl,
  );
  final fb = FacebookAuth.instance;

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

      final localCredentialsMap = profile?.toCreateUser();

      final credentialsMap =
          profile == null ? appleCredentials.toMap() : localCredentialsMap
            ..update('ID', (_) => appleCredentials.userIdentifier)
            ..update('access_token', (_) => appleCredentials.identityToken);

      final localUser = await _isService.updateClientInfo(json: credentialsMap);
      return localUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> authenticateWithFacebook() async {
    try {
      final token = await fb.login();
      final fbProfile = await fb.getUserData();

      final profile = await _isService.getClientInfo(
        id: token?.userId,
        registerMode: 2,
      );

      final localCredentialsMap = profile?.toCreateUser();

      final baseUserCredentials =
          fb.toCredMap(token: token, profile: fbProfile);

      final credentialsMap =
          profile == null ? baseUserCredentials : localCredentialsMap
            ..update('ID', (_) => token.userId)
            ..update('access_token', (_) => token.token);

      final localUser = await _isService.updateClientInfo(json: credentialsMap);

      return localUser;
    } catch (e) {
      return null;
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
        final googleCredentials = _account.toMap(user.idToken);

        final localCredentialsMap = profile?.toCreateUser();

        final map = profile == null ? googleCredentials : localCredentialsMap
          ..update('ID', (_) => _account.id)
          ..update('access_token', (_) => user.accessToken);

        final localUser = await _isService.updateClientInfo(json: map);

        return localUser;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  void logOut() {
    _localRepositoryImpl.deleteLocalUser();
    _googleSignIn.signOut();
    fb.logOut();
  }

  @override
  User getAuthUser() {
    final user = _localRepositoryImpl.getLocalUser();
    return user;
  }
}
