import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class User {
  final String id;
  User({@required this.id});
}

class Credential with ChangeNotifier {
  String displayName;
  String userId;
  String email;
  String accessToken;
  String photoUrl;

  /* Credential(
    // this.displayName,
    // this.userId,
    this.email,
    // this.accessToken,
    // this.photoUrl,
  ); */
  FacebookLogin _facebookLogin = FacebookLogin();

  Future<void> authFb() async {
    FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken _accessToken = result.accessToken;

        final _graphResponse = await http.get(
            'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=${_accessToken.token}');
        var profile = json.decode(_graphResponse.body);
        // displayName = '${profile['name']}';
        // email = '${profile['email']}';
        userId = '${_accessToken.userId}';
        // accessToken = '${_accessToken.token}';
        // photoUrl = '${profile['picture']['data']['url']}';
        print(accessToken);
        if (_accessToken != null) {
          attemptSignIn();
        } else {
          print('error');
        }
        notifyListeners();
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  void logwithG() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    googleSignIn.signIn().then(
      (GoogleSignInAccount account) async {
        GoogleSignInAuthentication auth = await account.authentication;
        // displayName = '${account.displayName}';
        // email = '${account.email}';
        userId = '${account.id}';
        // accessToken = '${auth.accessToken}';
        // photoUrl = '${account.photoUrl}';
        print(account);
        attemptSignIn();
      },
    );
  }
}
Credential data = Credential( );
Future<void> attemptSignIn() async {
  String credentials = "appuser:frj936epae293e9c6epae29";
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encoded = stringToBase64.encode(credentials);
  Map<String, String> headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + encoded,
  };
  final url = 'http://5.181.156.96:8585/AppCardService/json/Register';
  final response = await http.post(url,
      headers: headers,
      body: json.encode({
        "DisplayName": data.displayName,
        "Email": data.email,
        "ID": data.userId,
        "PhotoUrl": data.photoUrl,
        "RegisterMode": '',
        "access_token": data.displayName,
        "pw": "",
        "refresh_token": "",
        "token_type": ""
      }));
  print(response);
}
