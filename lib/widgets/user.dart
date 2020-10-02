import 'dart:convert';

import '../services/shared_preferences_service.dart';

class UserCredentials {
  String displayName;
  String email;
  int id;
  String photoUrl;
  String pushToken;
  int registerMode;
  String accessToken;
  String authorizationCode;
  SharedPref prefs = SharedPref();
  saveUserCredentials(
      id, registerMode, pushToken, displayName, email, photoUrl, accessToken,authorizationCode,) {
    final Map<String, dynamic> _credentials = {
      "DisplayName": displayName,
      "Email": email,
      "ID": id,
      "PhotoUrl": photoUrl,
      "PushToken": pushToken,
      "RegisterMode": registerMode,
      "access_token": accessToken
    };
    final String _data = json.encode(_credentials);
    prefs.credentials(_data);
    print(_data);
  }
}
