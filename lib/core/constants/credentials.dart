import 'dart:convert';

class Credentials {
  static const String credentials = "appuser:frj936epae293e9c6epae29";
  
  static Codec<String, String> stringToBase64 = utf8.fuse(base64);
  
  static String encoded = stringToBase64.encode(credentials);
  
 final  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + encoded,
  };
  
  Map<String, String> get header => _headers;
}
