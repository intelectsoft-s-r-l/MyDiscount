import '../entities/user_model.dart';

/// [AuthRepository] is a interface for authorization and creation of user in
/// MyDiscount service
abstract class AuthRepository {
  /// Create and/or authorize a user with an Google account
  Future<User> authenticateWithGoogle();

  /// Create and/or authorize a user with an Facebook account
  Future<User> authenticateWithFacebook();

  /// Create and/or authorize a user with an Apple account
  /// Only for iOS platform
  Future<User> authenticateWithApple();

  Future<User> authenticateWithPhone(String phone);

  /// check if exist an authenticated user
  User getAuthUser();

  /// Delete all the user data localy and log out from authorization provider
  /// Except Apple...
  void logOut();
}
