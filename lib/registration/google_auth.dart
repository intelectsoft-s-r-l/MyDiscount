import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guid_gen/Screens/Home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//import '../Screens/Home_screen.dart';

class GAuth extends StatefulWidget {
  @override
  _GAuthState createState() => _GAuthState();
}

class _GAuthState extends State<GAuth> {
  
  var islogin = false;

  String _displayName;

  String _userId;

  String _email;

  String _accessToken;

  String _photoUrl;
  String data;
  void logwithG() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    googleSignIn.signIn().then(
      (GoogleSignInAccount account) async {
        GoogleSignInAuthentication auth = await account.authentication;
        print(auth.accessToken);
        _displayName = account.displayName;
        _email = account.email;
        _userId = account.id;
        _accessToken = auth.accessToken;
        _photoUrl = account.photoUrl;
        attemptSignIn(_displayName, _email, _userId, _photoUrl, _accessToken);Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
      },
    );
  }

  Future<void> attemptSignIn(String _displayName, String _email, String _userId,
      String _photoUrl, String _accessToken) async {
    String credentials = "appuser:frj936epae293e9c6epae29";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Basic ' + encoded,
    };//http://5.181.156.96:8585/AppCardService/json/GetTID
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
    final prefs = await SharedPreferences.getInstance();
    final userData = response.body;
     /* data =  */ prefs.setString('userData', userData);
    print(userData);
    print(response.body);
    /* if (response.body != null) {
      setState(
        () {
          islogin = !islogin;
        },
      );
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 166,
      child: FlatButton(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          logwithG();
        },
        child: Text('Signin with Google'),
      ),
    );
  }
}
