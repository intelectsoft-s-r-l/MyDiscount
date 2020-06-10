import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:guid_gen/Screens/Log_in_Screen.dart';
//import 'package:guid_gen/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Screens/Home_screen.dart';

class FbLogin extends StatefulWidget {
  @override
  _FbLoginState createState() => _FbLoginState();
}

class _FbLoginState extends State<FbLogin> {
  String displayName;

  String userId;

  String email;

  String accessToken;

  String photoUrl;



  final FacebookLogin _facebookLogin = FacebookLogin();

  Future<void> authFb() async {
    final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken _accessToken = result.accessToken;

        final _graphResponse = await http.get(
            'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=${_accessToken.token}');
        var profile = json.decode(_graphResponse.body);
        displayName = profile['name'];
        email = profile['email'];
        userId = _accessToken.userId;

        print(_accessToken.userId);
        if (_accessToken != null) {
          attemptSignIn(displayName, email, userId, photoUrl, accessToken);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          print('error');        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        break;
      case FacebookLoginStatus.error:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
        break;
    }
  }

  Future<void> attemptSignIn(String displayName, String email, String userId,
      String photoUrl, String accessToken) async { 
    String credentials = "appuser:frj936epae293e9c6epae29";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      'Content-type': 'application/json; charset=utf-8',
      'Authorization': 'Basic ' + encoded,
    };
    const url = 'http://5.181.156.96:8585/AppCardService/json/GetTID';
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
    print(response.body);
    final prefs = await SharedPreferences.getInstance();
    final userData = response.body;
    prefs.setString('userData', userData);
    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 166,
      child: FlatButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          authFb();
        },
        child: Text('Login with Facebook'),
      ),
    );
  }
}
