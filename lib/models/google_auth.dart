import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guid_gen/models/SharedPref.dart';
import 'package:guid_gen/models/auth_to_service.dart';
// import 'package:http/http.dart'as http;
// import 'dart:convert';
import '../Screens/Home_screen.dart';

class GAuth extends StatefulWidget {
  @override
  _GAuthState createState() => _GAuthState();
}

class _GAuthState extends State<GAuth> {
   bool isLoged = false;

  AuthServ attemptSignIn = AuthServ();

  String displayName;

  String userId;

  String email;

  String accessToken;

  String photoUrl;

  SharedPref perfs = SharedPref();

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
          displayName = account.displayName;
          email = account.email;
          userId = account.id;
          accessToken = auth.accessToken;
          photoUrl = account.photoUrl;
          //save to shared preference
          perfs.saveResp(userId);
          var testTest = false;
          testTest = await attemptSignIn.attemptSignIn(
              displayName, email, userId, photoUrl, accessToken);
            
          if (testTest) {
            setState(() {
              isLoged = !isLoged;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
        },
      );
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
        child: Row(mainAxisAlignment:MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/icons/google.png',
              width: 30,
              height: 30,
            ),SizedBox(width: 10,),
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
