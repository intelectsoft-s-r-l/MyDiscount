import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_preferences_service.dart';

SharedPref sPrefs = SharedPref();

class Credentials {
  static const String credentials = "appuser:frj936epae293e9c6epae29";
  static Codec<String, String> stringToBase64 = utf8.fuse(base64);
  static String encoded = stringToBase64.encode(credentials);
}

getBodyData() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('Tid')) {
    var savedCredential = await sPrefs.credential();
    var userData = json.decode(savedCredential);
    final minUserData = json.encode(
      {"ID": userData['ID'], "RegisterMode": userData['RegisterMode']},
    );
    return minUserData;
  } else {
    var fullUserData = await sPrefs.credential();
    return fullUserData;
  }
}

getUserId() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('Tid')) {
    var savedCredential = await sPrefs.credential();
    var userData = json.decode(savedCredential);
    var id = userData['ID'];
    return id;
  } else {
    return '';
  }
}

Future<String> getUserData() async {
  /* Map _defaultUserData = {"DisplayName": 'IntelectSoft SRL',
            "Email":'' ,
           
            "PhotoUrl": 'https://edi.md/wp-content/uploads/2016/01/logo_is.png',
           }; */
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('Tid')) {
    var _savedCredential = await sPrefs.credential();
    var _userData = json.decode(_savedCredential);
    return _userData['DisplayName'];
  } else {
    return '' /* _defaultUserData */;
  }
}
