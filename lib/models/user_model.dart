//import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class User /* extends Equatable */ {
  final String displayName;
  final String email;
  final String id;
  final String photoUrl;
  final String pushToken;
  final int registerMode;
  final String accessToken;

  User({
    @required this.displayName,
    @required this.email,
    @required this.id,
    @required this.photoUrl,
    @required this.pushToken,
    @required this.registerMode,
    @required this.accessToken,
  });

  @override
  List<Object> get props =>
      [displayName, email, id, photoUrl, pushToken, registerMode, accessToken];
}

class UserModel extends User {
  UserModel({
    @required String displayName,
    @required String email,
    @required String id,
    @required String photoUrl,
    @required String pushToken,
    @required int registerMode,
    @required String accessToken,
  }) : super(
          displayName: displayName,
          email: email,
          id: id,
          photoUrl: photoUrl,
          pushToken: pushToken,
          registerMode: registerMode,
          accessToken: accessToken,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        displayName: json['DisplayName'],
        email: json['Email'],
        id: json['ID'],
        photoUrl: json['PhotoUrl'],
        pushToken: json['PushToken'],
        registerMode: json['RegisterMode'],
        accessToken: json['access_token']);
  }
  Map<String, dynamic> toJson() {
    return {
      "DisplayName": displayName,
      "Email": email,
      "ID": id,
      "PhotoUrl": photoUrl,
      "PushToken": pushToken,
      "RegisterMode": registerMode,
      "access_token": accessToken
    };
  }
}
