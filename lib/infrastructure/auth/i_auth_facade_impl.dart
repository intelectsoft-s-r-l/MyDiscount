import 'package:my_discount/domain/auth/i_auth_facade.dart';
import 'package:my_discount/domain/auth/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class IAuthFacadeImpl implements IAuthFacade{
  @override
  Future<User> createUserWithApple() async{
     /* try {
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
    } */
  }

  @override
  Future<User> createUserWithFacebook() {
    // TODO: implement createUserWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<User> createUserWithGoogle() {
    // TODO: implement createUserWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<User> getSignedUser() {
    // TODO: implement getSignedUser
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }
  
}