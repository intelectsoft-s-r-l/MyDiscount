

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:guid_gen/models/auth_to_service.dart';
//import 'package:guid_gen/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Screens/Home_screen.dart';

class FbAuth extends StatelessWidget {
  AuthServ attemptSignIn = AuthServ();
  String displayName;
  String userId;
  String email;
  String accessToken;
  String photoUrl;

  
  @override
  Widget build(BuildContext context) {
  final FacebookLogin _facebookLogin = FacebookLogin();
 
  Future<void> authFb() async {
    FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken _accessToken = result.accessToken;

        final _graphResponse = await http.get(
            'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=${_accessToken.token}');
        var profile = json.decode(_graphResponse.body);
         displayName= profile['name'];
         email = profile['email'];
         userId = _accessToken.userId;

        print(_accessToken.token);
        if (_accessToken != null) {
          attemptSignIn.attemptSignIn(displayName, email, userId, photoUrl, accessToken);
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
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
    return FlatButton(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: () {
        authFb();
        
      },
      child: Text('Login with Facebook'),
    );
  }
}
