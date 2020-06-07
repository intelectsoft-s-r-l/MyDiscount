import 'dart:convert';


import 'package:http/http.dart'as http;

class AuthServ {

  Future<void> attemptSignIn(String displayName,String email, String userId, String photoUrl,String accessToken) async {
  String credentials = "appuser:frj936epae293e9c6epae29";
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encoded = stringToBase64.encode(credentials);
  Map<String, String> headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + encoded,
  };
  const url = 'http://5.181.156.96:8585/AppCardService/json/Register';
  final response = await http.post(url,
      headers: headers,
      body: json.encode({
        "DisplayName": displayName,
        "Email": email,
        "ID": userId,
        "PhotoUrl": photoUrl,
        "RegisterMode": '',
        "access_token": accessToken,
        "pw": "",
        "refresh_token": "",
        "token_type": ""
      }));
  print(response);
}
}