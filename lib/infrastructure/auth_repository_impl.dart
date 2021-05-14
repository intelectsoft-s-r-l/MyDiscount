import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:my_discount/infrastructure/core/fcm_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../domain/core/extension.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/is_service_repository.dart';
import '../domain/repositories/local_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn;
  final FirebaseCloudMessageService _firebaseCloudMessageService;

  final IsService _isService;
  final LocalRepository _localRepositoryImpl;
  List<MapEntry> mapEntryList = [];

  AuthRepositoryImpl(
    this._googleSignIn,
    this._isService,
    this._localRepositoryImpl,
    this._firebaseCloudMessageService,
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
          id: appleCredentials.userIdentifier as String, registerMode: 3);

      final localCredentialsMap = profile.toCreateUser();
      final token = await _firebaseCloudMessageService.getfcmToken();
      final credentialsMap = profile.isEmpty
          ? appleCredentials.toMap().update('PushToken', (_) => token)
          : localCredentialsMap
        ..update('ID', (_) => appleCredentials.userIdentifier)
        ..update('access_token', (_) => appleCredentials.identityToken)
        ..update('PushToken', (_) => token);

      final localUser = await _isService.updateClientInfo(json: credentialsMap);
      return localUser;
    } catch (e) {
      return User.empty();
    }
  }

  @override
  Future<User> authenticateWithFacebook() async {
    try {
      final fbUser = await fb.login(loginBehavior: LoginBehavior.DIALOG_ONLY);
      final fbProfile = await fb.getUserData();

      final profile = await _isService.getClientInfo(
        id: fbUser.accessToken!.userId,
        registerMode: 2,
      );

      final localCredentialsMap = profile.toCreateUser();

      final baseUserCredentials =
          fb.toCredMap(token: fbUser.accessToken, profile: fbProfile);
          
      final token = await _firebaseCloudMessageService.getfcmToken();
      
      final credentialsMap = profile.isEmpty
          ? baseUserCredentials.update('PushToken', (_) => token)
          : localCredentialsMap
        ..update('ID', (_) => fbUser.accessToken!.userId)
        ..update('access_token', (_) => fbUser.accessToken!.token)
        ..update('PushToken', (_) => token);

      final localUser = await _isService.updateClientInfo(json: credentialsMap);

      return localUser;
    } catch (e) {
      return User.empty();
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

        final localCredentialsMap = profile.toCreateUser();
        final token = await _firebaseCloudMessageService.getfcmToken();
        final map = profile.isEmpty
            ? googleCredentials.update('PushToken', (_) => token)
            : localCredentialsMap
          ..update('ID', (_) => _account.id)
          ..update('access_token', (_) => user.accessToken)
          ..update('PushToken', (_) => token);

        final localUser = await _isService.updateClientInfo(json: map);

        return localUser;
      }
      return User.empty();
    } catch (e) {
      return User.empty();
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
