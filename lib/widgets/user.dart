import 'dart:convert';

import '../services/shared_preferences_service.dart';

class UserCredentials extends User {
  
  SharedPref prefs = SharedPref();
  saveUserCredentials(
    String id,
    int registerMode,
    String pushToken,
    String displayName,
    String email,
    String photoUrl,
    String accessToken,
    String authorizationCode,
  ) {
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
abstract class User{
String displayName;
  String email;
  int id;
  String photoUrl;
  String pushToken;
  int registerMode;
  String accessToken;
  String authorizationCode;
}