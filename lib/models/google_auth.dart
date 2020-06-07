import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Screens/Home_screen.dart';

class GAuth extends StatelessWidget {
  void logwithG() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    googleSignIn.signIn().then(
      (GoogleSignInAccount account) async {
        GoogleSignInAuthentication auth = await account.authentication;
        print(account);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.red,
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
      child: Text('Login with Google'),
    );
  }
}
