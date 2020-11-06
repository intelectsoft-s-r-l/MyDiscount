import 'dart:convert';

import '../../services/shared_preferences_service.dart';

SharedPref sPrefs = SharedPref();

class Credentials {
  static const String credentials = "appuser:frj936epae293e9c6epae29";
  static Codec<String, String> stringToBase64 = utf8.fuse(base64);
  static String encoded = stringToBase64.encode(credentials);
}


