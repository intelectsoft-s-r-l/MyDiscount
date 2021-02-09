import 'package:MyDiscount/domain/entities/user_model.dart';

abstract class AuthRepository {
  Future<User> authenticateWithGoogle();
  Future<User> authenticateWithFacebook();
  Future<User> authenticateWithAple();
  Future<User> authenticateWithPhoneNumber();
}
