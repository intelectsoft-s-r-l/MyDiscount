import '../domain/entities/user_model.dart';
import '../domain/repositories/user_hive_repo.dart';
import 'package:hive/hive.dart';

class HiveUserRepoImpl implements HiveUserRepository {
  final HiveInterface hive;

  HiveUserRepoImpl(this.hive);
  @override
  void deleteLocalUser()async {
   final userBox = await _openBox('user');
   userBox.delete(1);
  }

  @override
  Future<User> getLocalUser() async {
    final userBox = await _openBox('user');
    final User user = userBox.get(1);
    return user;
  }

  @override
  Future<User> saveLocalUser(User user) async {
    try {
      final userBox = await _openBox('user');
      userBox.put(1, user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<Box<User>> _openBox(String type) async {
    try {
      final box = await hive.openBox(type);
      return box;
    } catch (e) {
      rethrow;
    }
  }
}
