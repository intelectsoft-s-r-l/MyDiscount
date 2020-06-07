import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import '../Screens/Home_screen.dart';

class GAuth extends StatelessWidget {
  String _displayName;
  String _userId;
  String _email;
  String _accessToken;
  String _photoUrl;
  void logwithG() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    googleSignIn.signIn().then(
      (GoogleSignInAccount account) async {
        GoogleSignInAuthentication auth = await account.authentication;
        print(auth);
        _displayName = account.displayName;
        _email = account.email;
        _userId = account.id;
        _accessToken = auth.accessToken;
        _photoUrl = account.photoUrl;
        attemptSignIn(_displayName, _email, _userId, _photoUrl, _accessToken);
      },
    );
  }
  Future<void> attemptSignIn(String _displayName,String _email, String _userId, String _photoUrl,String _accessToken) async {
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
        "DisplayName": _displayName,
        "Email": _email,
        "ID": _userId,
        "PhotoUrl": _photoUrl,
        "RegisterMode": '',
        "access_token": _accessToken,
        "pw": "",
        "refresh_token": "",
        "token_type": ""
      }));
  print(response.body);}

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: () {
        logwithG();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
      child: Text('Login with Google'),
    );
  }
}
