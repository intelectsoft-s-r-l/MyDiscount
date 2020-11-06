import 'dart:io';

import 'package:MyDiscount/services/auth_service.dart';
import 'package:MyDiscount/services/internet_connection_service.dart';
import 'package:MyDiscount/widgets/widgets/localizations.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginScreen2 extends StatefulWidget {
  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final AuthService data = AuthService();
  @override
  void initState() {
    getAuthState();
    super.initState();
  }

  final InternetConnection internet = InternetConnection();

  @override
  Widget build(BuildContext context) {
    getDialog() {
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

    void getAuthorizationApple() async {
      final status = await internet.verifyInternetConection();
      switch (status) {
        case DataConnectionStatus.connected:
          data.signInWithApple().whenComplete(() async {
            final prefs = await SharedPreferences.getInstance();
            if (prefs.containsKey('credentials')) {
              authController.sink.add(true);
              Navigator.pushNamed(context, '/qrpage');
            }
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
          data.logwithG(context);
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
            () async {
              final prefs = await SharedPreferences.getInstance();
              if (prefs.containsKey('credentials')) {
                authController.sink.add(true);
                Navigator.pushNamed(context, '/qrpage');
              }
            },
          );
          break;
        case DataConnectionStatus.disconnected:
          getDialog();
      }
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                  height: size.height * .45,
                  width: size.width,
                  child: Image.asset(
                    'assets/icons/Group.png',
                    fit: BoxFit.fill,
                  )),
              Positioned(
                left: 0.0,
                top: size.height * .052,
                child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    child: Text(
                      'Welcome to MyDiscount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                      maxLines: 2,
                    )),
              ),
            ],
          ),
          Container(
            height: size.height * .5,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * .09,
                ),
                Container(
                  height: 40,
                  width: size.width * .82,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Sign in with:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .065,
                ),
                FlatButton(
                  onPressed: () {
                    getAuthorizationGoogle();
                  },
                  child: Container(
                    height: 40,
                    width: size.width * .82,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF406BFB),
                      //border: Border.all(width: 2, color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        SvgPicture.asset(
                          'assets/icons/icon_google.svg',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                FlatButton(
                  onPressed: () {
                    getAuthorizationFB();
                  },
                  child: Container(
                    height: 40,
                    width: size.width * .82,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF2D4CB3),
                      //border: Border.all(width: 2, color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        SvgPicture.asset(
                          'assets/icons/icon_facebook.svg',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sign in with Facebook',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                Platform.isIOS
                    ? FlatButton(
                        onPressed: () {
                         getAuthorizationApple();
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Container(
                          height: 40,
                          width: size.width * .82,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            // border: Border.all(width: 2, color: Colors.grey[300]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              SvgPicture.asset(
                                'assets/icons/icon_apple.svg',
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Sign in with Apple',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                /* Container(
            height: 40,
            width: size.width * .8,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              // border: Border.all(width: 2, color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [SizedBox(
                  width: 20,
                ),
                SvgPicture.asset(
                  'assets/icons/icon_apple.svg',
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Sign in with Apple',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ), */
              ],
            ),
          ),
          SizedBox(
            height: size.height * .01,
          ),
          Text('Privacy policy'),
        ],
      ),
      /*  ), */
    );
  }
}
