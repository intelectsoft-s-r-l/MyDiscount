import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../main.dart';
import '../models/SharedPref.dart';
import '../models/auth_to_service.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class FbAuth extends StatefulWidget {
  @override
  _FbAuthState createState() => _FbAuthState();
}

class _FbAuthState extends State<FbAuth> {
  AuthServ attemptSignIn = AuthServ();

  String displayName;

  String userId;

  String email;

  String accessToken;

  String photoUrl;

  SharedPref prefs = SharedPref();

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
          email = profile['email'];
          userId = _accessToken.userId;
          displayName = profile['name'];
          photoUrl = profile['picture']['data']['url'];
          accessToken = _accessToken.token;
          print(photoUrl);

          prefs.saveID(userId);
          prefs.setDisplayName(displayName);
          prefs.setEmail(email);
          prefs.setPhotoUrl(photoUrl);
          prefs.setAccessToken(accessToken);

          if (_accessToken != null) {
            await attemptSignIn.attemptSignIn();

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MyBottomNavigationBar(),
              ),
            );
          } else {
            print('error');
          }
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
        SnackBar(content: Text('Error',),);
          break;
      }
    }

    return Container(
      width: 200,
      child: FlatButton(
        color: Color.fromRGBO(65, 90, 147, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          authFb();
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Image.asset(
                'assets/icons/redf.png',
                width: 30,
                height: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login with Facebook',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
