import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Screens/Home_screen.dart';

class FbAuth extends StatelessWidget {
  final FacebookLogin _facebookLogin = FacebookLogin();

  Future<void> authFb() async {
    FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken _accessToken = result.accessToken;

        final _graphResponse = await http.get(
            'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=${_accessToken.token}');
        var profile = json.decode(_graphResponse.body);

        print(_accessToken);
        if (_accessToken != null) {
        } else {
          print('error');
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
      child: Text('Login with Facebook'),
    );
  }
}
