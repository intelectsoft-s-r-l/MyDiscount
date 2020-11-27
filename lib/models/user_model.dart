//import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String accessToken;

  bool _isLogedIn;
  bool get isLogedIn => _isLogedIn;

  User({
    @required this.id,
    @required this.accessToken,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      accessToken: json['access_token'],
    );
  }
  Map<String, dynamic> toJson() {
    return {"ID": id, "access_token": accessToken};
  }
}
