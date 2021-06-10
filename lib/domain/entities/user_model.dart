import 'package:hive/hive.dart';

part 'user_model.g.dart';
/// Dart object for User data provided by authorization provider

@HiveType(typeId: 3)
class User {
  /// User ID
  /// Is required to create user in MyDiscount Service 
  @HiveField(0)
  final String id;
  /// User access token 
  @HiveField(1)
  final String accessToken;
  /// Date time when expire user data and is necessary to log in again 
  /// Not used for now
  @HiveField(2)
  final String? expireDate;
  ///Service register mode 
  /// 1-Google
  /// 2-Facebook
  /// 3-Apple
  /// Is required to create user in MyDiscount Service
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
