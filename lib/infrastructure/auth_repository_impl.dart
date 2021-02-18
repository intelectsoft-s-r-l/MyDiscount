import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:injectable/injectable.dart';

import '../domain/entities/user_model.dart';
import '../domain/repositories/auth_repository.dart';
import '../infrastructure/is_service_impl.dart';
import '../infrastructure/local_repository_impl.dart';

@injectable
class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  final IsServiceImpl _isService;
  final LocalRepositoryImpl _localRepositoryImpl;

  AuthRepositoryImpl(this._googleSignIn, this._facebookLogin, this._isService, this._localRepositoryImpl);
  @override
  Future<User> authenticateWithApple() async {
    final appleCredentials = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
    User localUser = await _isService.updateClientInfo(json: {
      "DisplayName": '${appleCredentials.givenName} + " " + ${appleCredentials.familyName}',
      "Email": appleCredentials.email,
      "ID": appleCredentials.userIdentifier,
      "PhotoUrl": '',
      "PushToken": '',
      "RegisterMode": 3,
      "access_token": appleCredentials.identityToken,
    });
    return localUser;
  }

  @override
  Future<User> authenticateWithFacebook() async {
    FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
    switch (_result.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken _token = _result.accessToken;
        final _fbProfile = await _localRepositoryImpl.getFacebookProfile(_token.token);
        User localUser = await _isService.updateClientInfo(json: {
          "DisplayName": _fbProfile['name'],
          "Email": _fbProfile['email'],
          "ID": _token.userId,
          "PhotoUrl": _fbProfile['picture']['data']['url'],
          "PushToken": '',
          "RegisterMode": 2,
          "access_token": _token.token,
        });
        return localUser;
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
    return null;
  }

  @override
  Future<User> authenticateWithGoogle() async {
    final _account = await _googleSignIn.signIn();
    if (_account != null) {
      final user = await _account.authentication;
      User localUser = await _isService.updateClientInfo(json: {
        "DisplayName": _account.displayName,
        "Email": _account.email,
        "ID": _account.id,
        "PhotoUrl": _account.photoUrl,
        "PushToken": '',
        "RegisterMode": 1,
        "access_token": user.idToken,
      });
      return localUser;
    }
    return null;
  }

  @override
  void logOut() {
    _localRepositoryImpl.deleteLocalUser();
    _googleSignIn.signOut();
    _facebookLogin.logOut();
  }

  @override
  User getAuthUser() {
    final User user = _localRepositoryImpl.getLocalUser();
    return user;
  }
}
