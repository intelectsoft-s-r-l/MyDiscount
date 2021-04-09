import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class User {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String accessToken;
  @HiveField(2)
  final String expireDate;
  @HiveField(3)
  final int registerMode;

  User({
    this.id,
    this.accessToken,
    this.expireDate,
    this.registerMode,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'] as String,
      accessToken: json['access_token'] as String,
      expireDate: json['expireDate'] as String,
      registerMode: json['RegisterMode'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'access_token': accessToken,
      'expireDate': expireDate,
      'RegisterMode':registerMode,
    };
  }
}
