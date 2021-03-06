import '../entities/user_model.dart';

abstract class AuthRepository {
  Future<User> authenticateWithGoogle();
  Future<User> authenticateWithFacebook();
  Future<User> authenticateWithApple();
  User getAuthUser();
  void logOut();
  //Future<User> authenticateWithPhoneNumber();
}
