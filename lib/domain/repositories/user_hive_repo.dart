import 'package:MyDiscount/domain/entities/user_model.dart';

abstract class HiveUserRepository {
  Future<User> saveLocalUser(User user);
  Future<User> getLocalUser();
  void deleteLocalUser();
}
