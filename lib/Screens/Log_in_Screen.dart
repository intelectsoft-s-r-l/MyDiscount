import 'package:flutter/material.dart';
import '../models/facebook_auth.dart';
import '../models/google_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _StateLoginPage createState() => _StateLoginPage();
}

class _StateLoginPage extends State<LoginPage> {
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
         backgroundColor: Color.fromRGBO(42, 86, 198, 1),
        title: Text(
          'Y-Qr',
          style: TextStyle(fontSize: 30),
        ),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GAuth(),
                FbAuth(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
