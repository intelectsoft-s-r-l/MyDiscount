import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class User {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String accessToken;
  @HiveField(2)
  final String? expireDate;
  @HiveField(3)
  final int registerMode;

  User({
    required this.id,
    required this.accessToken,
    this.expireDate,
    required this.registerMode,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'] as String,
      accessToken: json['access_token'] as String,
      expireDate: json['expireDate'] as String?,
      registerMode: json['RegisterMode'] as int,
    );
  }

  bool get isEmpty => registerMode == -1;

  factory User.empty() {
    return User(id: '', accessToken: '', expireDate: '', registerMode: -1);
  }
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'access_token': accessToken,
      'expireDate': expireDate,
      'RegisterMode': registerMode,
    };
  }

  @override
 
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            id == other.id &&
            accessToken == other.accessToken &&
            expireDate == other.expireDate &&
            registerMode == other.registerMode;
  }

  @override
  int get hashCode => super.hashCode;

}
