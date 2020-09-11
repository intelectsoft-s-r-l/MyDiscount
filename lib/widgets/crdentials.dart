import 'dart:convert';

import 'package:MyDiscount/services/fcm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_preferences_service.dart';

SharedPref sPrefs = SharedPref();
FCMService fcmService = FCMService();

class Credentials {
  static const String credentials = "appuser:frj936epae293e9c6epae29";
  static Codec<String, String> stringToBase64 = utf8.fuse(base64);
  static String encoded = stringToBase64.encode(credentials);
}

getBodyData() async {
  var token =await fcmService.getfcmToken();
  print("tis is:$token");
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('Tid')) {
    var savedCredential = await sPrefs.credential();
    var userData = json.decode(savedCredential);
    final minUserData = json.encode(
        {"ID": userData['ID'], "RegisterMode": userData['RegisterMode']});
    return minUserData;
  } else {
    var fullUserData = await sPrefs.credential();
    return fullUserData;
  }
}
