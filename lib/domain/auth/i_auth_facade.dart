import 'package:my_discount/domain/auth/user_model.dart';

abstract class IAuthFacade {
  Future<User> createUserWithApple();
  Future<User> createUserWithFacebook();
  Future<User> createUserWithGoogle();
  Future<User> getSignedUser();
  Future<void> logOut();
}
