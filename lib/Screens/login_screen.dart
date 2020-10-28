/* import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/localizations.dart';
import '../services/internet_connection_service.dart';
import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService data = AuthService();
    InternetConnection internet = InternetConnection();

    getDialog() {
      if (Platform.isAndroid) {
        showDialog(
          context: (context),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Container(
                height: 150,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 100,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate('text6') + '!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        child: Text(
                          AppLocalizations.of(context).translate('text8'),
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        showCupertinoDialog(
          context: (context),
          builder: (_) => CupertinoAlertDialog(
            title: Text(
              AppLocalizations.of(context).translate('text6') + '!',
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  AppLocalizations.of(context).translate('text8'),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    }

    void getAuthorizationApple() async {
      final status = await internet.verifyInternetConection();
      switch (status) {
        case DataConnectionStatus.connected:
          data.signInWithApple().whenComplete(()async{ final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('credentials')) authController.sink.add(true);
      });
          break;
        case DataConnectionStatus.disconnected:
          getDialog();
      }
    }

    void getAuthorizationGoogle() async {
      final status = await internet.verifyInternetConection();
      switch (status) {
        case DataConnectionStatus.connected:
          data.logwithG();
          break;
        case DataConnectionStatus.disconnected:
          getDialog();
      }
    }

    void getAuthorizationFB() async {
      final status = await internet.verifyInternetConection();
      switch (status) {
        case DataConnectionStatus.connected:
          data.authWithFacebook().whenComplete(
            ()async {
               final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('credentials')) authController.sink.add(true);
      
            },
          );
          break;
        case DataConnectionStatus.disconnected:
          getDialog();
      }
    }

    return Container(
      decoration: const BoxDecoration(
        color: const Color.fromRGBO(240, 242, 241, 1),
      ),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('text12'),
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          getAuthorizationGoogle();
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Image.asset('assets/icons/google_logo.png'),
                        ),
                      ),
                    ),
                    Platform.isIOS
                        ? const SizedBox(width: 20)
                        : const SizedBox(width: 40),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          getAuthorizationFB();
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Image.asset('assets/icons/Facebook_Logo.png'),
                        ),
                      ),
                    ),
                    Platform.isIOS ? const SizedBox(width: 20) : Container(),
                    Platform.isIOS
                        ? Container(
                            child: GestureDetector(
                              onTap: () {
                                getAuthorizationApple();
                              },
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child:
                                    Image.asset('assets/icons/apple_logo.png'),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 */