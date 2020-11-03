
import 'package:flutter/material.dart';
@immutable
class User {
  final String displayName;
  final String email;
  final String id;
  final String photoUrl;
  final String pushToken;
  final int registerMode;
  final String accessToken;

  User({
    this.displayName,
    this.email,
    @required this.id,
    this.photoUrl,
    this.pushToken,
    @required this.registerMode,
    @required this.accessToken,
  })  : assert(id != null),
        assert(registerMode != null);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json;
    json['DisplayName'] = displayName;
    json['Email'] = email;
    json['ID'] = id;
    json['PhotoUrl'] = photoUrl;
    json['PushToken'] = pushToken;
    json['RegisterMode'] = registerMode;
    json['access_token'] = accessToken;
    return json;
  }
}
