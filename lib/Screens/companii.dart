import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/app_localizations.dart';
import 'Log_in_Screen.dart';

class Companies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void signOut() async {
      final FacebookLogin _facebookLogin = FacebookLogin();
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final prefs = await SharedPreferences.getInstance();
      _facebookLogin.logOut();
      googleSignIn.signOut();
      prefs.clear();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 86, 198, 1),
        title: Text(
          AppLocalizations.of(context).translate('companies'),
          style: TextStyle(fontSize: 30),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.locationExit),
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
      body: Container(
        child: FutureBuilder<dynamic>(
          future: setupRemoteConfig(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print(snapshot.data);
            return snapshot.hasData
                ? WelcomeWidget(remoteConfig: snapshot.data)
                : Container(
                    child: Center(child: const CircularProgressIndicator()),
                  );
          },
        ),
      ),
    );
  }
}

class WelcomeWidget extends AnimatedWidget {
  WelcomeWidget({this.remoteConfig}) : super(listenable: remoteConfig);

  final RemoteConfig remoteConfig;

  @override
  Widget build(BuildContext context) {
    var companies = json.decode(remoteConfig.getString('list_companies'))
        as Map<String, dynamic>;
    var list = companies['companies'] as List;
    return Scaffold(
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: Container(
                width: 60,
                height: 60,
                child: Image.network(
                  '${list[index]['image']}',
                )),
            title: Text(
              '${list[index]['name']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<RemoteConfig> setupRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

  remoteConfig.fetch(expiration: const Duration(seconds: 0));
  remoteConfig.activateFetched();

  return remoteConfig;
}
