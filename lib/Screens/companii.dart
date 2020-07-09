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
            return snapshot.hasData && snapshot.data != null
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
        body: list.length != 0
            ? ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: list.length,
                itemBuilder: (context, index) => Card(
                  //color: Colors.amber,
                  elevation: 2.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: Container(
                        width: 60,
                        height: 60,
                        child: Image.memory(
                          Base64Decoder().convert('${list[index]['images']}'),
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
              )
            : Container(
                alignment: Alignment.center,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Image.asset('assets/icons/companie.jpg'),
                    Text(
                      AppLocalizations.of(context).translate('text13'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text14'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ));
  }
}

Future<RemoteConfig> setupRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

  remoteConfig.fetch(expiration: const Duration(seconds: 0));
  remoteConfig.activateFetched();

  return remoteConfig;
}
