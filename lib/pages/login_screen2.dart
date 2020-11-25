import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/localizations.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../services/internet_connection_service.dart';
import '../widgets/no_internet_dialog.dart';

class LoginScreen2 extends StatefulWidget {
  final NetworkConnectionImpl internet = NetworkConnectionImpl();

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

  @override
  Widget build(BuildContext context) {
   

    void getAuthorizationApple() async {
      if (await widget.internet.isConnected) {
        data.signInWithApple().whenComplete(() async {
          final prefs = await SharedPreferences.getInstance();
          if (prefs.containsKey('credentials')) {
            authController.sink.add(true);
            Navigator.pushNamedAndRemoveUntil(context, '/qrpage' ,(Route<dynamic> route)=>false);
          }
        });
      } else {
        getDialog(context);
      }
    }

    void getAuthorizationGoogle() async {
      if (await widget.internet.isConnected) {
        data.logwithG(context).whenComplete(() async {
          final prefs = await SharedPreferences.getInstance();
          if (prefs.containsKey('credentials')) {
            authController.sink.add(true);
            Navigator.pushNamedAndRemoveUntil(context, '/qrpage' ,(Route<dynamic> route)=>false);
          }
        });
      } else {
        getDialog(context);
      }
    }

    void getAuthorizationFB() async {
      if (await widget.internet.isConnected) {
        data.authWithFacebook().whenComplete(
          () async {
            final prefs = await SharedPreferences.getInstance();
            if (prefs.containsKey('credentials')) {
              authController.sink.add(true);
              Navigator.pushNamedAndRemoveUntil(context, '/qrpage' ,(Route<dynamic> route)=>false);
            }
          },
        );
      } else {
        getDialog(context);
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
                      AppLocalizations.of(context).translate('text18'),
                      style: TextStyle(
                        color: Colors.white,
                        //fontSize: 30,
                      ),textScaleFactor: 1.5,
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
                    AppLocalizations.of(context).translate('text12'),
                    style: TextStyle(
                      color: Colors.black,
                      //fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),textScaleFactor: 1.5,
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
                          AppLocalizations.of(context).translate('text15'),
                          style: TextStyle(
                            color: Colors.white,
                            //fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),textScaleFactor: 1.5,
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
                          AppLocalizations.of(context).translate('text16'),
                          style: TextStyle(
                            color: Colors.white,
                            //fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),textScaleFactor:1.5,
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
                                AppLocalizations.of(context).translate('text17'),
                                style: TextStyle(
                                  color: Colors.white,
                                  //fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),textScaleFactor: 1.5,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
         /*  SizedBox(
            height: size.height * .01,
          ),
          Text('Privacy policy'), */
        ],
      ),
      /*  ), */
    );
  }
}
