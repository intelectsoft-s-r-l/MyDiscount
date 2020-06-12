import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:guid_gen/models/auth_to_service.dart';
//import 'package:guid_gen/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Screens/Home_screen.dart';

class FbAuth extends StatelessWidget {
  
  AuthServ attemptSignIn = AuthServ();
  String _displayName;
  String _userId;
  String _email;
  String _accessToken;
  String _photoUrl;
  

  @override
  Widget build(BuildContext context) {
    final FacebookLogin _facebookLogin = FacebookLogin();

    Future<void> authFb() async {
      FacebookLoginResult result = await _facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          FacebookAccessToken accessToken = result.accessToken;

          final _graphResponse = await http.get(
              'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=${accessToken.token}');
          var profile = json.decode(_graphResponse.body);
          _email = profile['email'];
          _userId = accessToken.userId;

          print(accessToken.token);
          if (accessToken != null) {
            attemptSignIn.attemptSignIn( _displayName, _email, _userId, _photoUrl, _accessToken );
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
