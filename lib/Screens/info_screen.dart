import 'package:flutter/material.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Log_in_Screen.dart';
import 'app_localizations.dart';

class Info extends StatelessWidget {
  void signOut() async {
    //final FacebookLogin _facebookLogin = FacebookLogin();
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    final prefs = await SharedPreferences.getInstance();
    //_facebookLogin.logOut();
    googleSignIn.signOut();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 86, 198, 1),
        title: Text(
          AppLocalizations.of(context).translate('text9'),
          style: TextStyle(fontSize: 30),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(MdiIcons.locationExit),
            onPressed: () {
              signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          child: Center(
            child: Text(
              AppLocalizations.of(context).translate('Info'),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
