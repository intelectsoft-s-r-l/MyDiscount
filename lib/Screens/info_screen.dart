import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Log_in_Screen.dart';

class Info extends StatelessWidget {
  removeSharedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void signoutFb() {
    FacebookLogin _facebookLogin = FacebookLogin();
    _facebookLogin.logOut();

    print("1");
  }

  void signOut() {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
    googleSignIn.signOut();
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 86, 198, 1),
        title: Text(
          'About',
          style: TextStyle(fontSize: 30),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              signoutFb();
              signOut();
              removeSharedData();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Text('data'),
      ),
    );
  }
}
