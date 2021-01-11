import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flushbar/flushbar_helper.dart';

import '../main.dart';
import '../core/localization/localizations.dart';
import '../services/shared_preferences_service.dart';
import '../services/auth_service.dart';
import '../services/internet_connection_service.dart';
import '../widgets/login_button_widget.dart';

class LoginScreen2 extends StatefulWidget {
  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final NetworkConnectionImpl internet = NetworkConnectionImpl();
  final AuthService data = AuthService();
  SharedPref _pref = SharedPref();
  @override
  void initState() {
    getAuthState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    void _authorize(future, context) async {
      future.whenComplete(() async {
        final prefs = await _pref.instance;
        if (prefs.containsKey('user') && prefs.containsKey('profile')) {
          Navigator.of(context).pushReplacementNamed('/app');
        }
      });
    }

    void getAuthorizationApple() async {
      if (await internet.isConnected) {
        _authorize(data.signInWithApple(), context);
      } else {
        FlushbarHelper.createError(
                message: AppLocalizations.of(context).translate('text6'))
            .show(context); 
      }
    }

    void getAuthorizationGoogle() async {
      if (await internet.isConnected) {
        _authorize(data.logwithG(), context);
      } else {
        FlushbarHelper.createError(
                message: AppLocalizations.of(context).translate('text6'))
            .show(context);
      }
    }

    void getAuthorizationFB() async {
      if (await internet.isConnected) {
        _authorize(data.authWithFacebook(), context);
      } else {
        FlushbarHelper.createError(
                message: AppLocalizations.of(context).translate('text6'))
            .show(context); 
      }
    }

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
                      ),
                      textScaleFactor: 1.5,
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
                      fontWeight: FontWeight.bold,
                    ),
                    textScaleFactor: 1.5,
                  ),
                ),
                SizedBox(
                  height: size.height * .065,
                ),
                LoginButton(
                  size: size,
                  function: getAuthorizationGoogle,
                  picture: 'assets/icons/icon_google.svg',
                  text: AppLocalizations.of(context).translate('text15'),
                  color: Color(0xFF406BFB),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                LoginButton(
                  size: size,
                  function: getAuthorizationFB,
                  picture: 'assets/icons/icon_facebook.svg',
                  text: AppLocalizations.of(context).translate('text16'),
                  color: Color(0xFF2D4CB3),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                Platform.isIOS
                    ? LoginButton(
                        size: size,
                        function: getAuthorizationApple,
                        picture: 'assets/icons/icon_apple.svg',
                        text: AppLocalizations.of(context).translate('text17'),
                        color: Colors.black,
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
