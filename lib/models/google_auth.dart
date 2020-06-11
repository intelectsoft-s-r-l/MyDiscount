import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guid_gen/models/auth_to_service.dart';
// import 'package:http/http.dart'as http;
// import 'dart:convert';
import '../Screens/Home_screen.dart';

class GAuth extends StatelessWidget {
  AuthServ  attemptSignIn = AuthServ();
  String _displayName;
  String _userId;
  String _email;
  String _accessToken;
  String _photoUrl;
  

  @override
  Widget build(BuildContext context) {
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
        attemptSignIn.attemptSignIn(_displayName, _email, _userId, _photoUrl, _accessToken);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
    );
  }
  
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
