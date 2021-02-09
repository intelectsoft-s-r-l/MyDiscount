import 'dart:io';

import 'package:MyDiscount/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../core/localization/localizations.dart';
import '../widgets/login_button_widget.dart';

class LoginScreen2 extends StatelessWidget {
  const LoginScreen2();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthorizationProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
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
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textScaleFactor: 1.5,
                      maxLines: 2,
                    )),
              ),
            ],
          ),
          SizedBox(
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
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    textScaleFactor: 1.2,
                  ),
                ),
                SizedBox(
                  height: size.height * .065,
                ),
                LoginButton(
                  size: size,
                  function: provider.getAuthorizationGoogle, // getAuthorizationGoogle,
                  picture: 'assets/icons/icon_google.svg',
                  text: AppLocalizations.of(context).translate('text15'),
                  color: const Color(0xFF406BFB),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                LoginButton(
                  size: size,
                  function: provider.getAuthorizationFB, //getAuthorizationFB,
                  picture: 'assets/icons/icon_facebook.svg',
                  text: AppLocalizations.of(context).translate('text16'),
                  color: const Color(0xFF2D4CB3),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                Platform.isIOS
                    ? LoginButton(
                        size: size,
                        function: provider.getAuthorizationApple,
                        picture: 'assets/icons/icon_apple.svg',
                        text: AppLocalizations.of(context).translate('apple'),
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
