//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import '../models/SharedPref.dart';
import '../models/auth_to_service.dart';

class GAuth extends StatefulWidget {
  @override
  _GAuthState createState() => _GAuthState();
}

class _GAuthState extends State<GAuth> {
  AuthServ attemptSignIn = AuthServ();

  String displayName;

  String userId;

  String email;

  String accessToken;

  String photoUrl;

  SharedPref prefs = SharedPref();

  @override
  Widget build(BuildContext context) {
    void logwithG() async {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      try {
        googleSignIn.signIn().then(
          (GoogleSignInAccount account) async {
            GoogleSignInAuthentication auth = await account.authentication;
            print(auth);
            displayName = account.displayName;
            email = account.email;
            userId = account.id;
            accessToken = auth.accessToken;
            photoUrl = account.photoUrl;

            prefs.saveID(userId);
            prefs.setDisplayName(displayName);
            prefs.setEmail(email);
            prefs.setPhotoUrl(photoUrl);
            prefs.setAccessToken(accessToken);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MyBottomNavigationBar(),
              ),
            );
          },
        );
      } catch (e) {
        throw Exception(e);
      }
    }

    return Container(
      width: 200,
      child: FlatButton(
        color: Color.fromRGBO(52, 122, 246, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          logwithG();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/icons/google.png',
              width: 30,
              height: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login with Google',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
